
#import "NSDictionary+RBUtil.h"

@implementation NSDictionary (RBUtil)

- (NSString*)stringForKey:(id)key
{
    id s = [self objectForKey:key];
    if (s == [NSNull null]) {
        return nil;
    }

    if ([s isKindOfClass:[NSString class]]) {
        return s;
    }

    if ([s respondsToSelector:@selector(stringValue)]){
        return [s performSelector:@selector(stringValue)];
    }
    return nil;
}

- (NSNumber*)numberForKey:(id)key
{
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	return s;
}

- (void)setIntegerForKey:(NSInteger)value
                  forKey:(id)key {
    return [self setValue:[NSNumber numberWithInteger:value] forKey:key];
}


- (NSMutableDictionary*)dictionaryForKey:(id)key
{
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSDictionary class]]) {
		return nil;
	}

    if (![s isKindOfClass:[NSMutableDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:s];
	}

	return s;
}

- (NSArray*)arrayForKey:(id)key
{
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSArray class]]) {
		return nil;
	}
    // NOTE: sometimes, objectForKey returns an internal calls that DOES pass isKindOfClass:[NSMutableArray class] but
    // dies when you try to mutate it.  So instead, always create a new array.
	return s;
}


@end
