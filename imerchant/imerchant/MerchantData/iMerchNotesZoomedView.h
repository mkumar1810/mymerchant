//
//  iMerchNotesZoomedView.h
//  iMerchant
//
//  Created by Mohan Kumar on 23/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchNotesZoomedViewDelegate <NSObject>

- (void) notesZoomedViewCancelled;
- (NSDictionary*) getMerchantDataForZoomAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn;

@end

@interface iMerchNotesZoomedView : UIView
//NSInteger _datePosnNo, _notesItemNo;
- (void) setDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn andDataDelegate:(id<iMerchNotesZoomedViewDelegate>) p_dataDelegate;

@property (nonatomic,weak) id<iMerchNotesZoomedViewDelegate> zoomDelegate;
//@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGAffineTransform transformStart;
@property (nonatomic) NSInteger datePosnNo;
@property (nonatomic) NSInteger notesItemNo;

@end
