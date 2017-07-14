//
//  AppDelegate.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "AppDelegate.h"
#import "LMShareSDK.h"

#define LM_WeChatAppID @"wx4868b35061f87885"

#define LM_WeiBoAppKey @"568898243"
#define LM_WeiBoAppSecret @"38a4f8204cc784f81f9f0daaf31e02e3"
#define LM_WeiBoAppRedirectUri @"http://www.sharesdk.cn"

#define LM_QQAppID  @"100371282"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
    //各个平台白名单的信息请访问： http://wiki.mob.com/ios9-%E5%AF%B9sharesdk%E7%9A%84%E5%BD%B1%E5%93%8D%EF%BC%88%E9%80%82%E9%85%8Dios-9%E5%BF%85%E8%AF%BB%EF%BC%89/
    
    //QQ文档
    //http://wiki.open.qq.com/wiki/website/IOS_SDK%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E
    //http://wiki.open.qq.com/wiki/IOS_API%E8%B0%83%E7%94%A8%E8%AF%B4%E6%98%8E
    */
    
     [LMShareSDK registerActivePlatform:LMSSDKPlatformTypeSinaWeibo appkey:LM_WeiBoAppKey secret:LM_WeiBoAppSecret redirectUrl:LM_WeiBoAppRedirectUri];
     [LMShareSDK registerActivePlatform:LMSSDKPlatformSubTypeWechatSession appkey:LM_WeChatAppID secret:nil redirectUrl:nil];
     [LMShareSDK registerActivePlatform:LMSSDKPlatformSubTypeQQFriend appkey:LM_QQAppID secret:nil redirectUrl:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   return [LMShareSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
