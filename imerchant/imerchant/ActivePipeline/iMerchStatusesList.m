//
//  iMerchStatusesList.m
//  iMerchant
//
//  Created by Mohan Kumar on 29/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchStatusesList.h"
#import "iMerchDefaults.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface iMerchStatusesList()<UIGestureRecognizerDelegate>
{
    CGFloat _rowHeight;
    NSMutableDictionary * _viewsDictionary;
    //NSMutableDictionary * _sizeMetrics;
    UITapGestureRecognizer * _tapGesture;
    NSIndexPath * _selectedIndex;
}

@property (nonatomic,strong) UITableView * statusesListTV;

@end

@implementation iMerchStatusesList


- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [self setBackgroundColor:[UIColor clearColor]];
        _rowHeight = 60.0f;
        _viewsDictionary = [[NSMutableDictionary alloc] init];
        //_sizeMetrics = [[NSMutableDictionary alloc] init];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.statusesListTV)
        return;
    self.statusesListTV = [UITableView new];
    self.statusesListTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.statusesListTV];
    [_viewsDictionary setValue:self.statusesListTV forKey:@"statuslist"];
    self.statusesListTV.dataSource = self;
    self.statusesListTV.delegate = self;
    [self.statusesListTV setSeparatorColor:[UIColor clearColor]];
    [self.statusesListTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.statusesListTV setBackgroundColor:[UIColor clearColor]];
    self.statusesListTV.contentInset = UIEdgeInsetsZero;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.statusesListTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0],[NSLayoutConstraint constraintWithItem:self.statusesListTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.statusesListTV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.statusesListTV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    _tapGesture = [[UITapGestureRecognizer alloc] init];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
}

- (void) loadStatusListAgain
{
    [self.statusesListTV reloadData];
}

- (void)layoutSubviews
{
    [self layoutIfNeeded];
}

#pragma tableview delegates

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1 * _rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1 * _rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * l_hdrvw = [UIView new];
    [l_hdrvw setBackgroundColor:[UIColor clearColor]];
    return l_hdrvw;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * l_ftrvw = [UIView new];
    [l_ftrvw setBackgroundColor:[UIColor clearColor]];
    return l_ftrvw;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight * 2.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger l_noofrows = [_handlerDelegate getNumberOfStatusPairs];
    return l_noofrows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_doublecellid = @"doublelist_cell";
    static NSString * l_singlecellid = @"singlelist_cell";
    NSString * l_reqdcellid = l_doublecellid;
    if ([self.handlerDelegate getNumberOfStatuses]<((indexPath.row+1)*2))
        l_reqdcellid = l_singlecellid;
    iMerchStatusesListCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_reqdcellid];
    if (!l_newcell)
        l_newcell = [[iMerchStatusesListCell alloc]
                     initWithStyle:UITableViewCellStyleSubtitle
                     reuseIdentifier:l_reqdcellid
                     onPosn:indexPath.row
                     withDelegate:self.handlerDelegate];
    else
        [l_newcell setDisplayValuesAtPosn:indexPath.row];
    return l_newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*iMerchStatusesListCell * l_selectedcell = (iMerchStatusesListCell*) [tableView cellForRowAtIndexPath:indexPath];*/
    //[self.handlerDelegate showDetailsForStatusAtPosn:indexPath.row];
    
    /*[l_selectedcell setCellSelectedMode:YES];
    [l_selectedcell setCellSelectedMode:NO];*/
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //iMerchStatusesListCell * l_selectedcell = (iMerchStatusesListCell*) [tableView cellForRowAtIndexPath:indexPath];
    //[l_selectedcell setCellSelectedMode:NO];
}

#pragma uigesture recognizer delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint l_touchPoint = [touch locationInView:self.statusesListTV];
    NSIndexPath * l_cellPath = [self.statusesListTV indexPathForRowAtPoint:l_touchPoint];
    if (l_cellPath!=nil)
    {
        iMerchStatusesListCell * l_tappedCell = (iMerchStatusesListCell*) [self.statusesListTV cellForRowAtIndexPath:l_cellPath];
        CGPoint l_tapPoint = [touch locationInView:l_tappedCell];
        if (_selectedIndex.row==l_cellPath.row)
        {
            [l_tappedCell setStatusSelectedBasedOnPosn:l_tapPoint];
        }
        else
        {
            iMerchStatusesListCell * l_prevtappedCell = (iMerchStatusesListCell*) [self.statusesListTV cellForRowAtIndexPath:_selectedIndex];
            [l_prevtappedCell setCellButtonsWobbleStopped];
            [l_tappedCell setStatusSelectedBasedOnPosn:l_tapPoint];
        }
        _selectedIndex = l_cellPath;
    }
    else if (_selectedIndex)
    {
        iMerchStatusesListCell * l_prevtappedCell = (iMerchStatusesListCell*) [self.statusesListTV cellForRowAtIndexPath:_selectedIndex];
        [l_prevtappedCell setCellButtonsWobbleStopped];
        _selectedIndex = nil;
    }
    return NO;
}

@end

@interface iMerchStatusesListCell()
{
    NSInteger  _posnNo;
    iMerchStatusListCellCustBtn * _titleBtn1, * _titleBtn2;
    id<iMerchStatusesListDelegate> _handlerDelegate;
    BOOL _isSingleBtnCell;
    NSInteger _wobblingBtnNo;
}

@end

@implementation iMerchStatusesListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier onPosn:(NSInteger)p_posnNo withDelegate:(id<iMerchStatusesListDelegate>)p_delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _posnNo = p_posnNo;
        _handlerDelegate = p_delegate;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([reuseIdentifier rangeOfString:@"single"].location!=NSNotFound)
        {
            _isSingleBtnCell = YES;
        }
        _wobblingBtnNo = -1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_titleBtn1)
    {
        UIBezierPath * l_titlepathn1 = [UIBezierPath bezierPathWithRoundedRect:_titleBtn1.bounds cornerRadius:10.0f];
        [_titleBtn1.layer setShadowPath:l_titlepathn1.CGPath];
        
        if (!_isSingleBtnCell)
        {
            
            UIBezierPath * l_titlepathn2 = [UIBezierPath bezierPathWithRoundedRect:_titleBtn2.bounds cornerRadius:10.0f];
            [_titleBtn2.layer setShadowPath:l_titlepathn2.CGPath];
        }
        return;
    }

    _titleBtn1 = [iMerchStatusListCellCustBtn new];
    _titleBtn1.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleBtn1];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_titleBtn1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.53 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    _titleBtn1.layer.masksToBounds = YES;
    _titleBtn1.layer.opaque = NO;
    _titleBtn1.layer.cornerRadius = 10.0f;
    _titleBtn1.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _titleBtn1.layer.shadowOpacity = 0.05;
    _titleBtn1.layer.borderWidth = 1.0f;
    _titleBtn1.layer.borderColor = [UIColor blackColor].CGColor;
    UIBezierPath * l_titlepath1 = [UIBezierPath bezierPathWithRoundedRect:_titleBtn1.bounds cornerRadius:10.0f];
    [_titleBtn1.layer setShadowPath:l_titlepath1.CGPath];
    
    if (!_isSingleBtnCell)
    {
        _titleBtn2 = [iMerchStatusListCellCustBtn new];
        _titleBtn2.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleBtn2];
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_titleBtn2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.40 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.47 constant:0.0],[NSLayoutConstraint constraintWithItem:_titleBtn2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
        _titleBtn2.layer.masksToBounds = YES;
        _titleBtn2.layer.opaque = NO;
        _titleBtn2.layer.cornerRadius = 10.0f;
        _titleBtn2.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        _titleBtn2.layer.shadowOpacity = 0.05;
        _titleBtn2.layer.borderWidth = 1.0f;
        _titleBtn2.layer.borderColor = [UIColor blackColor].CGColor;
        UIBezierPath * l_titlepath2 = [UIBezierPath bezierPathWithRoundedRect:_titleBtn2.bounds cornerRadius:10.0f];
        [_titleBtn2.layer setShadowPath:l_titlepath2.CGPath];
    }
    _wobblingBtnNo = -1;
    [self layoutIfNeeded];
    [self displayValues];
}

- (void)setDisplayValuesAtPosn:(NSInteger)p_posnNo
{
    _posnNo = p_posnNo;
    if (_titleBtn1)
        [self displayValues];
}

- (void) displayValues
{
    NSDictionary * l_dict1 = [_handlerDelegate getStatusDictAtPosn:_posnNo andOffset:0];
    [_titleBtn1 setDisplayDataWithDict:l_dict1];
    if (!_isSingleBtnCell)
    {
        NSDictionary * l_dict2 = [_handlerDelegate getStatusDictAtPosn:_posnNo andOffset:1];
        [_titleBtn2 setDisplayDataWithDict:l_dict2];
    }
}

- (void) setStatusSelectedBasedOnPosn:(CGPoint) p_touchPoint
{
    NSInteger l_reqdBtnNo = -1;
    if (CGRectContainsPoint(_titleBtn1.frame, p_touchPoint))
        l_reqdBtnNo = 0;
    else if (CGRectContainsPoint(_titleBtn2.frame, p_touchPoint))
        l_reqdBtnNo = 1;
    if (_wobblingBtnNo!=l_reqdBtnNo)
    {
        [self setCellButtonsWobbleStopped];
    }
    else if (_wobblingBtnNo==l_reqdBtnNo)
    {
        [self setCellButtonsWobbleStopped];
        if (l_reqdBtnNo==0)
        {
            [_handlerDelegate showDetailsForStatusAtPosn:_posnNo andOffset:0];
            return;
        }
        if (l_reqdBtnNo==1)
        {
            [_handlerDelegate showDetailsForStatusAtPosn:_posnNo andOffset:1];
            return;
        }
    }
    _wobblingBtnNo = l_reqdBtnNo;
    if (l_reqdBtnNo==0)
    {
        [self startWobble:_titleBtn1];
        return;
    }
    if (l_reqdBtnNo==1)
    {
        [self startWobble:_titleBtn2];
        return;
    }
}

- (void) setCellButtonsWobbleStopped
{
    if (_wobblingBtnNo==0)
    {
        [self stopWobble:_titleBtn1];
    }
    if (_wobblingBtnNo==1)
    {
        [self stopWobble:_titleBtn2];
    }
    _wobblingBtnNo = -1;
}

- (void) startWobble:(UIView*) p_wobbleView
{
    p_wobbleView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,RADIANS(-1));
    [p_wobbleView.layer setBorderWidth:2.0f];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^{
                         p_wobbleView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1));
                     } completion:NULL];
}

- (void) stopWobble:(UIView*) p_wobbleView
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^{
                         p_wobbleView.transform = CGAffineTransformIdentity;
                         [p_wobbleView.layer setBorderWidth:1.0f];
                     } completion:NULL];
}

@end

@interface iMerchStatusListCellCustBtn()
{
    UILabel * _lblTitle;
    UILabel * _lblCounter;
    NSDictionary * _displayDict;
}

@end

@implementation iMerchStatusListCellCustBtn

- (void) drawRect:(CGRect)rect
{
    NOPARAMCALLBACK l_drawLine = ^(){
        _lblCounter.layer.masksToBounds = YES;
        _lblCounter.layer.opaque = NO;
        _lblCounter.layer.cornerRadius = rect.size.height/4.0;
    };
    
    if (_lblTitle)
    {
        l_drawLine();
        return;
    }
    _lblTitle = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_lblTitle];
    _lblTitle.font = [UIFont systemFontOfSize:18.0f];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_lblTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_lblTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0],[NSLayoutConstraint constraintWithItem:_lblTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_lblTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0.5 constant:0.0]]];
    
    _lblCounter = [iMerchDefaults getStandardLabelWithText:@""];
    [self addSubview:_lblCounter];
    _lblCounter.font = [UIFont systemFontOfSize:20.0f];
    [_lblCounter setBackgroundColor:[UIColor greenColor]];
    [_lblCounter setTextAlignment:NSTextAlignmentCenter];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_lblCounter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_lblCounter attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:(0.0)],[NSLayoutConstraint constraintWithItem:_lblCounter attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_lblCounter attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.5 constant:(-4.0)]]];
    l_drawLine();
    [self layoutIfNeeded];
    [self setDisplayValuesFromDict];
}

- (void) setDisplayDataWithDict:(NSDictionary*) p_dataDict
{
    _displayDict = p_dataDict;
    if (_lblTitle)
        [self setDisplayValuesFromDict];
}

- (void) setDisplayValuesFromDict
{
    _lblTitle.text = [[_displayDict valueForKey:@"status"] capitalizedString];
    _lblCounter.text = [[_displayDict valueForKey:@"noofbusinesses"] stringValue];
}

@end