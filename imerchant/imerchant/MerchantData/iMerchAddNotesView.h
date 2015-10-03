//
//  iMerchAddNotesView.h
//  iMerchant
//
//  Created by Mohan Kumar on 04/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchAddNotesDelegate <NSObject>

- (void) addNotesCancelled;
- (void) addNotesMessage:(NSString*) p_notesMessage;

@end

@interface iMerchAddNotesView : UIView <UITextViewDelegate>

@property (nonatomic,weak) id<iMerchAddNotesDelegate> notesDelegate;
@property (nonatomic) CGAffineTransform transformStart;

- (NSArray*) bValidateNotesdata;

@end
