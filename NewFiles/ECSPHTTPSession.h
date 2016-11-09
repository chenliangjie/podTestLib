//
//  ECSPURLConection.h
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

extern NSString * const ECSPAPIErrorDomain;

NSString * ECSPAPIErrorMessage(NSError * error);
typedef void (^ECSPHTTPSessionFinishedHandler)(id data,NSError * error);

@interface ECSPHTTPSession : AFHTTPSessionManager

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

- (NSInteger)downloadFileWithURL:(NSURL *)url
            downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                   setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
       downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler;

- (NSInteger)uploadFileWithFileName:(NSString *)fileName
                          URLString:(NSString *)urlString
                             params:(NSDictionary *)params
                               data:(NSData *)data
                           mimeType:(NSString *)mimeType
                 uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
            uploadCompletionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))uploadCompletionHandler;

- (void)cancelTaskWithID:(NSInteger)identifer taskType:(NSInteger)taskType;

@end
