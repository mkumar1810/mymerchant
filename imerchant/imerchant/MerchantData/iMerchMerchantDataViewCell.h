//
//  iMerchMerchantDataViewCell.h
//  iMerchant
//
//  Created by Mohan Kumar on 03/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchMerchantDataViewDelegate <NSObject>

- (NSString*) getMerchDataBusinessName;
- (NSString*) getMerchdataBusinessOwnerName;
- (NSString*) getMerchDataBusinessPhone;
- (NSString*) getMerchDataCellPhoneNo;
- (NSString*) getMerchDataeMailAddress;
- (NSInteger) getNumberOfNotesDaysForThisLead;
- (NSString*) getMerchantNotesDateAtPosn:(NSInteger) p_posnNo;
- (NSInteger) getNumberOfNotesAtPosn:(NSInteger) p_posnNo;
- (NSDictionary*) getMerchantNotesDataAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn;
- (void) sendEMailToLeadFromFrame:(CGRect) p_fromRect ofView:(id) p_onView;
- (BOOL) showNotesOnExpandedMode:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn fromFrame:(CGRect) p_fromFrame onView:(id) p_onView;
- (void) makePhoneCallUsingNo:(NSString*) p_phoneNo;

@end

@interface iMerchMerchantDataViewCell : UITableViewCell 

@property (nonatomic,weak) id<iMerchMerchantDataViewDelegate> dataDelegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andPosnNo:(NSInteger) p_posnNo andDelegate:(id<iMerchMerchantDataViewDelegate>) p_dataDelegate;
- (void) showValuesAtPosn:(NSInteger) p_posnNo;
- (void) stopbWobblingAtPosn:(NSInteger) p_notesItemNo;

@end

@interface iMerchMerchantDataNotesSubCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier datePosnNo:(NSInteger) p_datePosnNo andNotesItemNo:(NSInteger) p_notesItemNo andDelegate:(id<iMerchMerchantDataViewDelegate>) p_dataDelegate;
- (void) setNotesPosnNo:(NSInteger) p_posnNo andItemNo:(NSInteger) p_notesItemNo;
- (void) startWobbling;
- (void) stopWobbling;

@end