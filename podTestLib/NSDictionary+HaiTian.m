//
//  NSDirectionary+HaiTian.m
//  bbkids
//
//  Created by hong tianjun on 15/4/17.
//  Copyright (c) 2015年 Haitian. All rights reserved.
//

#import "NSDictionary+HaiTian.h"

@implementation NSDictionary(HaiTian)

- (NSString *)JSONString
{
    NSError * error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (instancetype)dictionaryWithJSONString:(NSString *)string
{
    NSData *resultData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:resultData
                                           options:NSJSONReadingAllowFragments
                                             error:&error];;
}

-(id)safeObjectForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([NSObject isNilOrNull:value]) {
        return nil;
    }
    return value;
}

+(void)maskNSNull {
    //__NSDictionaryI
    //__NSDictionaryM
    [RSSwizzle swizzleInstanceMethod:@selector(objectForKey:) inClass:NSClassFromString(@"__NSCFDictionary") newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
        return ^id(__unsafe_unretained id self, id key){
            
            id (*originalIMP)(__unsafe_unretained id, SEL, id);
            originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
            id res = originalIMP(self,@selector(objectForKey:),key);
            if ([res isKindOfClass:[NSNull class]]) {
                return nil;
            }
            return res;
        };
    } mode:RSSwizzleModeAlways key:nil];
    
    [RSSwizzle swizzleInstanceMethod:@selector(objectForKey:) inClass:NSClassFromString(@"__NSDictionaryM") newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
        return ^id(__unsafe_unretained id self, id key){
            
            id (*originalIMP)(__unsafe_unretained id, SEL, id);
            originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
            id res = originalIMP(self,@selector(objectForKey:),key);
            if ([res isKindOfClass:[NSNull class]]) {
                return nil;
            }
            return res;
        };
    } mode:RSSwizzleModeAlways key:nil];
}
@end
