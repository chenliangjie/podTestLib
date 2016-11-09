//
//  HHConfig.m
//  iCar
//
//  Created by hongtianjun on 14/7/28.
//  Copyright (c) 2014年 BigBrother. All rights reserved.
//

#import "ECSPConfig.h"

NSString * const kFirst= @"kfirst";
NSString * const kDiscoverUpdateTime =@"kdiscoverupdateTime";
NSString * const kAttentionTagsChanged =@"kAttentionTagsChanged";
NSString * const kNewRemindUnReadNum = @"kNewRemindUnReadNum";
NSString * const kAddressBookAlertTime = @"kAddressBookAlertTime";
NSString * const kFirstRemoveTagDB = @"kFirstRemoveTagDB";
NSString * const kFirstRemoveUser = @"kFirstRemoveUser";

@interface ECSPConfig ()
+(void)setObject:(id)value forKey:(NSString *)key;
+(id)objectForKey:(NSString *)key;
@end

@implementation ECSPConfig
+(void)setObject:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+(BOOL)isFirst
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirst];
}
+(void)setFirst:(BOOL)first
{
    [[NSUserDefaults standardUserDefaults]setBool:first forKey:kFirst];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSDate *)kAddressBookAlertTime
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kAddressBookAlertTime];
}

+(void)setAddressBookAlertTime:(NSDate *)alertTime
{
    [[NSUserDefaults standardUserDefaults]setValue:alertTime forKey:kAddressBookAlertTime];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSDate *)discoverActivityUpdateTime
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kDiscoverUpdateTime];
}
+(void)setDiscoverUpdateTime:(NSDate *)updateTime
{
    [[NSUserDefaults standardUserDefaults]setValue:updateTime forKey:kDiscoverUpdateTime];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)isAttentionTagsChanged
{
     return [[NSUserDefaults standardUserDefaults] boolForKey:kAttentionTagsChanged];
}

+(void)setAttentionTagsChanged:(BOOL)changed
{
    [[NSUserDefaults standardUserDefaults]setBool:changed forKey:kAttentionTagsChanged];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSInteger)newRemindUnReadNum
{
      return [[NSUserDefaults standardUserDefaults]integerForKey:kNewRemindUnReadNum];
}

+(void)setNewRemindUnReadNum:(NSInteger)num
{
    [[NSUserDefaults standardUserDefaults]setInteger:num forKey:kNewRemindUnReadNum];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//重新升级版本，数据处理
+(BOOL)isfirstRemoveTagDB
{
    
      return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstRemoveTagDB];
}

+(void)setFirstRemoveTagDB:(BOOL)first
{
    
    [[NSUserDefaults standardUserDefaults]setBool:first forKey:kFirstRemoveTagDB];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)isfirstRemoveUser
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstRemoveUser];
}

+(void)setFirstRemoveUser:(BOOL)first
{
    [[NSUserDefaults standardUserDefaults]setBool:first forKey:kFirstRemoveUser];
}

@end
