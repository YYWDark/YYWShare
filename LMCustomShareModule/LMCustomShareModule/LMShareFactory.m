//
//  LMShareFactory.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMShareFactory.h"
#import "LMWXShareManager.h"
#import "LMQQShareManager.h"
#import "LMSinaWeiboShareManager.h"

@implementation LMShareFactory
+ (LMShareManager *)findManagerWithPlatform:(LMSSDKPlatformType)platform {
    switch (platform) {
        case LMSSDKPlatformSubTypeWechatSession:
        case LMSSDKPlatformSubTypeWechatTimeline:{
            return [LMWXShareManager sharedManager];
            break;}
            
        case LMSSDKPlatformTypeSinaWeibo: {
            return [LMSinaWeiboShareManager sharedManager];
            break;}
            
        case LMSSDKPlatformSubTypeQQFriend:
        case LMSSDKPlatformSubTypeQZone: {
            return [LMQQShareManager sharedManager];
            break;}
        default:
            break;
    }
    return nil;
}
@end
