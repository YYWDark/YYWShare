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


/**
 返回缩略图

 @param imageDatas 数据的容器
 @param thumbnailImage 缩略图，如果不存在再去imageDatas拿
 @return 图片
 */
+ (UIImage *_Nullable)findThumbnailDataFromImageDatas:(NSArray *_Nullable)imageDatas thumbnails:(UIImage *_Nullable)thumbnailImage;
@end
