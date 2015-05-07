
#import <Foundation/Foundation.h>

@interface NSArray (RBUtil)

// tests for out of bounds errors, returning nil if that occurs
- (id)safeObjectAtIndex:(NSInteger)idx;
// Supports negative numbers and indices outside of [0, self.count]
- (id)safeObjectAtOffset:(NSInteger)idx;

- (NSMutableArray*)map:(id(^)(id item, NSInteger index))block;

- (id)randomObject; // one of the random objects in this array.
@end

@interface NSMutableArray (RBUtil)
// Safely removes the last object or returns nil and does nothing if there are no more objects
- (id)safeRemoveLastObject;

// Ensures this object has enough space, allocating new cls objects as it goes.
- (void)ensureSize:(NSInteger)size allocWithClass:(Class)cls;
// Ensures this object has enough space, using NSNull as a placeholder
- (void)ensureSizeWithNull:(NSInteger)size;
@end

