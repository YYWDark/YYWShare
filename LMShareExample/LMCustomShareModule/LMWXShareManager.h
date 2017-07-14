//
//  LMWXShareManager.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "LMShareManager.h"
@protocol WXAuthDelegate <NSObject>

@optional
- (void)wxAuthSucceed:(NSString*)code;
- (void)wxAuthDenied;
- (void)wxAuthCancel;
@end

@interface LMWXShareManager : LMShareManager <WXApiDelegate>
+ (instancetype)sharedManager;
@property (nonatomic, copy) NSString *authState;
@property (nonatomic, assign) id<WXAuthDelegate> delegate;

- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                 images:(NSArray *)imageDatas
            contentType:(LMSSDKContentType)contentType
                AtScene:(enum WXScene)scene
         onStateChanged:(LMSSDKShareStateChangedHandler)stateChangedHandler;

@end
