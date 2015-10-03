//
//  iMerchCommonUtilities.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iMerchCommonUtilities : NSObject

+ (UIImage*) captureView:(UIView*) p_passView;
+ (UIImage*) captureView:(UIView*) p_passView ofFrame:(CGRect) p_ofFrame;

@end
