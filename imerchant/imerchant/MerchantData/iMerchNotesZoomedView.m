//
//  iMerchNotesZoomedView.m
//  iMerchant
//
//  Created by Mohan Kumar on 23/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import "iMerchNotesZoomedView.h"
#import "iMerchDefaults.h"

@interface iMerchNotesZoomedView() <UITextViewDelegate>
{
    UILabel * _timeLabel, * _userLabel;
    UITextView * _txtvwNotes;
    UIButton * _cancelBtn;
    //UILabel * _notesContent;
    id<iMerchNotesZoomedViewDelegate> _dataDelegate;
}

@end

@implementation iMerchNotesZoomedView

- (void) setDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn andDataDelegate:(id<iMerchNotesZoomedViewDelegate>) p_dataDelegate
{
    self.datePosnNo = p_datePosn;
    self.notesItemNo = p_displayPosn;
    _dataDelegate = p_dataDelegate;
    [self setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:0.92]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _cancelBtn = [UIButton new];
    [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelZoomedDisplay:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cancelBtn];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancel(26)]" options:0 metrics:nil views:@{@"cancel":_cancelBtn}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancel(26)]" options:0 metrics:nil views:@{@"cancel":_cancelBtn}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[cancel]" options:0 metrics:nil views:@{@"cancel":_cancelBtn}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[cancel]" options:0 metrics:nil views:@{@"cancel":_cancelBtn}]];
    
    _userLabel = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_userLabel];
    _userLabel.numberOfLines = 1;
    _userLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[user(30)]" options:0 metrics:nil views:@{@"user":_userLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.75 constant:(-40.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.75 constant:(20.0)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[user]" options:0 metrics:nil views:@{@"user":_userLabel}]];
    
    _timeLabel = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_timeLabel];
    _timeLabel.numberOfLines = 1;
    _timeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[time(30)]" options:0 metrics:nil views:@{@"time":_timeLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.25 constant:(-12.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.75 constant:(2.0)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[time]" options:0 metrics:nil views:@{@"time":_timeLabel}]];
    
    _txtvwNotes = [UITextView new];
    _txtvwNotes.translatesAutoresizingMaskIntoConstraints = NO;
    _txtvwNotes.textColor = [iMerchDefaults getDefaultTextColor];
    _txtvwNotes.textAlignment = NSTextAlignmentLeft;
    [_txtvwNotes setBackgroundColor:[UIColor whiteColor]];
    _txtvwNotes.font = [UIFont systemFontOfSize:11.0f];
    _txtvwNotes.showsVerticalScrollIndicator = YES;
    _txtvwNotes.delegate = self;
    [self addSubview:_txtvwNotes];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_txtvwNotes attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(-8.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_txtvwNotes attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-34.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_txtvwNotes attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_txtvwNotes attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:(1.00) constant:(12.0)]];
    
    self.layer.masksToBounds = YES;
    self.layer.opaque = NO;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 0.1;
    self.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.9].CGColor;
    
    UIBezierPath * l_roundpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0f];
    [self.layer setShadowPath:[l_roundpath CGPath]];
    self.clipsToBounds = NO;
    
    [self layoutIfNeeded];
    [self displaySettings];
}

- (void) displaySettings
{
    NSDictionary * l_onenotesinfo = [_dataDelegate getMerchantDataForZoomAtDatePosn:self.datePosnNo andDisplayPosn:self.notesItemNo];
    if (l_onenotesinfo)
    {
        _userLabel.text = [l_onenotesinfo valueForKey:@"username"];
        _timeLabel.text = [l_onenotesinfo valueForKey:@"notetime"];
        _txtvwNotes.text = [l_onenotesinfo valueForKey:@"message"];
    }
    else
    {
        _userLabel.text = @"";
        _timeLabel.text = @"";
        _txtvwNotes.text = @"";
    }
}

- (void) cancelZoomedDisplay:(id) sender
{
    [_dataDelegate notesZoomedViewCancelled];
}

#pragma text view related delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
