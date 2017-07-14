//
//  LMShareFactory.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LMShareManager.h"
@interface LMShareFactory : NSObject
+ (LMShareManager *)findManagerWithPlatform:(LMSSDKPlatformType)platform;
@end
