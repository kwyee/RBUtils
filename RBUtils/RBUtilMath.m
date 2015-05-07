//
//  PSUtilMath.m
//  PocketSteam
//
//  Created by Kenson Yee on 5/6/15.
//  Copyright (c) 2015 RandomBits. All rights reserved.
//

#import "RBUtilMath.h"

@implementation RBUtilMath

NSString *NSStringFromCATransform3D(struct CATransform3D transform)
{
    return [NSString stringWithFormat:@"%0.2f %0.2f %0.2f %0.2f\n%0.2f %0.2f %0.2f %0.2f\n%0.2f %0.2f %0.2f %0.2f\n%0.2f %0.2f %0.2f %0.2f",
            transform.m11, transform.m12, transform.m13, transform.m14,
            transform.m21, transform.m22, transform.m23, transform.m24,
            transform.m31, transform.m32, transform.m33, transform.m34,
            transform.m41, transform.m42, transform.m43, transform.m44
            ];
}

BOOL CGAffineTransformDecompose(CGAffineTransform t,
                                CGAffineTransform *rotation,
                                CGAffineTransform *scale,
                                CGAffineTransform *translation)
{

    double sx = sqrt(t.a * t.a  + t.b * t.b);
    if (!sx) {
        return FALSE;
    }

    if (scale) {
        *scale = CGAffineTransformMakeScale(sx, sx); // TODO(kwyee) handle non-equal-scale
    }

    if (rotation) {
        double angle = 0;
        if ([RBUtilMath isFlipped:t.a :t.b :t.c :t.d]) {
            angle = atan2(t.c, -t.a);
        } else {
            angle = atan2(t.c, t.a);
        }
        *rotation = CGAffineTransformMakeRotation(angle);
    }

    if (translation) {
        *translation = CGAffineTransformMakeTranslation(t.tx, t.ty);
    }

    return TRUE;

    //    {
    //        UIView *v1 = [[UIView alloc ]initWithFrame:CGRectMake(-0.5, -0.5, 1, 1)];
    //        v1.transform = CGAffineTransformConcat(v1.transform, CGAffineTransformMakeRotation(0.1));
    //        v1.transform = CGAffineTransformConcat(v1.transform, CGAffineTransformMakeTranslation(4, 1));
    //        v1.transform = CGAffineTransformConcat(v1.transform, CGAffineTransformMakeScale(15, 15));
    //        v1.backgroundColor = [UIColor greenColor];
    //        [self.view addSubview:v1];
    //
    //        UIView *v2 = [[UIView alloc ]initWithFrame:CGRectMake(-0.5, -0.5, 1, 1)];
    //        CGAffineTransform r;
    //        CGAffineTransform s;
    //        CGAffineTransform t;
    //        CGAffineTransformDecompose(v1.transform, &r, &s, &t);
    //        v2.transform = CGAffineTransformConcat(v2.transform, r);
    //        v2.transform = CGAffineTransformConcat(v2.transform, s);
    //        v2.transform = CGAffineTransformConcat(v2.transform, t);
    //        v2.backgroundColor = [UIColor redColor];
    //        v2.alpha = 0.5;
    //        [self.view addSubview:v2];
    //
    //        return;
    //    }
}

CGAffineTransform CGAffineTransformTranslateWorld(CGAffineTransform  t1,
                                                  CGFloat tx,
                                                  CGFloat ty)
{
    return CGAffineTransformConcat(t1, CGAffineTransformMakeTranslation(tx, ty));
}

CGAffineTransform CGAffineTransformScaleWorld(CGAffineTransform  t1,
                                              CGFloat sx,
                                              CGFloat sy)
{
    return CGAffineTransformConcat(t1, CGAffineTransformMakeScale(sx, sy));
}
CGAffineTransform CGAffineTransformRotateWorld(CGAffineTransform  t1,
                                               CGFloat radians)
{
    return CGAffineTransformConcat(t1, CGAffineTransformMakeRotation(radians));
}

+ (BOOL)isFlipped:(CGFloat)a :(CGFloat)b :(CGFloat)c :(CGFloat)d
{
    return a * d < 0 || b * c > 0;
}


CGPoint CGRectGetCenter(CGRect r)
{
    CGPoint p = {
        r.origin.x + r.size.width / 2,
        r.origin.y + r.size.height / 2
    };
    return p;
}

CGFloat CGPointEuclideanDistance(CGPoint a, CGPoint b)
{
    return hypotf(a.x - b.x, a.y  - b.y);
}


+ (CGSize)ensureMinSizeW:(CGFloat)originalW
                       h:(CGFloat)originalH
                    minW:(CGFloat)minW
                    minH:(CGFloat)minH
{
    CGSize size = CGSizeMake(originalW, originalH);
    CGFloat factor = MAX(minW / originalW, minW / originalH);
    if (factor > 1) {
        size.width *= factor;
        size.height *= factor;
    }
    return size;
}

+ (CGSize)ensureMaxSizeW:(CGFloat)originalW
                       h:(CGFloat)originalH
                    maxW:(CGFloat)maxW
                    maxH:(CGFloat)maxH
{
    CGSize size = CGSizeMake(originalW, originalH);
    CGFloat factor = MIN(maxW / originalW, maxH / originalH);
    if (factor < 1) {
        size.width *= factor;
        size.height *= factor;
    }
    return size;
}


+ (BOOL)rand:(NSInteger)numerator in:(NSInteger)denominator {
    return rand() % denominator < numerator;
}



+ (CGFloat)clampRadians:(CGFloat)radians
{
    if (radians >= 0) {
        radians = radians - (M_2x_PI) * floor(radians / (M_2x_PI));
        if (radians > M_PI) {
            radians = -M_2x_PI + radians;
        }
    } else {
        radians = radians - (M_2x_PI) * ceil(radians / (M_2x_PI));
        if (radians <= -M_PI) {
            radians = M_2x_PI + radians;
        }
    }

    return radians;
}



// Bound from 0 to 2 * math.pi
+ (CGFloat)ratio2angle:(CGFloat)x y:(CGFloat)y
{
    CGFloat a = atan2f(x, y);
    a = a + M_2x_PI;
    return a - floorf(a/M_2x_PI) * M_2x_PI;
}



@end
