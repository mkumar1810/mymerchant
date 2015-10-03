//
//  iMerchMerchantDataViewCell.m
//  iMerchant
//
//  Created by Mohan Kumar on 03/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchMerchantDataViewCell.h"
#import "iMerchDefaults.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface iMerchMerchantDataViewCell()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel * _lblcaption;
    UILabel * _lbldetail;
    NSInteger _posnNo;
    BOOL _isNotesCell, _isEMailPhoneCell;
    //UICollectionView * _notesSubListColnVw;
    UITableView * _notesSubListTV;
    UIButton * _actionButton;
}

- (void) displayValues;

@end

@implementation iMerchMerchantDataViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andPosnNo:(NSInteger) p_posnNo andDelegate:(id<iMerchMerchantDataViewDelegate>) p_dataDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _posnNo = p_posnNo;
        self.dataDelegate = p_dataDelegate;
        _isNotesCell = NO;
        if ([reuseIdentifier rangeOfString:@"notes"].location!=NSNotFound)
        {
            _isNotesCell = YES;
        }
        else if (([reuseIdentifier rangeOfString:@"email"].location!=NSNotFound) | ([reuseIdentifier rangeOfString:@"phone"].location!=NSNotFound))
        {
            _isEMailPhoneCell = YES;
        }
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NOPARAMCALLBACK l_drawDividerLine = ^()
    {
        CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(l_ctxref, 1.0);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, 10.0, rect.size.height - 1.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width-1, rect.size.height-1.0);
        CGContextSetLineWidth(l_ctxref, 0.5);
        CGContextStrokePath(l_ctxref);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor lightGrayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, rect.size.width*0.25, 1.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width*0.25, rect.size.height-1.0);
        CGContextStrokePath(l_ctxref);
    };
    if (_lblcaption) {
        l_drawDividerLine();
        return;
    }
    _lblcaption = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_lblcaption];
    _lblcaption.numberOfLines = 0;
    _lblcaption.font = [UIFont boldSystemFontOfSize:13.0f];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_lblcaption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.25 constant:(-12.0)],[NSLayoutConstraint constraintWithItem:_lblcaption attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0)],[NSLayoutConstraint constraintWithItem:_lblcaption attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.25 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_lblcaption attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(0.0)]]];
    if (!_isNotesCell)
    {
        _lbldetail = [iMerchDefaults getStandardLabelWithText:@""];
        [self addSubview:_lbldetail];
        _lbldetail.numberOfLines = 0;
        _lbldetail.font = [UIFont boldSystemFontOfSize:13.0f];
        
        if (_isEMailPhoneCell)
        {
            [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.75 constant:(-50.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.25 constant:(-20.0)]]];
            _actionButton = [iMerchDefaults getStandardButtonWithText:@""];
            [self addSubview:_actionButton];
            [_actionButton setBackgroundColor:[UIColor clearColor]];
            [_actionButton addTarget:self action:@selector(invokeEmailPhoneActions:) forControlEvents:UIControlEventTouchUpInside];
            [_actionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[action(30)]" options:0 metrics:nil views:@{@"action":_actionButton}]];
            [_actionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[action(30)]" options:0 metrics:nil views:@{@"action":_actionButton}]];
            [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2.0 constant:(-30.0)]]];
        }
        else
        {
            [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.75 constant:(-10.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_lbldetail attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.25 constant:(0.0)]]];
        }
        for (UILabel * l_templbl in @[_lblcaption, _lbldetail])
        {
            l_templbl.numberOfLines = 0;
            l_templbl.textAlignment = NSTextAlignmentLeft;
        }
    }
    else
    {
        _notesSubListTV = [UITableView new];
        _notesSubListTV.translatesAutoresizingMaskIntoConstraints = NO;
        _notesSubListTV.delegate = self;
        _notesSubListTV.dataSource = self;
        _notesSubListTV.showsHorizontalScrollIndicator = NO;
        _notesSubListTV.showsVerticalScrollIndicator = NO;
        [_notesSubListTV setBackgroundColor:[UIColor clearColor]];
        [_notesSubListTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_notesSubListTV setSeparatorColor:[UIColor whiteColor]];
        [self addSubview:_notesSubListTV];
        
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_notesSubListTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.75 constant:(-10.0)],[NSLayoutConstraint constraintWithItem:_notesSubListTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0)],[NSLayoutConstraint constraintWithItem:_notesSubListTV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_notesSubListTV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.25 constant:(0.0)]]];
        _lblcaption.numberOfLines = 0;
        _lblcaption.textAlignment = NSTextAlignmentLeft;
    }
    l_drawDividerLine();
    [self displayValues];
    [self layoutIfNeeded];
    _notesSubListTV.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [_notesSubListTV reloadData];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void) showValuesAtPosn:(NSInteger) p_posnNo
{
    _posnNo = p_posnNo;
    [self displayValues];
}

- (void) displayValues
{
    if (!_isNotesCell)
    {
        switch (_posnNo) {
            case 0:
                _lblcaption.text = @"Business \nName";
                _lbldetail.text = [self.dataDelegate getMerchDataBusinessName];
                break;
            case 1:
                _lblcaption.text = @"Owner \nName";
                _lbldetail.text = [self.dataDelegate getMerchdataBusinessOwnerName];
                break;
            case 2:
                _lblcaption.text = @"Business \nPhone";
                _lbldetail.text = [self.dataDelegate getMerchDataBusinessPhone];
                [_actionButton setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
                break;
            case 3:
                _lblcaption.text = @"Cell \nPhone";
                _lbldetail.text = [self.dataDelegate getMerchDataCellPhoneNo];
                [_actionButton setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
                break;
            case 4:
                _lblcaption.text = @"Email \nAddress";
                _lbldetail.text = [self.dataDelegate getMerchDataeMailAddress];
                [_actionButton setBackgroundImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    else
    {
        NSDateFormatter * l_df = [[NSDateFormatter alloc] init];
        [l_df setDateFormat:@"yyyyMMdd"];
        NSDate * l_fordate = [l_df dateFromString:[self.dataDelegate getMerchantNotesDateAtPosn:_posnNo]];
        [l_df setDateFormat:@"M/d/yy"];
        _lblcaption.text = [l_df stringFromDate:l_fordate];
        [_notesSubListTV reloadData];
    }
}

- (void) invokeEmailPhoneActions:(id) sender
{
    if (_posnNo==4)
    {
        if (!((_lbldetail.text==nil) | ([_lbldetail.text length]==0)))
            [self.dataDelegate sendEMailToLeadFromFrame:_actionButton.frame ofView:self];
        [UIView animateWithDuration:0.1
                         animations:^(){
                             _actionButton.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         } completion:^(BOOL p_finished){
                             _actionButton.alpha = 0.5;
                             [UIView animateWithDuration:0.2
                                              animations:^(){
                                                  _actionButton.transform = CGAffineTransformIdentity;
                                                  _actionButton.alpha = 1.0;
                                              }];
                         }];
    }
    if (_posnNo==2 | _posnNo==3)
    {
        if (!((_lbldetail.text==nil) | ([_lbldetail.text length]==0)))
            [self.dataDelegate makePhoneCallUsingNo:_lbldetail.text];
        [UIView animateWithDuration:0.1
                         animations:^(){
                             _actionButton.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         } completion:^(BOOL p_finished){
                             _actionButton.alpha = 0.5;
                             [UIView animateWithDuration:0.2
                                              animations:^(){
                                                  _actionButton.transform = CGAffineTransformIdentity;
                                                  _actionButton.alpha = 1.0;
                                              }];
                         }];
    }
}

- (void) stopbWobblingAtPosn:(NSInteger) p_notesItemNo
{
    iMerchMerchantDataNotesSubCell * l_selectedcell = (iMerchMerchantDataNotesSubCell*) [_notesSubListTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:p_notesItemNo inSection:0]];
    [l_selectedcell stopWobbling];
}

#pragma notes sub table view delegates

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_subnotescell = @"notessub_cell";
    iMerchMerchantDataNotesSubCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_subnotescell];
    if (l_newcell==nil)
    {
        l_newcell = [[iMerchMerchantDataNotesSubCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:l_subnotescell
                     datePosnNo:_posnNo
                     andNotesItemNo:indexPath.row
                     andDelegate:self.dataDelegate];
    }
    else
        [l_newcell setNotesPosnNo:_posnNo andItemNo:indexPath.row];
        //[l_newcell setNotesItemNo:indexPath.row];
    return l_newcell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDelegate getNumberOfNotesAtPosn:_posnNo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2.0*self.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMerchMerchantDataNotesSubCell * l_selectedcell = (iMerchMerchantDataNotesSubCell*) [tableView cellForRowAtIndexPath:indexPath];
    if ([self.dataDelegate showNotesOnExpandedMode:_posnNo andDisplayPosn:indexPath.row fromFrame:[l_selectedcell.superview convertRect:l_selectedcell.frame toView:self] onView:self])
    {
        [l_selectedcell startWobbling];
    };
}

@end

@interface iMerchMerchantDataNotesSubCell()
{
    UILabel * _timeLabel, * _userLabel;
    UILabel * _notesContent;
    id<iMerchMerchantDataViewDelegate> _dataDelegate;
    NSInteger _datePosnNo, _notesItemNo;
}

@end

@implementation iMerchMerchantDataNotesSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier datePosnNo:(NSInteger) p_datePosnNo andNotesItemNo:(NSInteger) p_notesItemNo andDelegate:(id<iMerchMerchantDataViewDelegate>) p_dataDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _dataDelegate = p_dataDelegate;
        _datePosnNo = p_datePosnNo;
        _notesItemNo = p_notesItemNo;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
    _userLabel = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_userLabel];
    _userLabel.numberOfLines = 0;
    _userLabel.font = [UIFont systemFontOfSize:9.0f];
    //_userLabel.backgroundColor = [UIColor greenColor];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[user(20)]" options:0 metrics:nil views:@{@"user":_userLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.75 constant:(-8.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2.0 constant:(-10.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:(0.75) constant:(0.0)]];

    _timeLabel = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_timeLabel];
    _timeLabel.numberOfLines = 1;
    _timeLabel.font = [UIFont systemFontOfSize:9.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    //[_timeLabel setBackgroundColor:[UIColor redColor]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[time(20)]" options:0 metrics:nil views:@{@"time":_timeLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.25 constant:(-8.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2.0 constant:(-10.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:(1.75) constant:(0.0)]];

    _notesContent = [iMerchDefaults getStandardLabelWithText:@""];
    [_notesContent setBackgroundColor:[UIColor whiteColor]];
    _notesContent.font = [UIFont systemFontOfSize:9.0f];
    _notesContent.numberOfLines = 0;
    [self addSubview:_notesContent];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_notesContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(-28.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_notesContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-8.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_notesContent attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-14.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_notesContent attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:(1.00) constant:(0.0)]];
    
    self.layer.masksToBounds = YES;
    self.layer.opaque = NO;
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 0.1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIBezierPath * l_roundpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0f];
    [self.layer setShadowPath:[l_roundpath CGPath]];
    self.clipsToBounds = NO;
    
    [self layoutIfNeeded];
    _userLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _timeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _notesContent.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self displaySettings];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void) setNotesPosnNo:(NSInteger) p_posnNo andItemNo:(NSInteger) p_notesItemNo
{
    _datePosnNo = p_posnNo;
    _notesItemNo = p_notesItemNo;
    if (_userLabel)
    {
        [self displaySettings];
    }
}

- (void) displaySettings
{
    NSDictionary * l_onenotesinfo = [_dataDelegate getMerchantNotesDataAtDatePosn:_datePosnNo andDisplayPosn:_notesItemNo];
    if (l_onenotesinfo)
    {
        _userLabel.text = [l_onenotesinfo valueForKey:@"username"];
        _timeLabel.text = [l_onenotesinfo valueForKey:@"notetime"];
        //_notesContent.text = [l_onenotesinfo valueForKey:@"message"];
        _notesContent.text = [[l_onenotesinfo valueForKey:@"message"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    else
    {
        _userLabel.text = @"";
        _timeLabel.text = @"";
        _notesContent.text = @"";
    }
}

- (void)startWobbling
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,RADIANS(-1));
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^(){
                         self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1));
                     }
                     completion:NULL];
}

- (void)stopWobbling
{
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.0f;
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^(){
                        self.transform = CGAffineTransformIdentity;
                    } completion:NULL];
}

@end