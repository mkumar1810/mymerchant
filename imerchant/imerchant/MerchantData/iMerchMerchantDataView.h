//
//  iMerchMerchantDataView.h
//  iMerchant
//
//  Created by Mohan Kumar on 03/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMerchDefaults.h"
#import "iMerchMerchantDataViewCell.h"

@interface iMerchMerchantDataView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) id<iMerchMerchantDataViewDelegate> handlerDelegate;

- (void) loadNotesData;
- (void) stopWobblingAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn;

@end


