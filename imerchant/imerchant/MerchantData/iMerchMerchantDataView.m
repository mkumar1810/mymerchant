//
//  iMerchMerchantDataView.m
//  iMerchant
//
//  Created by Mohan Kumar on 03/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchMerchantDataView.h"

@interface iMerchMerchantDataView()
{
    CGFloat _rowHeight;
    NSMutableDictionary * _viewsDictionary;
    NSMutableDictionary * _sizeMetrics;
    UILabel * _notesTitleLbl;
}

@property (nonatomic,strong) UITableView * merchantsDataTV;

@end

@implementation iMerchMerchantDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [self setBackgroundColor:[UIColor clearColor]];
        _rowHeight = 50.0f;
        _viewsDictionary = [[NSMutableDictionary alloc] init];
        _sizeMetrics = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.merchantsDataTV) {
        return;
    }
    // Drawing code
    self.merchantsDataTV = [UITableView new];
    self.merchantsDataTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.merchantsDataTV];
    [_viewsDictionary setValue:self.merchantsDataTV forKey:@"merchantlist"];
    self.merchantsDataTV.dataSource = self;
    self.merchantsDataTV.delegate = self;
    [self.merchantsDataTV setSeparatorColor:[UIColor clearColor]];
    [self.merchantsDataTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.merchantsDataTV setBackgroundColor:[UIColor clearColor]];
    self.merchantsDataTV.contentInset = UIEdgeInsetsZero;
    [_sizeMetrics setValue:@(rect.size.height) forKey:@"merchantlist_h"];
    [_sizeMetrics setValue:@(0) forKey:@"merchantlist_y"];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.merchantsDataTV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.merchantsDataTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0],[NSLayoutConstraint constraintWithItem:self.merchantsDataTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1.0],[NSLayoutConstraint constraintWithItem:self.merchantsDataTV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    
    // Drawing code
}

- (void) loadStatusListAgain
{
    [self.merchantsDataTV reloadData];
}

- (void) loadNotesData
{
    /*if (self.merchantsDataTV.numberOfSections==1)
        [self.merchantsDataTV insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    else
        [self.merchantsDataTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];*/
    [self.merchantsDataTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) stopWobblingAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn
{
    //wobbling stopping to be done in notes portion
    iMerchMerchantDataViewCell * l_wobblingcell = (iMerchMerchantDataViewCell*) [self.merchantsDataTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:p_datePosn inSection:1]];
    [l_wobblingcell stopbWobblingAtPosn:p_displayPosn];
}

#pragma merchants listing table view delegates

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return 0;
    else
        return _rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.handlerDelegate getNumberOfNotesDaysForThisLead]>0)
    {
        if (_notesTitleLbl)
        {
            [_notesTitleLbl removeFromSuperview];
            [_notesTitleLbl.superview removeFromSuperview];
        }
        else
        {
            _notesTitleLbl = [iMerchDefaults getStandardLabelWithText:@"User Notes"];
            _notesTitleLbl.font = [UIFont boldSystemFontOfSize:14.0f];
            _notesTitleLbl.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            _notesTitleLbl.textAlignment = NSTextAlignmentCenter;
        }
        
        UIView * l_vw = [UIView new];
        [l_vw setBackgroundColor:[UIColor clearColor]];
        [l_vw addSubview:_notesTitleLbl];
        [l_vw addConstraints:@[[NSLayoutConstraint constraintWithItem:_notesTitleLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:l_vw attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_notesTitleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:l_vw attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-15.0)],[NSLayoutConstraint constraintWithItem:_notesTitleLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:l_vw attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(8.0)],[NSLayoutConstraint constraintWithItem:_notesTitleLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:l_vw attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]]];
        return l_vw;
    }
    else
    {
        UIView * l_vw = [UIView new];
        [l_vw setBackgroundColor:[UIColor clearColor]];
        return l_vw;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return _rowHeight;
    else
        return 1.5*_rowHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 5;
    else
        return [self.handlerDelegate getNumberOfNotesDaysForThisLead];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_datacellid = @"merchantdata_cell";
    static NSString * l_notescellid = @"notes_cell";
    static NSString * l_emailphonecellid = @"email_phone_cell";
    NSString * l_reqdcellid = indexPath.section==0?(indexPath.row<2?l_datacellid:l_emailphonecellid):l_notescellid;
    iMerchMerchantDataViewCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_reqdcellid];
    if (!l_newcell)
        l_newcell = [[iMerchMerchantDataViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:l_reqdcellid andPosnNo:indexPath.row andDelegate:self.handlerDelegate];
    else
        [l_newcell showValuesAtPosn:indexPath.row];
    return l_newcell;
}

@end

