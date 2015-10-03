//
//  iMerchMerchantsData.h
//  iMerchant
//
//  Created by Mohan Kumar on 30/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchMerchantsDataDelegate <NSObject>

- (NSInteger) getTotalNumberOfMerchants;
- (NSInteger) getCurrentNumberOfMerchantRowsForTV;
- (NSDictionary*) getMerchantDataAtPosn:(NSInteger) p_posnNo;
- (void) showDetailsForMerchantAtPosn:(NSInteger) p_posnNo fromFrame:(CGRect) p_fromFrame andCellImage:(UIImage*) p_cellImage;
- (NSDictionary*) getSchemaDictionary;
- (void) paginateToNextMerchantsList;

@end

@interface iMerchMerchantsData : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) id<iMerchMerchantsDataDelegate> handlerDelegate;

- (void) loadStatusListAgain;

@end

@interface iMerchMerchantListCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier onPosn:(NSInteger) p_posnNo withDelegate:(id<iMerchMerchantsDataDelegate>) p_delegate;
- (void) setDisplayValuesAtPosn:(NSInteger) p_posnNo;
- (void) setCellSelectedMode:(BOOL) p_selected;

@end
