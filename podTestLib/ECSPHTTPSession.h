//
//  ECSPURLConection.h
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "ECSPRequestSerializer.h"

extern NSString * const ECSPAPIErrorDomain;

NSString * ECSPAPIErrorMessage(NSError * error);
typedef void (^ECSPHTTPSessionFinishedHandler)(id data,NSError * error);

@interface ECSPHTTPSession : AFHTTPSessionManager

+(void)setGlobalDefaultDomain:(NSString *)domain;
+(NSString *)domain;

-(id)initWithBaseURL:(NSURL *)url;

-(NSURLSessionDataTask *)get:(NSString *)url
parameters:(id)parameters
   success:(void (^)(id responseObject))success
   failure:(void (^)(NSError *error))failure;


-(NSURLSessionDataTask *)post:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *)post:(NSString *)url
 parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
@end
