//
//  LMQQShareManager.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/12.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShareManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


@interface LMQQShareManager : LMShareManager <QQApiInterfaceDelegate>
+ (instancetype)sharedManager;
@end
