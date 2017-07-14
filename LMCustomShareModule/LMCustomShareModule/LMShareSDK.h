//
//  LMShareSDK.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMSSDKTypeDefine.h"
#import "LMWXShareManager.h"
#import "LMSinaWeiboShareManager.h"
#import "LMQQShareManager.h"
#import "LMShareRequestParameters.h"

@protocol LMShareSDKDelegate <NSObject>
//@required
//- (void)shareSDKRegisterWithPlatforms:(NSArray *_Nullable)platforms;

@end

@interface LMShareSDK : NSObject
/**
 初始化各个平台,QQ和QQ空间对应一个平台，微信和朋友圈。两者只需要注册任一就可以了

 @param platformType 平台
 @param key key
 @param secret  secret
 @param url url
 */
+ (void)registerActivePlatform:(LMSSDKPlatformType)platformType appkey:(NSString *_Nullable)key secret:(NSString *_Nullable)secret redirectUrl:(NSString *_Nullable)url;

#pragma mark - 分享
/**
 分享核心功能
 @param parameters 包装的参数
 @param stateChangedHandler 回调Block
 */
+ (void)sendLinkWithParameters:(LMShareRequestParameters *_Nonnull)parameters
                onStateChanged:(LMSSDKShareStateChangedHandler _Nullable)stateChangedHandler;

/**
 处理第三方的回调

 @param application 应用
 @param url url
 @param sourceApplication 根据这判断第三的来源
 @return bool
 */
+ (BOOL)application:(UIApplication *_Nullable)application openURL:(NSURL *_Nonnull)url sourceApplication:(NSString *_Nullable)sourceApplication annotation:(id _Nullable )annotation;

@end
