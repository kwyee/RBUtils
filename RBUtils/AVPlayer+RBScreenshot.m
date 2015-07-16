//
//  AVPlayer+RBScreenshot.m
//  RBUtils
//
//  Created by Kenson Yee on 7/16/15.
//  Copyright (c) 2015 RandomBits. All rights reserved.
//

#import "AVPlayer+RBScreenshot.h"

@implementation AVPlayer (RBScreenshot)
- (UIImage *)screenshotAtTime:(CMTime)time
{

    CMTime actualTime;
    NSError *error;

    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:self.currentItem.asset];

    // Setting a maximum size is not necessary for this code to
    // successfully get a screenshot, but it was useful for my project.
    //  generator.maximumSize = maxSize;

    CGImageRef cgIm = [generator copyCGImageAtTime:time
                                        actualTime:&actualTime
                                             error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgIm];
    CFRelease(cgIm);

    if (nil != error) {
        NSLog(@"Error making screenshot: %@", [error localizedDescription]);
        NSLog(@"Actual screenshot time: %f Requested screenshot time: %f", CMTimeGetSeconds(actualTime),
              CMTimeGetSeconds(time));
        return nil;
    }

    return image;
}

@end
