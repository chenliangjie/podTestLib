//
//  NSDirectionary+HaiTian.h
//  bbkids
//
//  Created by hong tianjun on 15/4/17.
//  Copyright (c) 2015年 Haitian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(HaiTian)

+ (instancetype)dictionaryWithJSONString:(NSString *)string;

+(void)maskNSNull;

- (NSString *)JSONString;


-(id)safeObjectForKey:(id)aKey;


@end
