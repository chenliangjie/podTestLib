//
//  ECSPURLConection.m
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import "ECSPHTTPSession.h"
#import "ECSPResponseSerializer.h"
#import "ECSPRequestSerializer.h"

NSString * const ECSPAPIErrorDomain = @"com.digitalchina.ecsp.network.api.error";

NSString * ECSPAPIErrorMessage(NSError * error) {
    
    
    if (error == nil) return nil;
    NSString * message = nil;
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        message = NSLocalizedString(@"LoadError", nil);
    }else if ([error.domain isEqualToString:AFNetworkingOperationFailingURLResponseErrorKey]) {
#ifdef DEBUG
        NSMutableString *msg = [[NSMutableString alloc] init];
        
        [msg appendString:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        message = msg;
#else
        message = NSLocalizedString(@"ServerError", nil);
#endif
    }else if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
#ifdef DEBUG
        NSMutableString *msg = [[NSMutableString alloc] init];
        
        [msg appendString:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        message = msg;
#else
        message = NSLocalizedString(@"ServerError", nil);
#endif
    }else if ([error.domain isEqualToString:ECSPAPIErrorDomain]) {
        message = [error.userInfo objectForKey:@"message"];
    }else {
        message = NSLocalizedString(@"ServerError", nil);
    }
    return message;
}


NSString * kEcspHTTPSessionDomain = nil;

@implementation ECSPHTTPSession

+(void)setGlobalDefaultDomain:(NSString *)domain {
    kEcspHTTPSessionDomain = domain;
}

+(NSString *)domain {
    return kEcspHTTPSessionDomain;
}

-(id)initWithBaseURL:(NSURL *)url {
    if ((self = [super initWithBaseURL:url])) {
        self.responseSerializer = [ECSPResponseSerializer serializer];
        self.requestSerializer = [ECSPRequestSerializer serializer];
    }
    return self;
}


-(NSURLSessionDataTask *)get:(NSString *)url
parameters:(id)parameters
   success:(void (^)(id responseObject))success
   failure:(void (^)(NSError *error))failure {
    
    NSURLSessionDataTask * task = [super GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (success) failure(error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *)post:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    NSURLSessionDataTask * task = [super  POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (success) failure(error);
    }];
    return task;
}


-(NSURLSessionDataTask *)post:(NSString *)url
 parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    NSURLSessionDataTask * task = [super POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        block(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) failure(error);
    }];
    
    return task;
}

@end
