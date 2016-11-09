//
//  ECSPRequestSerializer.m
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import "ECSPRequestSerializer.h"
#import "ECSPConfig.h"

@implementation ECSPRequestSerializer

#pragma mark - AFURLRequestSerialization

- (instancetype)init
{
    if ([super init])
    {
        NSDictionary *requestHeaders = [self HTTPRequestHeaders];
        NSString *oldUserAgent = [requestHeaders objectForKey:@"User-Agent"];
        
        NSString *customerInfo = [NSString stringWithFormat:@" %@/%@ (%@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],APP_CUR_CODE];
        NSString *newAgent = [oldUserAgent stringByAppendingString:customerInfo];
        
        if (newAgent)
        {
            if (![newAgent canBeConvertedToEncoding:NSASCIIStringEncoding])
            {
                NSMutableString *mutableUserAgent = [newAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false))
                {
                    newAgent = mutableUserAgent;
                }
            }
            [self setValue:newAgent forHTTPHeaderField:@"User-Agent"];
        }
        
        //NSLog(@"[HTTPRequestHeaders] %@",[self HTTPRequestHeaders]);
    }
    
    return self;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    //加入需要处理的
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (ACCCurUser) {
        if ([params objectForKey:@"userid"] == nil && ![NSObject isNilOrNull:[ACCCurUser ID]]) {
            [params setObject:[ACCCurUser ID] forKey:@"userid"];
        }
        
        if (![NSObject isNilOrNull:[ACCCurUser loginName]]) {
            [params setObject:[ACCCurUser loginName] forKey:@"LOGIN"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser token]]) {
            [params setObject:[ACCCurUser token] forKey:@"SECURELOGIN"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser companyId]]) {
            [params setObject:[ACCCurUser companyId] forKey:@"entid"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser name]]) {
            [params setObject:[ACCCurUser name] forKey:@"username"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser companyName]]) {
            [params setObject:[ACCCurUser companyName] forKey:@"entname"];
        }
        
    }
    else if([params objectForKey:@"userId"] == nil){
        [params setObject:[ACCCurEnv UUID] forKey:@"userId"];
    }
    [params setObject:@"json" forKey:@"format"];
    NSLog(@"par== %@",params);
    return [super requestBySerializingRequest:request withParameters:params error:error];
}

@end
