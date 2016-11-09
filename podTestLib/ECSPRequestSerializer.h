//
//  ECSPRequestSerializer.h
//  bjd
//
//  Created by hong7 on 15/10/19.
//  Copyright © 2015年 hong7. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface ECSPRequestSerializer : AFHTTPRequestSerializer

+(void)setGlobalUserAgent:(NSString *)userAgent;

@end
