//
//  iMerchDashBoardCtrlr.h
//  imerchant
//
//  Created by Mohan Kumar on 04/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMerchDefaults.h"

@interface iMerchDashBoardCtrlr : UITabBarController <iMerchCustNaviDelegates>
@property (nonatomic) BOOL pwdEntryForInactivity;

@end
