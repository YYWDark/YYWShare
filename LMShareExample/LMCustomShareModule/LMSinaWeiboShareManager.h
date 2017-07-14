//
//  LMSinaWeiboShareManager.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShareManager.h"
#import "WeiboSDK.h"
@interface LMSinaWeiboShareManager : LMShareManager <WeiboSDKDelegate>
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *redirectUrl;

+ (instancetype)sharedManager;

- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                 images:(NSArray <NSData *>*)imageDatas
            contentType:(LMSSDKContentType)contentType
         onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler;
@end
