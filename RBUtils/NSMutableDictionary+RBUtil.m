//
//  NSMutableDictionary+RBUtil.m
//  PocketSteam
//
//  Created by Kenson Yee on 5/6/15.
//  Copyright (c) 2015 RandomBits. All rights reserved.
//

#import "NSMutableDictionary+RBUtil.h"

@implementation NSMutableDictionary (RBUtil)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

@end
