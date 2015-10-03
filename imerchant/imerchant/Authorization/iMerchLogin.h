//
//  iMerchLogin.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchLoginDelegates <NSObject>

- (void) executeLogin:(NSDictionary*) p_loginInfo;
- (void) setTextDisplayFromRect:(CGRect) p_fromRect;
//- (void) resetFromScrollOffset;

@end

@interface iMerchLogin : UIView <UITextFieldDelegate>

@property (nonatomic,weak) id<iMerchLoginDelegates> handlerDelegate;
- (void) showAlertMessage:(NSString*) p_alertMessage;
- (void) checkForSingleSignOptions;
- (void) setScrollPositionSetAppropriately;
- (void)stopButtonWobble;

@end
