//
//  iMerchReEnterPwdChk.h
//  iMerchant
//
//  Created by Mohan Kumar on 09/03/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMerchDefaults.h"

@protocol iMerchReEnterPwdChkDelegate <NSObject>

- (void) passWordCheckSuccess;
- (void) passWordCheckFailed;

@end

@interface iMerchReEnterPwdChk : UIView

@property (nonatomic,weak) id<iMerchReEnterPwdChkDelegate> pwdChkDelegate;

- (instancetype) initWithEMail:(NSString*) p_eMail andNoOfAttempts:(NSInteger) p_noOfAttempts;

@end
