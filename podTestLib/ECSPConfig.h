//
//  HHConfig.h
//  iCar
//
//  Created by hongtianjun on 14/7/28.
//  Copyright (c) 2014年 BigBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kFirst;
extern NSString * const kDiscoverUpdateTime;
extern NSString * const kAddressBookAlertTime;
extern NSString * const kNewRemindUnReadNum;
extern NSString * const kFirstRemoveTagDB;
extern NSString * const kFirstRemoveUser;

@interface ECSPConfig : NSObject

+(void)setObject:(id)value forKey:(NSString *)key;
+(id)objectForKey:(NSString *)key;


+(BOOL)isFirst;
+(void)setFirst:(BOOL)first;

+(NSDate *)kAddressBookAlertTime;
+(void)setAddressBookAlertTime:(NSDate *)alertTime;

+(NSDate *)discoverActivityUpdateTime;
+(void)setDiscoverUpdateTime:(NSDate *)updateTime;

+(BOOL)isAttentionTagsChanged;
+(void)setAttentionTagsChanged:(BOOL)changed;

+(NSInteger)newRemindUnReadNum;
+(void)setNewRemindUnReadNum:(NSInteger)num;

//重新升级版本，数据处理
+(BOOL)isfirstRemoveTagDB;
+(void)setFirstRemoveTagDB:(BOOL)first;


+(BOOL)isfirstRemoveUser;
+(void)setFirstRemoveUser:(BOOL)first;

@end
