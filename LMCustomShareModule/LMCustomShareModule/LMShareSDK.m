//
//  LMShareSDK.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMShareSDK.h"
#import "LMShareFactory.h"
#import "LMWXShareManager.h"
#import "LMSinaWeiboShareManager.h"
#import <TencentOpenAPI/QQApiInterface.h>
static NSString *LM_SINAWEIBO = @"com.sina.weibo";
static NSString *LM_WX = @"com.tencent.xin";
static NSString *LM_QQ = @"com.tencent.mqq";

@implementation LMShareSDK
+ (void)sendLinkWithParameters:(LMShareRequestParameters *)parameters
                onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    LMSSDKPlatformType platformType = parameters.platformType;
    LMShareManager *manager = [LMShareFactory findManagerWithPlatform:platformType];
    [manager sendLinkWithParameters:parameters onStateChanged:stateChangedHandler];
}

//+ (void)share:(LMSSDKPlatformType)platformType
//   parameters:(NSMutableDictionary *)parameters
//onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
//    NSString *url = [parameters[LM_FIled_Url] absoluteString];
//    NSString *title = parameters[LM_FIled_Text];
//    NSString *description = parameters[LM_FIled_Title];
//    NSArray *imageDatas = parameters[LM_FIled_FileDatas];
//    LMSSDKContentType contentType = [parameters[LM_FIled_Type] integerValue];
//
//    switch (platformType) {
//        case LMSSDKPlatformSubTypeWechatSession:
//        case LMSSDKPlatformSubTypeWechatTimeline:{
//           enum WXScene scene = (platformType == LMSSDKPlatformSubTypeWechatSession)?WXSceneSession:WXSceneTimeline;
//           [[LMWXShareManager sharedManager] sendLinkContent:url
//                                                       Title:title
//                                                 Description:description
//                                                      images:imageDatas
//                                                 contentType:contentType
//                                                     AtScene:scene
//                                              onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler];
//            break;}
//            
//        case LMSSDKPlatformTypeSinaWeibo: {
////            [[LMSinaWeiboShareManager sharedManager] sendLinkContent:url
////                                                               Title:title
////                                                         Description:description
////                                                              images:imageDatas
////                                                         contentType:contentType
////                                                      onStateChanged:stateChangedHandler];
//            break;}
//            
//        case LMSSDKPlatformSubTypeQQFriend:
//        case LMSSDKPlatformSubTypeQZone: {
//            [[LMQQShareManager sharedManager] sendLinkContent:url
//                                                        Title:title
//                                                  Description:description
//                                                       images:imageDatas
//                                                  contentType:contentType
//                                                 platformType:(LMSSDKPlatformType)platformType
//                                               onStateChanged:stateChangedHandler];
//            
//            break;}
//        default:
//            break;
//    }
//}

+ (void)registerActivePlatform:(LMSSDKPlatformType)platformType appkey:(NSString *)key secret:(NSString *)secret redirectUrl:(NSString *)url {
    switch (platformType) {
        case LMSSDKPlatformTypeSinaWeibo: {
             [WeiboSDK registerApp:key];
             [LMSinaWeiboShareManager sharedManager].redirectUrl = url;
            break; }
            
        case LMSSDKPlatformSubTypeQQFriend:
        case LMSSDKPlatformSubTypeQZone: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
             TencentOAuth *auth = [[TencentOAuth alloc] initWithAppId:key andDelegate:nil];
#pragma clang diagnostic pop
         
            break;}
            
        case LMSSDKPlatformSubTypeWechatSession:
        case LMSSDKPlatformSubTypeWechatTimeline: {
            [WXApi registerApp:key];
            break;}
        default:
            break;
    }
}

#pragma mark - appdelegate
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self findPlatformHandleUrl:url sourceApplication:sourceApplication];
}

+ (BOOL)findPlatformHandleUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    if ([sourceApplication isEqualToString:LM_WX]) {//微信
        return [WXApi handleOpenURL:url delegate:[LMWXShareManager sharedManager]];
    } else if ([sourceApplication isEqualToString:LM_SINAWEIBO]) {//新浪微博
        return [WeiboSDK handleOpenURL:url delegate:[LMSinaWeiboShareManager sharedManager]];
    } else if ([sourceApplication isEqualToString:LM_QQ]) {
       return [QQApiInterface handleOpenURL:url delegate:[LMQQShareManager sharedManager]];
    }
    return NO;
}
@end
