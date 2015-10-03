//
//  iMerchSearchItems.h
//  iMerchant
//
//  Created by Mohan Kumar on 17/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchSearchItemsDelegate <NSObject>

- (NSDictionary*) getOptionDataAtPosn:(NSInteger) p_posnNo;
- (NSInteger) numberOfOptionsForSearch;
- (void) updateStatusAtPosn:(NSInteger) p_posnNo checkStatus:(BOOL) p_status;

@end

@interface iMerchSearchItems : UIView

/*@property (nonatomic, strong) UIButton * btnBusiness;
@property (nonatomic, strong) UIButton * btnOwner;
@property (nonatomic, strong) UIButton * btnMerchantId;*/
@property (nonatomic,weak) id<iMerchSearchItemsDelegate> searchDelegate;

- (BOOL) bValidateAtleastOneCheck;
- (void) loadOptionsList;

@end

@interface iMerchSearchItemCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andPosnNo:(NSInteger) p_posnNo andDelegate:(id<iMerchSearchItemsDelegate>) p_searchDelegate;
- (void) setCellPosnValue:(NSInteger) p_posnNo;

@end