//
//  LMWXShareManager.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMWXShareManager.h"
#import "LMSSDKTypeDefine.h"
#import "UIImage+LMSSDKScale.h"
#define WXFailedAuthorization @"微信授权失败"
@interface LMWXShareManager()
@end

@implementation LMWXShareManager
#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LMWXShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                 images:(NSArray *)imageDatas
            contentType:(LMSSDKContentType)contentType
                AtScene:(enum WXScene)scene
         onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler {
    
    self.stateChangedHandler = stateChangedHandler;
    if (![WXApi isWXAppInstalled] ) {
        [self callbackInformation:@"微信客户端还没有安装 还不能分享" responseState:LMSSDKResponseStateFail errorCode:LMErrorCodeUnInstallClient];
        return;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = scene;
    
    switch (contentType) {
        case LMSSDKContentTypeText: {//文本
            if (title == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeText errorMessage:nil];
                return;
            }
            req.bText = YES;
            req.text = title;
            break;}
        case LMSSDKContentTypeImage:
        case LMSSDKContentTypeEmotion:{//图片
            if (imageDatas.count == 0) {
                 [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeImage errorMessage:nil];
                NSLog(@"微信图片为空");
                return ;
            }
            
            //储存为NSDATA
            NSData *data = imageDatas.lastObject;
            WXMediaMessage *message = [WXMediaMessage message];
            [message setThumbImage:[UIImage imageWithData:data]];
            
            if (contentType == LMSSDKContentTypeImage) {
                 WXImageObject *imageObject = [WXImageObject new];
                 imageObject.imageData = data;
                 //            imageObject.imageData = [UIImage lm_scaleImage:[UIImage imageWithData:data] toKb:10 * 1024];
                 message.mediaObject = imageObject;
                 req.message = message;
                 
            }else {
                WXEmoticonObject *emotionObject = [WXEmoticonObject new];
                emotionObject.emoticonData = data;
                message.mediaObject = emotionObject;
            }
           
            req.message = message;
            break;}
            
        case LMSSDKContentTypeWebPage: {//网页
            if (urlString == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeWebPage errorMessage:nil];
                return;
            }
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description = description;
            if (imageDatas.count) {
                [message setThumbImage:[UIImage imageWithData:imageDatas.lastObject]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = urlString;
            message.mediaObject = webPageObject;
            req.message = message;
            break;}
            
        case LMSSDKContentTypeMovie: {
            if (urlString == nil) {
                [self sendErrorParametersMessagefailedWithContentType:LMSSDKContentTypeWebPage errorMessage:nil];
                return;
            }
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description = description;
            if (imageDatas.count) {
                [message setThumbImage:[UIImage imageWithData:imageDatas.lastObject]];
            }
            WXVideoObject *videoObject = [WXVideoObject new];
            videoObject.videoUrl = urlString;
            message.mediaObject = videoObject;
            req.message = message;
            break;}
        default:
            break;
    }
    [WXApi sendReq:req];
}



#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req {
    // just leave it here, WeChat will not call our app
}

-(void)onResp:(BaseResp*)resp {
    NSString *errorInformation;
    LMSSDKResponseState state = LMSSDKResponseStateSuccess;
    LMErrorCode code = LMErrorCodeUnknown;
    switch (resp.errCode) {
        case 0:
            state = LMSSDKResponseStateSuccess;
            break;
        case -1:
            errorInformation = @"普通错误类型";
            state = LMSSDKResponseStateFail;
            
            break;
        case -2:
            state = LMSSDKResponseStateCancel;
            break;
        case -3:
            errorInformation = @"发送失败";
            state = LMSSDKResponseStateFail;
            code  = LMErrorCodeSendFailed;
            break;
        case -4:
            errorInformation = @"授权失败";
            state = LMSSDKResponseStateFail;
            code  = LMErrorCodeUnAuthorization;
            break;
        case -5:
            errorInformation = @"微信不支持";
            state = LMSSDKResponseStateFail;
            break;
    }
    
    [self callbackInformation:errorInformation responseState:state errorCode:code];
    
}
@end
