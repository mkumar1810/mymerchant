//
//  iMerchSearchItems.m
//  iMerchant
//
//  Created by Mohan Kumar on 17/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import "iMerchSearchItems.h"
#import "iMerchDefaults.h"

@interface iMerchSearchItems()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _rowHeight;
}

@property (nonatomic,strong) UITableView * searchTV;

@end

@implementation iMerchSearchItems

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:0.98]];
        _rowHeight = 60.0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.searchTV) {
        return;
    }
    
    self.searchTV = [UITableView new];
    self.searchTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchTV];
    self.searchTV.dataSource = self;
    self.searchTV.delegate = self;
    [self.searchTV setSeparatorColor:[UIColor clearColor]];
    [self.searchTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.searchTV setBackgroundColor:[UIColor clearColor]];
    self.searchTV.contentInset = UIEdgeInsetsZero;
    [self.searchTV setScrollEnabled:NO];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.searchTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    
    [self.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:0.8].CGColor];
    [self.layer setBorderWidth:0.5];
    self.layer.cornerRadius = 3.0f;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = 0.3;
    self.clipsToBounds = NO;
}

- (void) buttonOptionPressed:(id) sender
{
    UIButton * l_pressedBtn = (UIButton*) sender;
    l_pressedBtn.selected = !l_pressedBtn.selected;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self layoutIfNeeded];
    UIBezierPath * l_shadowpath = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(self.layer.bounds,-3,3) cornerRadius:3.0f];
    self.layer.shadowPath = [l_shadowpath CGPath];
}

- (BOOL) bValidateAtleastOneCheck
{
    NSInteger l_noofRows = [self.searchDelegate numberOfOptionsForSearch];
    for (NSInteger l_counter=0; l_counter<l_noofRows; l_counter++)
    {
        NSDictionary * l_searchdata = [_searchDelegate getOptionDataAtPosn:l_counter];
        if ([[l_searchdata valueForKey:@"checked"] integerValue]!=0)
        {
            return YES;
        }
    }
    return NO;
}

- (void)loadOptionsList
{
    [self.searchTV reloadData];
}

#pragma search items table view delegates


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
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searchDelegate numberOfOptionsForSearch]==0)
        return 0;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchDelegate numberOfOptionsForSearch];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_searchcellid = @"merchantsearch_cell";
    iMerchSearchItemCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_searchcellid];
    if (!l_newcell)
        l_newcell = [[iMerchSearchItemCell alloc]
                     initWithStyle:UITableViewCellStyleSubtitle
                     reuseIdentifier:l_searchcellid
                     andPosnNo:indexPath.row
                     andDelegate:self.searchDelegate];
    else
        [l_newcell setCellPosnValue:indexPath.row];
    return l_newcell;
}

@end


@interface iMerchSearchItemCell()
{
    UIButton * _btnSearchCheck;
    UILabel * _lblSearchCaption;
    NSInteger _posnNo;
    id<iMerchSearchItemsDelegate> _searchDelegate;
}

@end

@implementation iMerchSearchItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andPosnNo:(NSInteger) p_posnNo andDelegate:(id<iMerchSearchItemsDelegate>) p_searchDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _posnNo = p_posnNo;
        _searchDelegate = p_searchDelegate;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _btnSearchCheck = [iMerchDefaults getStandardButton];
    _btnSearchCheck.translatesAutoresizingMaskIntoConstraints = YES;
    [self.contentView addSubview:_btnSearchCheck];
    [_btnSearchCheck setFrame:CGRectMake(20, (rect.size.height - 30.0)/2.0, 30.0, 30.0)];
    [_btnSearchCheck setImage:[UIImage imageNamed:@"chkbox_check"] forState:UIControlStateSelected];
    [_btnSearchCheck setImage:[UIImage imageNamed:@"chkbox_uncheck"] forState:UIControlStateNormal];
    [_btnSearchCheck addTarget:self action:@selector(buttonOptionPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _lblSearchCaption = [iMerchDefaults getStandardLabelWithText:@""];
    _lblSearchCaption.translatesAutoresizingMaskIntoConstraints = YES;
    [_lblSearchCaption setFrame:CGRectMake(60, (rect.size.height - 30.0)/2.0, (rect.size.width - 70.0), 30.0)];
    [_lblSearchCaption setFont:[UIFont systemFontOfSize:14.0f]];
    [self.contentView addSubview:_lblSearchCaption];
    UIView * l_selvw = [UIView new];
    [l_selvw setBackgroundColor:[UIColor clearColor]];
    [self setSelectedBackgroundView:l_selvw];
    [self displaySettingValues];
}

- (void) setCellPosnValue:(NSInteger) p_posnNo
{
    _posnNo = p_posnNo;
    if (_btnSearchCheck)
        [self displaySettingValues];
}

- (void) displaySettingValues
{
    NSDictionary * l_searchdata = [_searchDelegate getOptionDataAtPosn:_posnNo];
    _btnSearchCheck.selected = [[l_searchdata valueForKey:@"checked"] boolValue];
    _lblSearchCaption.text = [l_searchdata valueForKey:@"displaycaption"];
}

- (void) buttonOptionPressed
{
    _btnSearchCheck.selected = !_btnSearchCheck.selected;
    [_searchDelegate updateStatusAtPosn:_posnNo checkStatus:_btnSearchCheck.selected];
}

@end