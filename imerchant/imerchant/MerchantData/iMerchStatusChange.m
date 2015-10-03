//
//  iMerchStatusChange.m
//  imerchant
//
//  Created by Mohan Kumar on 19/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchStatusChange.h"
#import "iMerchDefaults.h"

@interface iMerchStatusChange()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _selectedStatusCellNo;
}

@property (nonatomic,strong) UIToolbar * toolBar;
@property (nonatomic,strong) UICollectionView * statusListCV;

@end

@implementation iMerchStatusChange

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _selectedStatusCellNo = -1;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NOPARAMCALLBACK l_drawLine = ^(){
        CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(l_ctxref, 1.0);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, 0, 38.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width, 38.0);
        CGContextStrokePath(l_ctxref);
    };
    
    if (self.toolBar) {
        l_drawLine();
        return;
    }

    UIBarButtonItem * l_bar_cancel_btn, * l_bar_chgstatus_btn;
    self.toolBar = [UIToolbar new];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolBar.barTintColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    self.toolBar.translucent = NO;
    [self addSubview:self.toolBar];
    
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title(38)]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    
    UILabel * l_titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 38.0)];
    l_titlelabel.text = @"Status";
    l_titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    l_titlelabel.textAlignment = NSTextAlignmentCenter;
    l_titlelabel.textColor = [UIColor whiteColor];
    UIBarButtonItem * l_titlebtn = [[UIBarButtonItem alloc] initWithCustomView:l_titlelabel];
    UIBarButtonItem * l_flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * l_flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton * l_cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 2.0, 26.0, 26.0)];
    [l_cancelbtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    
    [l_cancelbtn addTarget:self action:@selector(cancelStatusChange) forControlEvents:UIControlEventTouchUpInside];
    l_cancelbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    l_bar_cancel_btn = [[UIBarButtonItem alloc] initWithCustomView:l_cancelbtn];
    
    UIButton * l_chgstatusbtn = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 2.0, 55.0, 26.0)];
    [l_chgstatusbtn setTitle:@"Change" forState:UIControlStateNormal];
    [l_chgstatusbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [l_chgstatusbtn addTarget:self action:@selector(changeStatusOfMerchant) forControlEvents:UIControlEventTouchUpInside];
    l_chgstatusbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    l_bar_chgstatus_btn = [[UIBarButtonItem alloc] initWithCustomView:l_chgstatusbtn];
    self.toolBar.items = @[l_bar_cancel_btn, l_flex1, l_titlebtn, l_flex2, l_bar_chgstatus_btn];
    
    UICollectionViewFlowLayout * l_reqdcolnLayout = [[UICollectionViewFlowLayout alloc] init];
    self.statusListCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:l_reqdcolnLayout];
    self.statusListCV.translatesAutoresizingMaskIntoConstraints = NO;
    l_reqdcolnLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    l_reqdcolnLayout.footerReferenceSize = CGSizeZero;
    l_reqdcolnLayout.itemSize = CGSizeMake(120.0, 120.0);
    l_reqdcolnLayout.minimumInteritemSpacing = 0;
    l_reqdcolnLayout.minimumLineSpacing = 0;
    l_reqdcolnLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _selectedStatusCellNo = [self.statChgDelegate getCurrentMerchantStatusPosn];
    self.statusListCV.delegate = self;
    self.statusListCV.dataSource = self;
    [self.statusListCV setBackgroundColor:[UIColor clearColor]];
    self.statusListCV.showsVerticalScrollIndicator = YES;
    self.statusListCV.showsHorizontalScrollIndicator = NO;
    self.statusListCV.scrollEnabled = YES;
    [self.statusListCV registerClass:[iMerchStatusChangeCell class] forCellWithReuseIdentifier:@"status_cell"];
    [self addSubview:self.statusListCV];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.statusListCV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.statusListCV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-38.0)],[NSLayoutConstraint constraintWithItem:self.statusListCV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.statusListCV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(19.0)]]];
}

- (void)loadStatusData
{
    
}

- (void) cancelStatusChange
{
    [self.statChgDelegate cancelStatusChangeSelected];
}

- (void) changeStatusOfMerchant
{
    [self.statChgDelegate changeTheMerchantStatusToPosnNo:_selectedStatusCellNo];
}

- (void)animateStatusCell:(NSInteger)p_cellPosnNo
{
    _selectedStatusCellNo = p_cellPosnNo;
    [self.statusListCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedStatusCellNo inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self.statusListCV selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedStatusCellNo inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma collection view status list related delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.statChgDelegate getNumberOfMerchantStatuses];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_statuscellid = @"status_cell";
    iMerchStatusChangeCell * l_statuscell =
    [collectionView dequeueReusableCellWithReuseIdentifier:l_statuscellid
                                              forIndexPath:indexPath];
    
    [l_statuscell showStatusText:[self.statChgDelegate getStatusNameAtPosn:indexPath.row]];
    if (indexPath.row==_selectedStatusCellNo)
        [l_statuscell startRotationAnimation];
    else
        [l_statuscell stopRotationAnimation];
    return l_statuscell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    iMerchStatusChangeCell * l_selcell = (iMerchStatusChangeCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [l_selcell startRotationAnimation];
    _selectedStatusCellNo = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    iMerchStatusChangeCell * l_unSelcell = (iMerchStatusChangeCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [l_unSelcell stopRotationAnimation];
}

@end

@interface iMerchStatusChangeCell()
{
    NSString * _displayText;
    CABasicAnimation * _revolveAnimation;
}

@property (nonatomic,strong) UILabel * lblDisplaytext;
@property (nonatomic,strong) iMerchRotatingSiriView * roundLayerView;

@end

@implementation iMerchStatusChangeCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.lblDisplaytext)
        return;
    
    self.lblDisplaytext = [iMerchDefaults getStandardLabelWithText:@""];
    self.lblDisplaytext.translatesAutoresizingMaskIntoConstraints = YES;
    //self.lblDisplaytext.font = [UIFont systemFontOfSize:11.0f];
    self.lblDisplaytext.textAlignment = NSTextAlignmentCenter;
    self.lblDisplaytext.numberOfLines = 0;
    [self.lblDisplaytext setFrame:CGRectMake(10.0, 10.0, 100.0, 100.0)];
    [self addSubview:self.lblDisplaytext];
    UIBezierPath * l_polygonpath = [UIBezierPath bezierPath];
    [l_polygonpath addArcWithCenter:CGPointMake(rect.size.width/2.0, rect.size.height/2.0) radius:(rect.size.width-20.0)/2.0 startAngle:0.0 endAngle:(2.0*M_PI) clockwise:YES];
    [l_polygonpath closePath];
    [[UIColor greenColor] setFill];
    [l_polygonpath fill];
    
    self.roundLayerView =[[iMerchRotatingSiriView alloc] initWithFrame:self.lblDisplaytext.frame];
    [self addSubview:self.roundLayerView];
    [self.roundLayerView setHidden:YES];
    [self displayValues];
    _revolveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _revolveAnimation.fromValue = @0.0f;
    _revolveAnimation.toValue = @(2.0*M_PI);
    _revolveAnimation.duration = 1.5f;
    _revolveAnimation.repeatCount = HUGE_VALF;
    
}

- (void) showStatusText:(NSString*) p_displayText
{
    _displayText = p_displayText;
    if (self.lblDisplaytext)
        [self displayValues];
}

- (void) displayValues
{
    self.lblDisplaytext.text = _displayText;
}

- (void) startRotationAnimation
{
    [self.roundLayerView setHidden:NO];
    [self.roundLayerView.layer addAnimation:_revolveAnimation forKey:@"rotation"];
}

- (void) stopRotationAnimation
{
    [self.roundLayerView.layer removeAnimationForKey:@"rotation"];
    [self.roundLayerView setHidden:YES];
}

@end


@implementation iMerchRotatingSiriView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef l_ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(l_ctx, 0.5);
    CGContextSetRGBStrokeColor(l_ctx, 1.0, 0.0, 0.0, 1);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-0.5, -M_PI_2+0.6, M_PI_4-0.6, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-1.0, -M_PI_2+0.4, M_PI_4-0.4, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-1.5, -M_PI_2+0.2, M_PI_4-0.2, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-2.0, -M_PI_2, M_PI_4, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-2.5, -M_PI_2+0.2, M_PI_4-0.2, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-3.0, -M_PI_2+0.4, M_PI_4-0.4, NO);
    CGContextStrokePath(l_ctx);
    CGContextAddArc(l_ctx, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0-3.5, -M_PI_2+0.6, M_PI_4-0.6, NO);
    CGContextStrokePath(l_ctx);
}

@end