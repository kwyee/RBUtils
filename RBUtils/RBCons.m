//
//  RBCons.m
//  PocketSteam
//
//  Created by Kenson Yee on 5/6/15.
//  Copyright (c) 2015 RandomBits. All rights reserved.
//

#import "RBCons.h"

@implementation RBCons

+ (NSString *)userAgentForWebView
{
//    static NSString *_userAgentForWebView = nil;
//
//    if (!_userAgentForWebView) {
//        static dispatch_once_t pred;
//
//        dispatch_once(&pred, ^{
//            _userAgentForWebView = @"";
//            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
//            NSString *uaString = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//
//            NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
//            NSString *appBuild = [NSString stringWithFormat:@"%@", [appInfo objectForKey:@"CFBundleVersion"]];
//
//            _userAgentForWebView = [NSString stringWithFormat:@"%@ Polyvore/%@", uaString, appBuild];
//        });
//    }
//
//    return _userAgentForWebView;
    
    return @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
}

@end
