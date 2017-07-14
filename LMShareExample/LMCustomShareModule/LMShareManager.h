//
//  LMShareManager.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/13.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMSSDKTypeDefine.h"

@interface LMShareManager : NSObject
@property (nonatomic, copy) LMSSDKShareStateChangedHandler stateChangedHandler;

/**
 回调信息

 @param errorinformation 如果失败的情况下显示错误信息
 @param responseState  回调的状态
 @param code 错误信息
 */
- (void)callbackInformation:(NSString *)errorinformation responseState:(LMSSDKResponseState)responseState errorCode:(LMErrorCode)code;


/**
 成功或者是用户取消的回调

 @param responseState 回调的状态
 */
- (void)callbackSuccessOrCancelWithoutInformation:(LMSSDKResponseState)responseState;



/**
 根据contentType来显示参数为空的回调

 @param contentType 分享的类型
 @param errorMessage 错误信息
 */
- (void)sendErrorParametersMessagefailedWithContentType:(LMSSDKContentType)contentType errorMessage:(NSString *)errorMessage;
@end
