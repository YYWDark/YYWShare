//
//  UIImage+LMSSDKScale.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/11.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "UIImage+LMSSDKScale.h"
#define LMImageDebug

@implementation UIImage (LMSSDKScale)
+ (NSData *)lm_scaleImage:(UIImage * _Nonnull )image toKb:(NSInteger)maxFileSize {
    NSData *originData = UIImageJPEGRepresentation(image, 1);
    if (maxFileSize > originData.length/1024.0f) {
        return UIImageJPEGRepresentation(image, 1);
    }
#ifdef LMImageDebug
      NSLog(@"Size of origin Image(bytes):%f kb",[UIImageJPEGRepresentation(image, 1) length]/1024.0f);
#endif

    maxFileSize *= 1024;
    CGFloat compression = 0.9f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
#ifdef LMImageDebug
     NSLog(@"after compress:%f kb",(float)[imageData length]/1024.0f);
#endif
   
    return imageData;
}
@end
