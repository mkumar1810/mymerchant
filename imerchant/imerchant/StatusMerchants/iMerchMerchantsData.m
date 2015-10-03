//
//  iMerchMerchantsData.m
//  iMerchant
//
//  Created by Mohan Kumar on 30/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchMerchantsData.h"
#import "iMerchDefaults.h"
#import "iMerchCommonUtilities.h"

@interface iMerchMerchantsData()
{
    CGFloat _rowHeight;
    NSMutableDictionary * _viewsDictionary;
    NSMutableDictionary * _sizeMetrics;
    NSInteger _noofCurrmerchants;
    NSInteger _totalMerchantsAltogether;
}

@property (nonatomic,strong) UITableView * merchantsListTV;
@property (nonatomic,strong) UILabel * noMerchantsLabel;

@end

@implementation iMerchMerchantsData


- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [self setBackgroundColor:[UIColor clearColor]];
        _rowHeight = 60.0f;
        _viewsDictionary = [[NSMutableDictionary alloc] init];
        _sizeMetrics = [[NSMutableDictionary alloc] init];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.merchantsListTV)
    {
        NSLog(@"merchants list already created");
        return;
    }
    
    // Drawing code
    self.merchantsListTV = [UITableView new];
    self.merchantsListTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.merchantsListTV];
    [_viewsDictionary setValue:self.merchantsListTV forKey:@"merchantlist"];
    self.merchantsListTV.dataSource = self;
    self.merchantsListTV.delegate = self;
    [self.merchantsListTV setSeparatorColor:[UIColor clearColor]];
    [self.merchantsListTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.merchantsListTV setBackgroundColor:[UIColor clearColor]];
    self.merchantsListTV.contentInset = UIEdgeInsetsZero;
    [_sizeMetrics setValue:@(rect.size.height) forKey:@"merchantlist_h"];
    [_sizeMetrics setValue:@(0) forKey:@"merchantlist_y"];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.merchantsListTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0],[NSLayoutConstraint constraintWithItem:self.merchantsListTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[merchantlist]" options:0 metrics:_sizeMetrics views:_viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-merchantlist_y-[merchantlist]" options:0 metrics:_sizeMetrics views:_viewsDictionary]];
    self.noMerchantsLabel = [iMerchDefaults getStandardLabelWithText:@"No Merchants Available"];
    self.noMerchantsLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    self.noMerchantsLabel.numberOfLines = 0;
    self.noMerchantsLabel.textAlignment = NSTextAlignmentCenter;
    [self.noMerchantsLabel setTextColor:[UIColor grayColor]];
    [self addSubview:self.noMerchantsLabel];
    [_viewsDictionary setValue:self.noMerchantsLabel forKey:@"nomerchantlabel"];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMerchantsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.merchantsListTV attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-100.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMerchantsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.merchantsListTV attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMerchantsLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.merchantsListTV attribute:NSLayoutAttributeLeft multiplier:1.0 constant:+50.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMerchantsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.merchantsListTV attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.noMerchantsLabel setHidden:YES];
    
    // Drawing code
}

- (void) loadStatusListAgain
{
    [self.merchantsListTV reloadData];
}


- (void)layoutSubviews
{
    [self layoutIfNeeded];
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
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _noofCurrmerchants = [_handlerDelegate getCurrentNumberOfMerchantRowsForTV];
    _totalMerchantsAltogether = [_handlerDelegate getTotalNumberOfMerchants];
    if (_noofCurrmerchants==0)
    {
        [self.noMerchantsLabel setHidden:NO];
        [self.merchantsListTV setHidden:YES];
    }
    else
    {
        [self.noMerchantsLabel setHidden:YES];
        [self.merchantsListTV setHidden:NO];
    }
    return _noofCurrmerchants;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_cellid = @"merchantlist_cell";
    static NSString * l_reloadcellid = @"merchantlist_reload_cell";
    NSString * l_reqdcellid = l_cellid;
    if (_noofCurrmerchants!=_totalMerchantsAltogether)
    {
        if (indexPath.row==(_noofCurrmerchants-1))
            l_reqdcellid = l_reloadcellid;
    }
    iMerchMerchantListCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_reqdcellid];
    if (!l_newcell)
        l_newcell = [[iMerchMerchantListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:l_reqdcellid onPosn:indexPath.row withDelegate:self.handlerDelegate];
    else
        [l_newcell setDisplayValuesAtPosn:indexPath.row];
    return l_newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMerchMerchantListCell * l_selectedcell = (iMerchMerchantListCell*) [tableView cellForRowAtIndexPath:indexPath];
    [self.handlerDelegate
     showDetailsForMerchantAtPosn:indexPath.row
     fromFrame:[tableView convertRect:l_selectedcell.frame toView:self]
     andCellImage:[iMerchCommonUtilities captureView:l_selectedcell]];
    //[l_selectedcell setCellSelectedMode:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* iMerchMerchantListCell * l_selectedcell = (iMerchMerchantListCell*) [tableView cellForRowAtIndexPath:indexPath];
    [l_selectedcell setCellSelectedMode:NO];*/
}

@end

@interface iMerchMerchantListCell()
{
    NSMutableDictionary * _viewsDictionary;
    NSDictionary * _schemaDict;
    NSInteger  _posnNo;
    UILabel * _busnameLabel, * _ownrnameLabel, * _cellphoneLabel;
    UIActivityIndicatorView * _reloadView;
    id<iMerchMerchantsDataDelegate> _handlerDelegate;
    BOOL _reloadOnlyCell;
}

@end

@implementation iMerchMerchantListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier onPosn:(NSInteger)p_posnNo withDelegate:(id<iMerchMerchantsDataDelegate>)p_delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _posnNo = p_posnNo;
        _handlerDelegate = p_delegate;
        _viewsDictionary = [[NSMutableDictionary alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        _schemaDict = [_handlerDelegate getSchemaDictionary];
        if ([reuseIdentifier rangeOfString:@"reload"].location!=NSNotFound)
        {
            _reloadOnlyCell = YES;
            [self setAccessoryType:UITableViewCellAccessoryNone];
        }
        else
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_reloadOnlyCell)
    {
        [self drawReLoadViewCell];
        return;
    }
    NOPARAMCALLBACK l_drawline = ^(){
        CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(l_ctxref, 1.0);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, 10, rect.size.height-1);
        CGContextAddLineToPoint(l_ctxref, rect.size.width, rect.size.height-1);
        CGContextStrokePath(l_ctxref);
        
        CGContextSetLineWidth(l_ctxref, 0.5);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor lightGrayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, 25, rect.size.height/2.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width - 40, rect.size.height/2.0);
        CGContextStrokePath(l_ctxref);

        CGContextMoveToPoint(l_ctxref, rect.size.width*0.6, rect.size.height/2.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width*0.6, rect.size.height-1);
        CGContextStrokePath(l_ctxref);
    };
    if (_busnameLabel)
    {
        l_drawline();
        /*UIBezierPath * l_reqdpath = [UIBezierPath bezierPathWithRoundedRect:_titleLabel.bounds cornerRadius:10.0f];
        [_titleLabel.layer setShadowPath:[l_reqdpath CGPath]];
        _titleLabel.clipsToBounds = NO;*/
        return;
    }
    _busnameLabel  = [iMerchDefaults getStandardLabelWithText:@"business"];
    [self addSubview:_busnameLabel];
    _busnameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_viewsDictionary setValue:_busnameLabel forKey:@"busname"];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_busnameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(-40.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_busnameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:(-2.0)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[busname]" options:0 metrics:nil views:_viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[busname]" options:0 metrics:nil views:_viewsDictionary]];
    
    _ownrnameLabel = [iMerchDefaults getStandardLabelWithText:@"owner"];
    [self addSubview:_ownrnameLabel];
    [_viewsDictionary setValue:_ownrnameLabel forKey:@"ownrname"];
    _ownrnameLabel.font = [UIFont systemFontOfSize:11.0f];
    _ownrnameLabel.numberOfLines = 0;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ownrnameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.6 constant:(-20.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ownrnameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:(-2.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ownrnameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.2 constant:(0.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ownrnameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(1.0)]];
    
    _cellphoneLabel = [iMerchDefaults getStandardLabelWithText:@"cellphone"];
    [self addSubview:_cellphoneLabel];
    [_viewsDictionary setValue:_cellphoneLabel forKey:@"cellphone"];
    _cellphoneLabel.font = [UIFont systemFontOfSize:11.0f];
    _cellphoneLabel.textAlignment = NSTextAlignmentRight;
    _cellphoneLabel.textColor = [UIColor blueColor];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellphoneLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.4 constant:(-30.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellphoneLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:(-2.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellphoneLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.2 constant:(0.0)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellphoneLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(1.0)]];
    [self layoutIfNeeded];
    l_drawline();
    UIView * l_vw = [UIView new];
    [l_vw setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.98]];
    [self setSelectedBackgroundView:l_vw];
    [self displayValues];
}

- (void) drawReLoadViewCell
{
    _reloadView = [UIActivityIndicatorView new];
    _reloadView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _reloadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_reloadView];
    [_reloadView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[reload(20)]" options:0 metrics:nil views:@{@"reload":_reloadView}]];
    [_reloadView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reload(20)]" options:0 metrics:nil views:@{@"reload":_reloadView}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_reloadView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_reloadView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    _reloadView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    //[l_reloadView setHidesWhenStopped:YES];
    [_reloadView startAnimating];
    [_handlerDelegate paginateToNextMerchantsList];
}

- (void)setDisplayValuesAtPosn:(NSInteger)p_posnNo
{
    _posnNo = p_posnNo;
    if (!_reloadOnlyCell)
    {
        if (_busnameLabel)
            [self displayValues];
    }
    else
    {
        [_reloadView startAnimating];
        [_handlerDelegate paginateToNextMerchantsList];
    }
}

- (void) displayValues
{
    NSDictionary * l_merchantdict = [_handlerDelegate getMerchantDataAtPosn:_posnNo];
    _busnameLabel.text = [[l_merchantdict valueForKey:[_schemaDict valueForKey:@"Business Name"]] capitalizedString];
    _ownrnameLabel.text = [l_merchantdict valueForKey:[_schemaDict valueForKey:@"Owner Name"]];
    _cellphoneLabel.text = [l_merchantdict valueForKey:[_schemaDict valueForKey:@"Cell Phone"]];
    NSInteger l_cellphoneno = [[_cellphoneLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
    if (l_cellphoneno==0)
    {
        _cellphoneLabel.text = [l_merchantdict valueForKey:[_schemaDict valueForKey:@"Business Phone"]];
    }
}

- (void) setCellSelectedMode:(BOOL) p_selected
{
    /*if (p_selected)
        [_titleLabel.layer setBorderColor:[UIColor blueColor].CGColor];
    else
        [_titleLabel.layer setBorderColor:[UIColor blackColor].CGColor];*/
}

@end
