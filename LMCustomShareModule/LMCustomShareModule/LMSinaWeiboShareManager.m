//
//  LMSinaWeiboShareManager.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMSinaWeiboShareManager.h"
#define LM_WeiBoAppRedirectUri @"http://www.sharesdk.cn"

@interface LMSinaWeiboShareManager ()
//记录下面的信息 待emotion授权后重新调用
@property (nonatomic, strong) LMShareRequestParameters *remarkParameters;
@end

@implementation LMSinaWeiboShareManager
#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LMSinaWeiboShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)sendLinkWithParameters:(LMShareRequestParameters *)parameters
                onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    self.stateChangedHandler = stateChangedHandler;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectUrl;
    authRequest.scope = @"all";
    WBMessageObject *message = [WBMessageObject message];
    
    switch (parameters.contentType) {
        case LMSSDKContentTypeText: {//文本
            if (parameters.text == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeText errorMessage:nil];
                return;
            }
            message.text = parameters.text;
            break;}
            
        case LMSSDKContentTypeImage: {//图片
            if (parameters.imageDatas.count == 0) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeImage errorMessage:nil];
                NSLog(@"Sina微博图片为空");
                return;
            }
            UIImage *orginImage = [UIImage imageWithData:parameters.imageDatas.lastObject];
            WBImageObject *image = [WBImageObject object];
            image.imageData = [UIImage lm_scaleImage:orginImage toKb:10 * 1024];
            message.imageObject = image;
            break;}
            
        case LMSSDKContentTypeWebPage:
        case LMSSDKContentTypeMovie: {//网页
            if (parameters.webUrl.absoluteString == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeWebPage errorMessage:nil];
                return;
            }
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"this is id";
            webpage.title = parameters.text;
            webpage.description = parameters.descriptionInformation;
            
            UIImage *thumbnailImage = [UIImage findThumbnailDataFromImageDatas:parameters.imageDatas thumbnails:parameters.thumbnails];
            if (thumbnailImage != nil) {
                webpage.thumbnailData = [UIImage lm_scaleImage:thumbnailImage toKb:32];
            }
            
            webpage.webpageUrl = parameters.webUrl.absoluteString;
            message.mediaObject = webpage;
            break;}
            
        case LMSSDKContentTypeEmotion: {
            if (!self.wbtoken) {//这种模式下需要先去申请token 然后通过post请求直接发送
                self.remarkParameters = parameters;
                //授权
                WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
                authRequest.redirectURI = self.redirectUrl;
                authRequest.scope = @"all";
                [WeiboSDK sendRequest:authRequest];
                return ;
            }
            
            WBImageObject *gifObject = [WBImageObject object];
            if (parameters.imageDatas.count) {
                gifObject.imageData = parameters.imageDatas.lastObject;
            }
            
            [WBHttpRequest requestForShareAStatus:parameters.text contatinsAPicture:nil orPictureUrl:nil withAccessToken:self.wbtoken andOtherProperties:@{} queue:[[NSOperationQueue alloc] init]withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error != nil) {
                        [self callbackInformation:error.userInfo[@"error"] responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeSendFailed];
                    }else {
                        [self callbackSuccessOrCancelWithoutInformation:LMSSDKResponseStateSuccess];
                    }
                });
            }];
            return;
            break;}
        default:
            break;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.wbtoken];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}




#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:{
                if (self.stateChangedHandler) {
                    self.stateChangedHandler(LMSSDKResponseStateSuccess, nil, nil);
                }
                break;}
                
            case WeiboSDKResponseStatusCodeUserCancel:{
                if (self.stateChangedHandler) {
                    self.stateChangedHandler(LMSSDKResponseStateCancel, nil, nil);
                }
               break;}
                
            case WeiboSDKResponseStatusCodeShareInSDKFailed:{
                if (self.stateChangedHandler) {
                    self.stateChangedHandler(LMSSDKResponseStateFail, nil, [NSError errorWithDomain:@"" code:LMErrorCodeUnAuthorization userInfo:@{NSLocalizedDescriptionKey:response.userInfo[@"NSLocalizedDescription"]}]);
                }
                break;}
                
            default:
                break;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]) { //认证结果
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) { //授权成功
            [self sendLinkWithParameters:self.remarkParameters onStateChanged:self.stateChangedHandler];
        }else {
            [self callbackInformation:@"授权失败" responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeUnAuthorization];
        }
    }
}
@end
