//
//  NSMutableDictionary+LMSSDK.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "NSMutableDictionary+LMSSDK.h"

@implementation NSMutableDictionary (LMSSDK)
- (void)LMSSDKSetupShareParamsByText:(NSString *)text
                            images:(id)imagesDatas
                               url:(NSURL *)url
                             title:(NSString *)title
                              type:(LMSSDKContentType)type {
    if (text != nil) [self setObject:text forKey:LM_FIled_Text];
    if (imagesDatas != nil) [self setObject:imagesDatas forKey:LM_FIled_FileDatas];
    if (url != nil) [self setObject:url forKey:LM_FIled_Url];
    if (title != nil) [self setObject:title forKey:LM_FIled_Title];
    [self setObject:@(type) forKey:LM_FIled_Type];
}

@end
