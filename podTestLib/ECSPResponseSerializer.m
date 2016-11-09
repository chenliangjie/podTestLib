//
//  ECSPResponseSerializer.m
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import "ECSPResponseSerializer.h"

@implementation ECSPResponseSerializer

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    
    NSHTTPURLResponse * res = (NSHTTPURLResponse *)response;
    NSLog(@"res == %@",res);

#ifdef DEBUG
    if (res.statusCode != 200) {
        NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"content == %@",content);
    }
#endif
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
#ifdef DEBUG
    NSLog(@"response ===%@",responseObject);
#endif
    
    if (*error == nil) {
        NSDictionary * header = [responseObject safeObjectForKey:@"header"];
        NSString * code = [header safeObjectForKey:@"retCode"];
        if (code && ![code isEqualToString:@"000000"]) {
            NSString * msg = [header safeObjectForKey:@"retMsg"];
            NSLog(@"response error message:%@",msg);
            *error = [NSError errorWithDomain:@"com.digitalchina.ecsp.network.api.error" code:[code intValue] userInfo:@{@"message":msg}];
            return nil;
        }
        NSString *busiCode = [header safeObjectForKey:@"busiCode"];
        if(!busiCode || busiCode.length == 0)
        {
            return [responseObject safeObjectForKey:@"body"];
        }
        
        return [[responseObject safeObjectForKey:@"body"] safeObjectForKey:busiCode];
    }
    return responseObject;
}
@end
