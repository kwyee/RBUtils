//
//  PSUtilMath.h
//  PocketSteam
//
//  Created by Kenson Yee on 5/6/15.
//  Copyright (c) 2015 RandomBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface RBUtilMath : NSObject

/* 2 * pi */
#ifndef M_2x_PI
#define M_2x_PI 6.28318530718
#endif

FOUNDATION_EXTERN NSString *NSStringFromCATransform3D(struct CATransform3D transform);

FOUNDATION_EXTERN BOOL CGAffineTransformDecompose(CGAffineTransform t,
                                                  CGAffineTransform *rotation,
                                                  CGAffineTransform *scale,
                                                  CGAffineTransform *translation);

FOUNDATION_EXTERN CGAffineTransform CGAffineTransformTranslateWorld(CGAffineTransform  t1,
                                                                    CGFloat tx,
                                                                    CGFloat ty);
FOUNDATION_EXTERN CGAffineTransform CGAffineTransformScaleWorld(CGAffineTransform  t1,
                                                                CGFloat sx,
                                                                CGFloat sy);
FOUNDATION_EXTERN CGAffineTransform CGAffineTransformRotateWorld(CGAffineTransform  t1,
                                                                 CGFloat radians);

FOUNDATION_EXTERN CGPoint CGRectGetCenter(CGRect r);

FOUNDATION_EXTERN CGFloat CGPointEuclideanDistance(CGPoint a, CGPoint b);

#define LINEAR_REMAP(srcPos, srcStart, srcEnd, destStart, destEnd) (((srcPos) - (srcStart)) / ((srcEnd) - (srcStart)) * ((destEnd) - (destStart)) + (destStart))

#define deg2rad(degrees) ( (degrees) / 180.0f * M_PI )
#define rad2deg(radians) ( (radians) * 180.0f / M_PI )

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

+ (BOOL)rand:(NSInteger)numerator in:(NSInteger)denominator;

+ (CGFloat)ratio2angle:(CGFloat)x y:(CGFloat)y;



+ (CGSize)ensureMaxSizeW:(CGFloat)originalW
                       h:(CGFloat)originalH
                    maxW:(CGFloat)maxW
                    maxH:(CGFloat)maxH;
+ (CGSize)ensureMinSizeW:(CGFloat)originalW
                       h:(CGFloat)originalH
                    minW:(CGFloat)minW
                    minH:(CGFloat)minH;

// Clamp between -PI to PI
+ (CGFloat)clampRadians:(CGFloat)radians;

+ (BOOL)isFlipped:(CGFloat)a :(CGFloat)b :(CGFloat)c :(CGFloat)d;

@end
