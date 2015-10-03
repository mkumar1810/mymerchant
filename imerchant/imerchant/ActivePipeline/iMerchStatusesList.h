//
//  iMerchStatusesList.h
//  iMerchant
//
//  Created by Mohan Kumar on 29/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchStatusesListDelegate <NSObject>

- (NSInteger) getNumberOfStatuses;
- (NSInteger) getNumberOfStatusPairs;
- (NSDictionary*) getStatusDictAtPosn:(NSInteger) p_posnNo andOffset:(NSInteger) p_offsetNo;
- (void) showDetailsForStatusAtPosn:(NSInteger) p_posnNo andOffset:(NSInteger) p_offsetNo;

@end

@interface iMerchStatusesList : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) id<iMerchStatusesListDelegate> handlerDelegate;

- (void) loadStatusListAgain;
//- (void) animateCellForPush:(NSInteger) p_posnNo;
//- (void) restoreCellForOriginalPosn:(NSInteger) p_posnNo;

@end


@interface iMerchStatusesListCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier onPosn:(NSInteger) p_posnNo withDelegate:(id<iMerchStatusesListDelegate>) p_delegate;
- (void) setDisplayValuesAtPosn:(NSInteger) p_posnNo;
- (void) setStatusSelectedBasedOnPosn:(CGPoint) p_touchPoint;
- (void) setCellButtonsWobbleStopped;
//- (void) animateCellForPush;
//- (void) restoreCellOriginalPosn;

@end

@interface iMerchStatusListCellCustBtn : UIButton

- (void) setDisplayDataWithDict:(NSDictionary*) p_dataDict;

@end
