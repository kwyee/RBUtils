
#import "RBCookie.h"

#import "NSMutableDictionary+RBUtil.h"

@implementation RBCookie

#define RBUserTempCookieJarKey @"kRBUserTempCookieJar"

/* Delimiter used by the server to encode complex cookie values */
//#define COOKIE_VALUE_DELIM @"&"


// TODO(kwyee): Also need to store STEAM cookies AND
// #define COOKIE_DOMAIN @".redzedbed.com"
// #define BASE_URL_HOSTNAME @"redzedbed.com"
// #define COOKIE_PATH @"/"

//NSURL *BASE_URL = nil;
+ (void)initialize {
    static dispatch_once_t INIT_ONCE;
    dispatch_once(&INIT_ONCE, ^{
//       BASE_URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BASE_URL_HOSTNAME]];
    });
}


+ (void)storeCookiesInNSUserDefaults
{
    // http://stackoverflow.com/a/5938927
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableArray *serializedCookies = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in cookies) {
        [serializedCookies addObject:[RBCookie cookie2dictionary:cookie]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:serializedCookies forKey:RBUserTempCookieJarKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)restoreCookiesFromNSUserDefaults
{
    // Delete all cookies
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }

    NSArray *serializedCookies = [[NSUserDefaults standardUserDefaults] arrayForKey:RBUserTempCookieJarKey];
    for (NSDictionary *serializedCookie in serializedCookies) {
        NSHTTPCookie *cookie = [RBCookie dictionary2cookie:serializedCookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

+ (void)removeAllCookiesExcept:(NSSet *)keep
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    // delete *all *our cookies, cleans up our login plus twitter or blogger etc logged in state too
    // one exception is our unique visitor id, which we want to keep the same
    for (NSHTTPCookie *cookie in cookies) {
        if ([keep containsObject:cookie.name]) {
            continue;
        }
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

+ (void)removeCookie:(NSString *)cookieName
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    // delete *all *our cookies, cleans up our login plus twitter or blogger etc logged in state too
    // one exception is our unique visitor id, which we want to keep the same
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:cookieName]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            break;
        }
    }
}

+ (NSMutableDictionary *)cookie2dictionary:(NSHTTPCookie *)cookie {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result safeSetObject:cookie.comment forKey:NSHTTPCookieComment];
    [result safeSetObject:cookie.commentURL forKey:NSHTTPCookieCommentURL];
//    [result safeSetObject:cookie.isSessionOnly ? @"TRUE" : @"FALSE" forKey:NSHTTPCookieDiscard]; TODO(kwyee):
    [result safeSetObject:cookie.domain forKey:NSHTTPCookieDomain];
    [result safeSetObject:cookie.expiresDate forKey:NSHTTPCookieExpires];
//    [result safeSetObject:cookie. forKey:NSHTTPCookieMaximumAge];
    [result safeSetObject:cookie.name forKey:NSHTTPCookieName];
//    [result safeSetObject:cookie. forKey:NSHTTPCookieOriginURL];
    [result safeSetObject:cookie.path forKey:NSHTTPCookiePath];
//    [result safeSetObject:cookie.portList forKey:NSHTTPCookiePort];
    if (cookie.secure) {
        [result setObject:@"TRUE" forKey:NSHTTPCookieSecure];
    }
    [result setObject:cookie.value forKey:NSHTTPCookieValue];
    [result setObject:[NSString stringWithFormat:@"%d", (unsigned int)cookie.version] forKey:NSHTTPCookieVersion];
    return result;
}

+ (NSHTTPCookie *)dictionary2cookie:(NSDictionary *)dict {
    return [NSHTTPCookie cookieWithProperties:dict];
}

//+ (NSMutableDictionary *)cookieAsDictionary:(NSString *)cookieName
//{
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    for (NSHTTPCookie *cookie in cookies) {
//        if (![cookie.name isEqualToString:cookieName]) {
//            continue;
//        }
//
//        NSString *cookieValue = [[cookie value] URLDecodedString:TRUE];
//        NSMutableArray *objectsAndKeys = [NSMutableArray arrayWithArray:[cookieValue componentsSeparatedByString:COOKIE_VALUE_DELIM]];
//        if (objectsAndKeys.count >= 2) {
//            // Separated using &
//            for (uint i = 0; i < [objectsAndKeys count]; i += 2) {
//                NSString *key = [objectsAndKeys objectAtIndex:i];
//                id value = @"";
//                if (i+1 < objectsAndKeys.count) {
//                    value = [objectsAndKeys objectAtIndex:i+1];
//                }
//                [dict setValue:value forKey:key];
//            }
//        } else {
//            // Try the cookie as a JSON-encoded string. For some reason, r62130/r62162 felt it was necessary to do that for experiments. WTF
//            NSData *cookieValueAsData = [cookieValue dataUsingEncoding:NSUTF8StringEncoding];
//            dict = [NSJSONSerialization JSONObjectWithData:cookieValueAsData
//                                                   options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
//                                                     error:nil];
//        }
//    }
//    return dict;
//}

//+ (void)setCookie:(NSString *)cookieName withDictionary:(NSDictionary *)values
//{
//    DDAssert(cookieName.length > 0, @"Need value cookie, not %@", cookieName);
//
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//
//    for (NSHTTPCookie *cookie in cookies) {
//        if ([cookie.name isEqualToString:cookieName]) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//            break;
//        }
//    }
//
//    NSMutableArray *objectsAndKeys = [[NSMutableArray alloc] initWithCapacity:values.count * 2];
//    for (NSString *key in values) {
//        [objectsAndKeys addObject:key];
//        [objectsAndKeys addObject:[values objectForKey:key]];
//    }
//
//    if (objectsAndKeys.count) {
//        NSString *valuesAsString = [objectsAndKeys componentsJoinedByString:COOKIE_VALUE_DELIM];
//        //        Created = 1;
//        //        Domain = ".polyvore.net";
//        //        Expires = "2014-03-17 11:06:35 +0000";
//        //        Name = l;
//        //        Path = "/";
//        //        Value = "sig&7fec192699d33aec8499b44d6773ff9a&n&kwyee&lat&1393778486&lwt&0&id&267202&t&1393844795";
//
//        // Update the old cookie with new values. Unfortunately, NSHTTPCookie is immutable.
//        NSHTTPCookie *newCookie = [[NSHTTPCookie alloc] initWithProperties:@{
//                                                                             @"Value": valuesAsString,
//                                                                             @"Name": cookieName,
//                                                                             @"Domain": COOKIE_DOMAIN,
//                                                                             @"Path": COOKIE_PATH,
//                                                                             @"Expires": [[NSDate alloc] initWithTimeIntervalSinceNow:365 * 24 * 3600]
//                                                                             }];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[newCookie] forURL:BASE_URL mainDocumentURL:nil];
//    }
//}


@end



//@implementation RBStorableCookie : NSObject

//NSString *NSHTTPCookieComment;
//NSString *NSHTTPCookieCommentURL;
//NSString *NSHTTPCookieDiscard;
//NSString *NSHTTPCookieDomain;
//NSString *NSHTTPCookieExpires;
//NSString *NSHTTPCookieMaximumAge;
//NSString *NSHTTPCookieName;
//NSString *NSHTTPCookieOriginURL;
//NSString *NSHTTPCookiePath;
//NSString *NSHTTPCookiePort;
//NSString *NSHTTPCookieSecure;
//NSString *NSHTTPCookieValue;
//NSString *NSHTTPCookieVersion;

//@end