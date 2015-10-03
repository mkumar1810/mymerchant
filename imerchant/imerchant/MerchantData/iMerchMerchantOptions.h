//
//  iMerchMerchantOptions.h
//  imerchant
//
//  Created by Mohan Kumar on 18/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchMerchantOptionsDelegate <NSObject>

- (void) addNewNotesToTheMerchant;
- (void) sendEMailAfterUnloadingPopupToLeadFromFrame:(CGRect) p_fromRect ofView:(id) p_onView;
- (void) showStatusChangeScreen;

@end

@interface iMerchMerchantOptions : UIView

@property (nonatomic) CGAffineTransform originalTransform;

- (instancetype) initWithFrame:(CGRect) p_frame andSuperPoint:(CGPoint) p_superPoint dataDelegate:(id<iMerchMerchantOptionsDelegate>) p_dataDelegate;

@end