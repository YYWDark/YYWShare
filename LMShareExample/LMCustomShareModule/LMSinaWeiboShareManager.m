//
//  LMSinaWeiboShareManager.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMSinaWeiboShareManager.h"
#import "UIImage+LMSSDKScale.h"
#import "AppDelegate.h"
#define LM_WeiBoAppRedirectUri @"http://www.sharesdk.cn"

@interface LMSinaWeiboShareManager ()
//记录下面的信息 待emotion授权后重新调用
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptioninformation;
@property (nonatomic, strong) NSArray *imageDatas;
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

- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                 images:(NSArray <NSData *>*)imageDatas
            contentType:(LMSSDKContentType)contentType
         onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    
    self.stateChangedHandler = stateChangedHandler;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = LM_WeiBoAppRedirectUri;
    authRequest.scope = @"all";
    WBMessageObject *message = [WBMessageObject message];
    switch (contentType) {
        case LMSSDKContentTypeText: {//文本
            if (title == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeText errorMessage:nil];
                return;
            }
            message.text = title;
            break;}
            
        case LMSSDKContentTypeImage: {//图片
            if (imageDatas.count == 0) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeImage errorMessage:nil];
                NSLog(@"Sina微博图片为空");
                return;
            }
            UIImage *orginImage = [UIImage imageWithData:imageDatas.lastObject];
            WBImageObject *image = [WBImageObject object];
            image.imageData = [UIImage lm_scaleImage:orginImage toKb:10 * 1024];
            message.imageObject = image;
            break;}
        case LMSSDKContentTypeWebPage:
        case LMSSDKContentTypeMovie: {//网页
            if (urlString == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeWebPage errorMessage:nil];
                return;
            }
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"this is id";
            webpage.title = title;
            webpage.description = description;
            if (imageDatas.count) {
               UIImage *orginImage = [UIImage imageWithData:imageDatas.lastObject];
               NSData *imgData = [UIImage lm_scaleImage:orginImage toKb:32];
               webpage.thumbnailData = imgData;
            }
            webpage.webpageUrl = urlString;
            message.mediaObject = webpage;

            break;}
        case LMSSDKContentTypeEmotion: {
            if (!self.wbtoken) {//这种模式下需要先去申请token 然后通过post请求直接发送
                self.urlString = urlString;
                self.title = title;
                self.descriptioninformation = description;
                self.imageDatas = imageDatas;
                
                WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
                authRequest.redirectURI = LM_WeiBoAppRedirectUri;
                authRequest.scope = @"all";
                [WeiboSDK sendRequest:authRequest];
                return ;
            }
            
            WBImageObject *gifObject = [WBImageObject object];
            if (imageDatas.count) {
               gifObject.imageData = imageDatas.lastObject;
            }
            
            [WBHttpRequest requestForShareAStatus:title contatinsAPicture:gifObject orPictureUrl:nil withAccessToken:self.wbtoken andOtherProperties:@{} queue:[[NSOperationQueue alloc] init]withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
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
            [self sendLinkContent:self.urlString Title:self.title Description:self.descriptioninformation images:self.imageDatas contentType:LMSSDKContentTypeEmotion onStateChanged:self.stateChangedHandler];
        }else {
            [self callbackInformation:@"授权失败" responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeUnAuthorization];
        }
    }
}
@end
