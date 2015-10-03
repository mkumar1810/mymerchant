//
//  iMerchStatusChange.h
//  imerchant
//
//  Created by Mohan Kumar on 19/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchStatusChangeDelegate <NSObject>

- (NSInteger) getCurrentMerchantStatusPosn;
- (NSInteger) getNumberOfMerchantStatuses;
- (NSString*) getStatusNameAtPosn:(NSInteger) p_posnNo;
- (void) cancelStatusChangeSelected;
- (void) changeTheMerchantStatusToPosnNo:(NSInteger) p_toPosnNo;

@end

@interface iMerchStatusChange : UIView

@property (nonatomic,weak) id<iMerchStatusChangeDelegate> statChgDelegate;

- (void) loadStatusData;
- (void) animateStatusCell:(NSInteger) p_cellPosnNo;

@end

@interface iMerchStatusChangeCell : UICollectionViewCell

- (void) showStatusText:(NSString*) p_displayText;
- (void) startRotationAnimation;
- (void) stopRotationAnimation;

@end

@interface iMerchRotatingSiriView : UIView

@end