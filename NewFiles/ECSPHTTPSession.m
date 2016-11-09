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

@implementation ECSPHTTPSession

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

- (NSInteger)downloadFileWithURL:(NSURL *)url
       downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
              setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
        downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        downloadFileProgress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return setupFilePath(response);
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        downloadCompletionHandler(filePath,error);
    }];
    
    [downloadTask resume];
    
    return [downloadTask taskIdentifier];
}

- (NSInteger)uploadFileWithFileName:(NSString *)fileName
                          URLString:(NSString *)urlString
                        params:(NSDictionary *)params
                          data:(NSData *)data
                           mimeType:(NSString *)mimeType
                 uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
            uploadCompletionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))uploadCompletionHandler

{
    NSMutableURLRequest *request =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:params
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                     [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
                                 }
                                                     error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithRequest:request fromData:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadFileProgress(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        uploadCompletionHandler(response, responseObject, error);
    }];
    
    [uploadTask resume];
    
    return [uploadTask taskIdentifier];
}

- (void)cancelTaskWithID:(NSInteger)identifer taskType:(NSInteger)taskType
{
    NSArray *taskList = nil;
    if(taskType == 0)
        taskList = [self uploadTasks];
    else
        taskList = [self downloadTasks];
    
    if(taskList && taskList.count > 0)
    {
        for(NSURLSessionTask *task in taskList)
        {
            if([task taskIdentifier] == identifer)
            {
                [task cancel];
                break;
            }
        }
    }
}

@end
