
#import "UIView+RBUtil.h"

#import "RBUtilMath.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

FOUNDATION_EXTERN NSString *NSStringFromUIViewState(UIViewState vs) {
    return [NSString stringWithFormat:@"b:%@ c:%@ t:%@",
            NSStringFromCGRect(vs.bounds),
            NSStringFromCGPoint(vs.center),
            NSStringFromCGAffineTransform(vs.transform) ];
}
#pragma mark -
@implementation UIView (PSUtil)

- (void)adjustFrame:(CGFloat)dx
                dy:(CGFloat)dy
                dw:(CGFloat)dw
                dh:(CGFloat)dh {
    CGRect newFrame = self.frame;
    newFrame.origin.x += dx;
    newFrame.origin.y += dy;
    newFrame.size.width += dw;
    newFrame.size.height += dh;

    self.frame = newFrame;
}
- (void)scaleFrameX:(CGFloat)x y:(CGFloat)y
{
    CGRect newFrame = self.frame;
    newFrame.origin.x *= x;
    newFrame.origin.y *= y;
    newFrame.size.width *= x;
    newFrame.size.height *= y;

    self.frame = newFrame;
}


- (void)setFrameX:(CGFloat)x
               y:(CGFloat)y
               w:(CGFloat)w
               h:(CGFloat)h {
    self.frame = CGRectMake(x,y,w,h);
}

- (void)setFrameX:(CGFloat)x
               y:(CGFloat)y {
    [self setFrameX:x
                  y:y
                  w:self.frame.size.width
                  h:self.frame.size.height
     ];
}
- (void)setFrameW:(CGFloat)w
               h:(CGFloat)h {
    [self setFrameX:self.frame.origin.x
                  y:self.frame.origin.y
                  w:w
                  h:h
     ];
}

- (void)setFrameX:(CGFloat)x w:(CGFloat)w
{
    [self setFrameX:x
                  y:self.frame.origin.y
                  w:w
                  h:self.frame.size.height
     ];
}
- (void)setFrameY:(CGFloat)y h:(CGFloat)h
{
    [self setFrameX:self.frame.origin.x
                  y:y
                  w:self.frame.size.width
                  h:h
     ];
}
- (void)setFrameX:(CGFloat)x
{
    [self setFrameX:x
                  y:self.frame.origin.y
                  w:self.frame.size.width
                  h:self.frame.size.height
     ];
}
- (void)setFrameY:(CGFloat)y
{
    [self setFrameX:self.frame.origin.x
                  y:y
                  w:self.frame.size.width
                  h:self.frame.size.height
     ];
}
- (void)setFrameW:(CGFloat)w
{
    [self setFrameX:self.frame.origin.x
                  y:self.frame.origin.y
                  w:w
                  h:self.frame.size.height
     ];
}
- (void)setFrameH:(CGFloat)h
{
    [self setFrameX:self.frame.origin.x
                  y:self.frame.origin.y
                  w:self.frame.size.width
                  h:h
     ];
}


- (CGSize)sizeThatFits
{
    if (!self.subviews.count) {
        return CGSizeZero;
    }

    CGFloat minX = CGFLOAT_MAX;
    CGFloat minY = CGFLOAT_MAX;
    CGFloat maxX = CGFLOAT_MIN;
    CGFloat maxY = CGFLOAT_MIN;

    for (UIView *v in self.subviews) {
        minX = MIN(minX, CGRectGetMinX(v.frame));
        minY = MIN(minY, CGRectGetMinY(v.frame));

        maxX = MAX(maxX, CGRectGetMaxX(v.frame));
        maxY = MAX(maxY, CGRectGetMaxY(v.frame));
    }
    return CGSizeMake(maxX - minX,
                      maxY - minY);
}

@end


#pragma mark -
@implementation UIView (Centering)

- (void)centerInSuperview
{
    self.center = CGRectGetCenter(self.superview.bounds);
    [self integralTopLeft];
}

@end



#pragma mark -
@implementation UIView (UIViewState)

- (UIViewState)viewState
{
    UIViewState state;
    state.transform = self.transform;
    state.center = self.center;
    state.bounds = self.bounds;
    return state;
}

- (void)setViewState:(UIViewState)state
{
    self.center = state.center;
    self.bounds = state.bounds;
    self.transform = state.transform;
}

- (UIViewState)convertViewState:(UIViewState)startState fromView:(UIView *)srcSuperview
{
    UIViewState newState;

    CGAffineTransform upTransform = startState.transform;
    upTransform = CGAffineTransformConcat(upTransform, CGAffineTransformMakeTranslation(startState.center.x, startState.center.y));
    UIView *nearestCommonAncestor = nil;
    for (UIView *v = srcSuperview; v; v = v.superview) {
        if ([self isDescendantOfView:v]) {
            nearestCommonAncestor = v;
            break;
        }

        // Previous translation was relative to the top left of this node.
        upTransform = CGAffineTransformConcat(upTransform, CGAffineTransformMakeTranslation(-v.bounds.size.width / 2.0f,
                                                                                            -v.bounds.size.height / 2.0f));
        if ([v isKindOfClass:[UIScrollView class]]) {
            // Also convert any content offset
            CGPoint offset = [(UIScrollView *)v contentOffset];
            upTransform = CGAffineTransformConcat(upTransform, CGAffineTransformMakeTranslation(-offset.x,
                                                                                                -offset.y));
        }
        upTransform = CGAffineTransformConcat(upTransform, v.transform);

        // Center is always in super coords, so do it last.
        upTransform = CGAffineTransformConcat(upTransform, CGAffineTransformMakeTranslation(v.center.x, v.center.y));
    }
    //    NSLog(@" up transform: -- %@", NSStringFromCGAffineTransform(upTransform));

    if (!nearestCommonAncestor) {
        DDAssert(nearestCommonAncestor, @" No common ancestor between %@ and %@", self, srcSuperview);
        return newState; // No common ancestor
    }


    // Going down the tree. We want A-inv * B-inv * C-inv.
    // But it's faster/easier to do (CBA)-inv.
    CGAffineTransform downTransform = CGAffineTransformIdentity;
    for (UIView *v = self.superview; v; v = v.superview) {

        downTransform = CGAffineTransformConcat(downTransform, CGAffineTransformMakeTranslation(-v.bounds.size.width / 2.0f,
                                                                                                -v.bounds.size.height / 2.0f));
        if ([v isKindOfClass:[UIScrollView class]] && v != nearestCommonAncestor) {
            // This considers the scroll offset, to convert the view to the parent's view coords but we shouldn't do this if it is the nearestCommonAncestor.
            CGPoint offset = [(UIScrollView *)v contentOffset];
            downTransform = CGAffineTransformConcat(downTransform, CGAffineTransformMakeTranslation(-offset.x,
                                                                                                    -offset.y));
        }
        downTransform = CGAffineTransformConcat(downTransform, v.transform);
        downTransform = CGAffineTransformConcat(downTransform, CGAffineTransformMakeTranslation(v.center.x, v.center.y));

        if (v == nearestCommonAncestor) {
            break;
        }
    }
    downTransform = CGAffineTransformInvert(downTransform);
    // NSLog(@" down transform: %@", NSStringFromCGAffineTransform(downTransform));

    newState.bounds = startState.bounds;
    newState.transform = CGAffineTransformConcat(upTransform, downTransform);
    newState.center = CGPointZero; // All encompassed in the transform.

    // NSLog(@"  dest state is  %@ ", NSStringFromUIViewState(newState));

    return newState;
}

@end



#pragma mark -
@implementation UIView (FindImageView)
- (UIImageView *)findHairlineImageViewUnder
{
    if ([self isKindOfClass:UIImageView.class] && self.bounds.size.height <= 1.0) {
        return (UIImageView *)self;
    }
    for (UIView *subview in self.subviews) {
        UIImageView *imageView = [subview findHairlineImageViewUnder];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end


#pragma mark -
@implementation UIView (FindUIViewController)
// from http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone
- (UIViewController *)firstAvailableUIViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder firstAvailableUIViewController];
    } else {
        return nil;
    }
}
@end



#pragma mark -
@implementation UIView (PixelAlign)
- (void)integralTopLeft
{
    CGPoint center = self.center;
    CGFloat left = center.x - self.bounds.size.width / 2.0f;
    CGFloat top = center.y - self.bounds.size.height / 2.0f;
    center.x = center.x + roundf(left) - left;
    center.y = center.y + roundf(top) - top;
    if (!CGPointEqualToPoint(self.center, center)) {
        self.center = center;
    }
}

- (void)integralTopLeftRecursive
{
    [self integralTopLeft];

    for (UIView *v in [self subviews]) {
        [v integralTopLeftRecursive];
    }
}
@end

#pragma mark -
@implementation UIView (Transformation)
- (void)setCubeRotationTransformWithTheta:(CGFloat)theta
{
    CGFloat halfWidth = self.bounds.size.width/2.0f;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/100000000000.0;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform,  theta, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);

    self.layer.transform = transform;
}
@end

#pragma mark -
@implementation UIView (SubviewTraversal)
- (UIView *)descendantViewOfType:(Class)type
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:type]) {
            return view;
        }
        UIView *matchingSubview = [view descendantViewOfType:type];
        if (matchingSubview) {
            return matchingSubview;
        }
    }
    return nil;
}
@end



