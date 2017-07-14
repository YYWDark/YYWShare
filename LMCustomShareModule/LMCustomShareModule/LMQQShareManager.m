//
//  LMQQShareManager.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/12.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMQQShareManager.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@implementation LMQQShareManager
#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LMQQShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)sendLinkWithParameters:(LMShareRequestParameters *)parameters onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    self.stateChangedHandler = stateChangedHandler;
    if (![QQApiInterface isQQInstalled] ) {
        [self callbackInformation:@"QQ客户端还没有安装 还不能分享" responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeUnInstallClient];
        return ;
    }
    
    switch (parameters.contentType) {
        case LMSSDKContentTypeText: {//文本
            if (parameters.text == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeText errorMessage:nil];
                return;
            }
            QQApiObject *object;
            if (parameters.platformType == LMSSDKPlatformSubTypeQQFriend) {//QQ好友
                object = [QQApiTextObject objectWithText:parameters.text];
            }else {//空间
                object = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:parameters.text extMap:nil];
            }
            object.shareDestType = ShareDestTypeQQ;
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            [self sendReqfromPlatformType:parameters.platformType sendMessageToQQReq:req];
            
            break;}
            
        case LMSSDKContentTypeImage:
        case LMSSDKContentTypeEmotion: {//图片
            if (parameters.imageDatas.count == 0) {
                NSLog(@"QQ分享图片为空");
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeImage errorMessage:nil];
                return ;
            }
            //储存为NSDATA
            NSData *imgData = parameters.imageDatas.lastObject;
            QQApiObject *object;
            if (parameters.platformType == LMSSDKPlatformSubTypeQQFriend) {//QQ好友 目前只支持一张图片
                UIImage *previewImage = [UIImage findThumbnailDataFromImageDatas:parameters.imageDatas thumbnails:parameters.thumbnails];
                object = [QQApiImageObject objectWithData:imgData previewImageData:[UIImage lm_scaleImage:previewImage toKb:1024] title:parameters.text description:parameters.descriptionInformation];
            }else {//空间 支持多张图片
                object = [QQApiImageArrayForQZoneObject objectWithimageDataArray:parameters.imageDatas title:parameters.text extMap:nil];
            }
            object.shareDestType = ShareDestTypeQQ;
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
            [self sendReqfromPlatformType:parameters.platformType sendMessageToQQReq:req];
            break;}
        case LMSSDKContentTypeWebPage:
        case LMSSDKContentTypeMovie: {//网页
            if (parameters.text == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeText errorMessage:nil];
                return;
            }
            if (parameters.webUrl.absoluteString == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeWebPage errorMessage:nil];
                return;
            }
            NSData *imageData;
            UIImage *thumbnails = [UIImage findThumbnailDataFromImageDatas:parameters.imageDatas thumbnails:parameters.thumbnails];
            if (thumbnails != nil) {
                NSLog(@"QQ分享图片为空");
                imageData = [UIImage lm_scaleImage:thumbnails toKb:1024];
            }
            QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:parameters.webUrl title:parameters.text description:parameters.descriptionInformation previewImageData:imageData];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
            [self sendReqfromPlatformType:parameters.platformType sendMessageToQQReq:req];
            break;}
            
        default:
            break;
    }
}


- (void)sendReqfromPlatformType:(LMSSDKPlatformType)platformType sendMessageToQQReq:(SendMessageToQQReq *)req{
    QQApiSendResultCode sent;
    if (platformType == LMSSDKPlatformSubTypeQQFriend) {
        sent = [QQApiInterface sendReq:req];
    } else {
        sent = [QQApiInterface SendReqToQZone:req];
    }
    NSLog(@"req == %d",sent);
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult {
    NSString *errorInformation;
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED: {
            errorInformation = @"App未注册";
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            errorInformation = @"发送参数错误";
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            errorInformation = @"未安装手Q";
            break;
        }
        case EQQAPITIMNOTINSTALLED: {
            errorInformation = @"未安装TIM";
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPITIMNOTSUPPORTAPI: {
             errorInformation = @"API接口不支持";
            break;
        }
        case EQQAPISENDFAILD: {
             errorInformation = @"发送失败";
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE: {
             errorInformation = @"当前QQ版本太低，需要更新";
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE: {
            errorInformation = @"当前QQ版本太低，需要更新";
            break;
        }
        default: {
            break;
        }
    }
    NSLog(@"errorInformation  == %@",errorInformation);
    if (self.stateChangedHandler && (errorInformation != nil)) {
        self.stateChangedHandler(LMSSDKResponseStateFail, nil, [NSError errorWithDomain:@"" code:LMErrorCodeSendFailed userInfo:@{NSLocalizedDescriptionKey:errorInformation}]);
    }
}
#pragma mark - QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    NSLog(@"result == %@ \n,errorDescription == %@ \n type == %d \n, extendInfo == %@\n",resp.result, resp.errorDescription, resp.type,resp.extendInfo);
    
    if ([resp.result integerValue] == 0) {//成功
        [self callbackSuccessOrCancelWithoutInformation:LMSSDKResponseStateSuccess];
    } else {
        [self callbackInformation:resp.errorDescription responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeSendFailed];
    }
}
/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    
}
@end
