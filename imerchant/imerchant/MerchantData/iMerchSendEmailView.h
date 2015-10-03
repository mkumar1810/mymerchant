//
//  iMerchSendEmailView.h
//  iMerchant
//
//  Created by Mohan Kumar on 06/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchSendEMailViewDelegate <NSObject>

- (void) cancelEMailSending;
- (void) sendEMailWithSubj:(NSString*) p_mailSubj andBody:(NSString*) p_mailBody;

@end

@interface iMerchSendEmailView : UIView <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) id<iMerchSendEMailViewDelegate> emailDelegate;
//@property (nonatomic) CGRect fromFrame;
@property (nonatomic) CGAffineTransform transformStart;

- (NSArray*) bValidateEMailData;

@end
