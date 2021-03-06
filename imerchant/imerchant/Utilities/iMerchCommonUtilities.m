//
//  iMerchCommonUtilities.m
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchCommonUtilities.h"

@implementation iMerchCommonUtilities

+ (UIImage*) captureView:(UIView*) p_passView
{
    CGRect l_rect = p_passView.bounds;
    UIGraphicsBeginImageContext(l_rect.size);
    CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
    [p_passView.layer renderInContext:l_ctxref];
    UIImage * l_reqdimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return l_reqdimage;
}

+ (UIImage *)captureView:(UIView *)p_passView ofFrame:(CGRect)p_ofFrame
{
    CGRect l_viewRect = CGRectMake(0, 0, p_passView.bounds.size.width, p_passView.bounds.size.height);
    UIGraphicsBeginImageContext(l_viewRect.size);
    CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
    [p_passView.layer renderInContext:l_ctxref];
    UIImage * l_fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef l_partimgref = CGImageCreateWithImageInRect(l_fullImage.CGImage, p_ofFrame);
    UIImage * l_resultImg = [UIImage imageWithCGImage:l_partimgref];
    CGImageRelease(l_partimgref);
    return l_resultImg;
}

@end
