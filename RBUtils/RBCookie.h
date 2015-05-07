
#import <Foundation/Foundation.h>

@interface RBCookie : NSObject

// storeCookiesInNSUserDefaults will copy all the current Polyvore cookies into NSUserDefaults. When restoring the app, we read from this key in restoreCookiesFromNSUserDefaults.
// NSHTTPCookie does not flush until the app is closed or 30s so if we crash within that time, the cookies will not be up to date. This code protects against that case.
+ (void)storeCookiesInNSUserDefaults;
+ (void)restoreCookiesFromNSUserDefaults; // NOTE: this will delete ALL Polyvore cookies and restore them from NSUserDefaults, so use sparingly

+ (void)removeAllCookiesExcept:(NSSet *)keep;
+ (void)removeCookie:(NSString *)cookieName;

// Returned as a mutable dictionary for convenience but does not acutally update the cookie when you update the dict.
//+ (NSMutableDictionary *)cookieAsDictionary:(NSString *)cookieName;

//+ (void)setCookie:(NSString *)cookieName withDictionary:(NSDictionary *)values;

@end