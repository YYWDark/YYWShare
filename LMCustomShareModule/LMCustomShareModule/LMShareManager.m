//
//  LMShareManager.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/13.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMShareManager.h"

@implementation LMShareManager

#pragma mark - public method
- (void)sendLinkWithParameters:(LMShareRequestParameters *)parameters
                onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    
}

- (void)callbackInformation:(NSString *)errorinformation responseState:(LMSSDKResponseState)responseState errorCode:(LMErrorCode)code {
    NSError *error;
    if (responseState == LMSSDKResponseStateFail) {
        if (errorinformation == nil) errorinformation = @"";
        error = [NSError errorWithDomain:@"" code:code userInfo:@{NSLocalizedDescriptionKey:errorinformation}];
    }
    if (self.stateChangedHandler) {
        self.stateChangedHandler(responseState, nil, error);
    }
}

- (void)callbackSuccessOrCancelWithoutInformation:(LMSSDKResponseState)responseState {
    if (responseState == LMSSDKResponseStateFail) return;
    if (self.stateChangedHandler) {
        self.stateChangedHandler(responseState, nil, nil);
    }
}

- (void)sendErrorParametersMessagefailedWithContentType:(LMSSDKContentType)contentType errorMessage:(NSString *)errorMessage {
    NSString *errorInformation = [NSString stringWithFormat:@"%@参数为空",[self transformFromContentType:contentType]];
    if (errorMessage != nil) {
        errorInformation = errorMessage;
    }
    [self callbackInformation:errorInformation responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeSendFailed];
}
#pragma mark - private method
- (NSString *)transformFromContentType:(LMSSDKContentType)contentType {
    switch (contentType) {
        case LMSSDKContentTypeText:
            return @"文字";
            break;
        case LMSSDKContentTypeImage:
            return @"图片";
            break;
        case LMSSDKContentTypeWebPage:
            return @"链接";
            break;
        case LMSSDKContentTypeEmotion:
            return @"emotion";
            break;
        case LMSSDKContentTypeMovie:
            return @"视频";
            break;
        default:
            break;
    }
    return nil;
}

@end
