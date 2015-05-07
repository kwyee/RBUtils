//  Based on
//  https://github.com/gimenete/iOS-boilerplate/blob/master/IOSBoilerplate/


#import <Foundation/Foundation.h>

@interface NSDictionary (RBUtil)

- (NSString*)stringForKey:(id)key;

- (NSNumber*)numberForKey:(id)key;
- (void)setIntegerForKey:(NSInteger)value forKey:(id)key;

- (NSMutableDictionary*)dictionaryForKey:(id)key;

- (NSArray*)arrayForKey:(id)key;

@end

