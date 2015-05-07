
#import "NSArray+RBUtil.h"

@implementation NSArray (RBUtil)

- (id)safeObjectAtIndex:(NSInteger)idx
{
    if (!self.count) {
        return nil;
    }

    if (idx < 0) {
        return nil;
    }

    if (idx >= self.count) {
        return nil;
    }

    return [self objectAtIndex:idx];
}

- (id)safeObjectAtOffset:(NSInteger)idx
{
    if (!self.count) {
        return nil;
    }

    idx = idx % (NSInteger)self.count;
    if (idx < 0) {
        idx = self.count + idx;
    }

    if (idx < 0 || idx >= self.count) {
        return nil;
    }

    return [self objectAtIndex:idx];
}

- (NSMutableArray*)map:(id (^)(id, NSInteger))block
{
    NSMutableArray* m = [[NSMutableArray alloc] initWithCapacity:self.count];

    for (NSInteger i = 0; i < self.count; ++i) {
        id convertedItem = block([self objectAtIndex:i], i);
        if (convertedItem) {
            [m addObject:convertedItem];
        }
    }
    return m;
}

- (id)randomObject
{
    return [self objectAtIndex:rand() % self.count];
}

@end


@implementation NSMutableArray (RBUtil)
- (id)safeRemoveLastObject
{
    if (self.count == 0) {
        return nil;
    }
    id lastObject = [self objectAtIndex:self.count - 1];
    [self removeLastObject];
    return lastObject;
}

- (void)ensureSize:(NSInteger)size allocWithClass:(Class)cls
{
    while (size >= self.count) {
        [self addObject:[[cls alloc] init]];
    }
}

- (void)ensureSizeWithNull:(NSInteger)size
{
    while (size >= self.count) {
        [self addObject:[NSNull null]];
    }
}

@end
