//
//  iMerchStandardValidations.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iMerchStandardValidations : NSObject

+ (BOOL) isTextFieldIsempty:(UITextField*) p_txtField;
+ (BOOL) isTextValueIsValidEMail:(NSString*) p_eMailText;

@end
