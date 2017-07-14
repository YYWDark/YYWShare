//
//  LMShareRequestParameters.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LMSSDKTypeDefine.h"

@interface LMShareRequestParameters : NSObject
/**
 分享的主文本
 */
@property (nonatomic, copy) NSString *text;
/**
 分享的描述
 */
@property (nonatomic, copy) NSString *descriptionInformation;
/**
 分享一个网页的链接
 */
@property (nonatomic, strong) NSURL *webUrl;
/**
 image,gif的data
 */
@property (nonatomic, strong) NSArray *imageDatas;
/**
 缩略图
 */
@property (nonatomic, strong) UIImage *thumbnails;
/**
 分享的内容类型
 */
@property (nonatomic, assign) LMSSDKContentType contentType;
/**
 分享的平台类型
 */
@property (nonatomic, assign) LMSSDKPlatformType platformType;

/**
 返回一个分享的对象

 @param text 分享的主文本
 @param description 分享的描述
 @param url 分享一个网页的链接
 @param datas 分享储存数据的data
 @param thumbnails 缩略图
 @param contentType   分享的内容类型
 @param platformType 分享的平台类型
 @return 返回一个分享的对象
 */
+ (LMShareRequestParameters *)ParametersWithText:(NSString *)text
                                     description:(NSString *)description
                                          webUrl:(NSURL *)url
                                       imageData:(NSArray *)datas
                                      thumbnails:(UIImage *)thumbnails
                                     contentType:(LMSSDKContentType)contentType
                                    platformType:(LMSSDKPlatformType)platformType;

@end
