//
//  LMSSDKTypeDefine.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#ifndef LMSSDKTypeDefine_h
#define LMSSDKTypeDefine_h
//字段
#define LM_FIled_Type @"type"
#define LM_FIled_Url @"url"
#define LM_FIled_Text @"text"
#define LM_FIled_Title @"title"
#define LM_FIled_FileDatas @"fileDatas"
/*
 微信:https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317332&token=&lang=zh_CN
 */
/**
 *  结合SSO和Web授权方式
 */
extern NSString *const LMSSDKAuthTypeBoth ;
/**
 *  SSO授权方式
 */
extern NSString *const LMSSDKAuthTypeSSO;
/**
 *  网页授权方式
 */
extern NSString *const LMSSDKAuthTypeWeb;

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, LMSSDKPlatformType) {
    /**
     *  未知
     */
    LMSSDKPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    LMSSDKPlatformTypeSinaWeibo           = 1,
    /**
     *  微信好友
     */
    LMSSDKPlatformSubTypeWechatSession    = 2,
    /**
     *  微信朋友圈
     */
    LMSSDKPlatformSubTypeWechatTimeline   = 3,
    /**
     *  QQ好友
     */
    LMSSDKPlatformSubTypeQQFriend         = 4,
    /**
     *  QQ空间
     */
    LMSSDKPlatformSubTypeQZone            = 5,
    
};

/**
 *  回复状态
 */
typedef NS_ENUM(NSUInteger, LMSSDKResponseState) {
    /**
     *  分享成功
     */
    LMSSDKResponseStateSuccess     = 0,
    /**
     *  失败
     */
    LMSSDKResponseStateFail        = 1,
    
    /**
     *  用户取消
     */
    LMSSDKResponseStateCancel      = 2,
    
};
typedef NS_ENUM(NSUInteger, LMErrorCode) {
    /**
     *  其他错误
     */
    LMErrorCodeUnknown = -101,
    /**
     *  授权失败
     */
    LMErrorCodeUnAuthorization = -1001,
    /**
     *  发送错误
     */
    LMErrorCodeSendFailed = -10001,
    /**
     *  客户端没有安装 不能分享
     */
    LMErrorCodeUnInstallClient = -100001,
};

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, LMSSDKContentType){
    /**
     *  文本
     */
    LMSSDKContentTypeText         = 0,
    /**
     *  图片和gif
     */
    LMSSDKContentTypeImage        = 1,
    /**
     *  网页
     */
    LMSSDKContentTypeWebPage      = 2,
    /**
     *  emotion
     */
    LMSSDKContentTypeEmotion      = 3,
    /**
     *  视频
     */
    LMSSDKContentTypeMovie        = 4,
    
};

/**
 *  导入原平台SDK回调处理器
 *
 *  @param platformType 需要导入原平台SDK的平台类型
 */
typedef void(^LMSSDKImportHandler) (LMSSDKPlatformType platformType);

/**
 *  配置分享平台回调处理器
 *
 *  @param platformType 需要初始化的分享平台类型
 *  @param appInfo      需要初始化的分享平台应用信息
 */
typedef void(^LMSSDKConfigurationHandler) (LMSSDKPlatformType platformType, NSDictionary *appInfo);

/**
 *  分享内容状态变更回调处理器
 *
 *  @param state            状态
 *  @param userData         附加数据, 返回状态以外的一些数据描述，如：邮件分享取消时，标识是否保存草稿等
 *  @param error            错误信息,当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^LMSSDKShareStateChangedHandler) (LMSSDKResponseState state, NSDictionary *userData, NSError *error);

#endif /* LMSSDKTypeDefine_h */
