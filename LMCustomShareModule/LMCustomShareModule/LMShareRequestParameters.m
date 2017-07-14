//
//  LMShareRequestParameters.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LMShareRequestParameters.h"

@implementation LMShareRequestParameters
+ (LMShareRequestParameters *)ParametersWithText:(NSString *)text
                                     description:(NSString *)description
                                          webUrl:(NSURL *)url
                                       imageData:(NSArray *)datas
                                      thumbnails:(UIImage *)thumbnails
                                     contentType:(LMSSDKContentType)contentType
                                    platformType:(LMSSDKPlatformType)platformType {
    LMShareRequestParameters *parameters = [[self alloc] init];
    parameters.text = text;
    parameters.descriptionInformation = description;
    parameters.webUrl = url;
    parameters.imageDatas = datas;
    parameters.thumbnails = thumbnails;
    parameters.contentType = contentType;
    parameters.platformType = platformType;
    return parameters;
}
@end
