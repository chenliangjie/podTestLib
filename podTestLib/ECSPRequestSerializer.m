//
//  ECSPRequestSerializer.m
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import "ECSPRequestSerializer.h"
#import "ECSPConfig.h"

NSString * kEcspRequestSerializerUserAgent = nil;

@implementation ECSPRequestSerializer

#pragma mark - AFURLRequestSerialization

+ (void)setGlobalUserAgent:(NSString *)userAgent
{
    kEcspRequestSerializerUserAgent = userAgent;
}

- (instancetype)init
{
    if ([super init])
    {
        NSDictionary *requestHeaders = [self HTTPRequestHeaders];
        NSString *oldUserAgent = [requestHeaders objectForKey:@"User-Agent"];
        
        NSString *customerInfo = kEcspRequestSerializerUserAgent;
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
        if ([params objectForKey:@"userId"] == nil && ![NSObject isNilOrNull:[ACCCurUser ID]]) {
            [params setObject:[ACCCurUser ID] forKey:@"userId"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser loginName]]) {
            [params setObject:[ACCCurUser loginName] forKey:@"LOGIN"];
        }
        if (![NSObject isNilOrNull:[ACCCurUser token]]) {
            [params setObject:[ACCCurUser token] forKey:@"SECURELOGIN"];
        }
    }
    else if([params objectForKey:@"userId"] == nil){
        [params setObject:[ACCCurEnv UUID] forKey:@"userId"];
    }
    [params setObject:@"json" forKey:@"format"];
    NSLog(@"par== %@",params);
    NSLog(@"request=%@",request.allHTTPHeaderFields);
    return [super requestBySerializingRequest:request withParameters:params error:error];
}

@end
