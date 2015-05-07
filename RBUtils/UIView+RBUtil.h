
#import <UIKit/UIKit.h>

@interface UIView (PSUtil)

- (void)adjustFrame:(CGFloat)dx
                dy:(CGFloat)dy
                dw:(CGFloat)dw
                dh:(CGFloat)dh;

// Scale with 0,0 (e.g. top left) origin
- (void)scaleFrameX:(CGFloat)x y:(CGFloat)y;



- (void)setFrameX:(CGFloat)x
               y:(CGFloat)y
               w:(CGFloat)w
               h:(CGFloat)h;

- (void)setFrameX:(CGFloat)x
               y:(CGFloat)y;
- (void)setFrameW:(CGFloat)w
               h:(CGFloat)h;
- (void)setFrameX:(CGFloat)x
               w:(CGFloat)w;
- (void)setFrameY:(CGFloat)y
               h:(CGFloat)h;
- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameW:(CGFloat)w;
- (void)setFrameH:(CGFloat)h;

// The default UIView implementation is sizeThatFits: and doesn't do anything meaningful.
// Returns the bounding box of the subviews, in self's coordinates.
- (CGSize)sizeThatFits;

@end


#pragma mark -
@interface UIView (Centering)
- (void)centerInSuperview;
@end


#pragma mark -
// All the (2d) info required to freeze / thaw the state of the view.
// Transform converts your view’s bounds/coords system into its parent’s
// So if my bounds is 100x100 and my transform is [0.5, 0, 0, 0.5, 0, 0] then i will be 50x50 with the same center
//
// Transform is also relative to the view.center so if I have an identity transform and view.center = 100,100 then the center of the view will be at 100,100.
// If I then have a transform with translation = 50,50 and same 100,100 center then the center of the view will be rendered at 150,150
typedef struct {
    CGAffineTransform transform;
    CGPoint center;
    CGRect bounds;
} UIViewState;

@interface UIView (UIViewState)
- (UIViewState)viewState;
- (void)setViewState:(UIViewState)state;
// srcSuperview is the superview of the view that gave you state.
- (UIViewState)convertViewState:(UIViewState)state fromView:(UIView *)srcSuperview;
FOUNDATION_EXTERN NSString *NSStringFromUIViewState(UIViewState vs);
@end

#pragma mark -
@interface UIView (FindUIViewController)
- (UIViewController *)firstAvailableUIViewController;
@end



#pragma mark -
@interface UIView (PixelAlign)
// Change self.center so its left and top are non-floating point numbers
- (void)integralTopLeft;

// Apply integralTopLeft to its subviews recursively
- (void)integralTopLeftRecursive;
@end

#pragma mark -
@interface UIView (Transformation)
- (void)setCubeRotationTransformWithTheta:(CGFloat)theta;
@end


#pragma mark -
@interface UIView (ViewOfType)
// Recursively look for a subview
- (UIView *)descendantViewOfType:(Class)type;
@end


