//
//  UIView+Screenshot.m
//  ReadWeibo
//
//  Created by ryan on 14-4-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <Accelerate/Accelerate.h>

@implementation UIView (Screenshot)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);//----------将view
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];//利用view层次绘制到当前上下文中
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//----------------------------绘制上去
    
    return image;
}

- (UIImage *)convertViewToBlurryImageWithBlur:(CGFloat)blur
{
    UIImage *image = [self convertViewToImage];
    
    if (blur <= 0 || blur >= 1.0)
    {
        blur = 0.5;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer,outBuffer;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                               0, 0, boxSize,boxSize, NULL,
                               kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
