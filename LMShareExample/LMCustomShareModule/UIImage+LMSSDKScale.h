//
//  UIImage+LMSSDKScale.h
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LMSSDKScale)

/**
 压缩图片到指定的大小
 
 @param image 需要压缩的图片
 @param maxFileSize 指定的大小 ex:32 == 32k
 @return NSData
 */
+ (NSData *_Nullable)lm_scaleImage:(UIImage * _Nonnull )image toKb:(NSInteger)maxFileSize;
@end
