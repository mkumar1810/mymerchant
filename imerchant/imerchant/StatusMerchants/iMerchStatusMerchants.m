//
//  iMerchStatusMerchants.m
//  iMerchant
//
//  Created by Mohan Kumar on 30/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchStatusMerchants.h"
#import "iMerchMerchantsData.h"
#import "iMerchRESTProxy.h"
#import "iMerchMerchantData.h"
#import "iMerchCommonUtilities.h"

@interface iMerchStatusMerchants ()
{
    NSMutableArray * _merchantsList;
    NSArray * _tvconstraints;
    NSDictionary * _viewsDictionary, * _schemaDict, * _statusDict, * _searchDict;
    UIImage * _popOutImage;
    NSString * _prevTitle;
    BOOL _isMerchantSearch;
    CGRect _popOutRect;
    UIImageView * _popOutTopImgVw, * _popOutBottomImgVw;
    NSInteger _paginationRecs, _totalRecs, _selectedCellNo;
}
@property (nonatomic,strong) iMerchMerchantsData * merchantsListTV;

@end

@implementation iMerchStatusMerchants

- (void)awakeFromNib
{
    self.transitionType = horizontalWithoutBounce;
    _viewsDictionary = [[NSMutableDictionary alloc] init];
    _merchantsList = [[NSMutableArray alloc] init];
    _popOutRect = CGRectZero;
    _paginationRecs = PAGINATION_RECS;
    _totalRecs = 0;
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.97]];
}

- (void)initializeDataWithParams:(NSDictionary *)p_initParams
{
    _prevTitle = [p_initParams valueForKey:@"prevtitle"];
    _statusDict = [p_initParams valueForKey:@"statusdict"];
    _searchDict = [p_initParams valueForKey:@"searchdict"];
    self.lbl_prevtitle.text = _prevTitle;
    [self.navBar setHidden:NO];
    if (_searchDict)
    {
        _isMerchantSearch = YES;
    }
    if (!_isMerchantSearch)
        self.navItem.title = [[_statusDict valueForKey:@"status"] capitalizedString];
    else
        self.navItem.title = @"Merchants";
    self.navBar.items = @[self.navItem];
    self.navItem.leftBarButtonItems = @[self.bar_back_btn, self.bar_prev_title_btn];
    self.navItem.rightBarButtonItem = self.bar_refresh_btn;
    [self initializeDataWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeData
{
    _totalRecs = 0;
    _schemaDict = nil;
    if (_merchantsList)
        [_merchantsList removeAllObjects];
    else
        _merchantsList = [[NSMutableArray alloc] init];
    [self initializeDataWithAnimation:YES];
}

- (void) initializeDataWithAnimation:(BOOL) p_animate
{
    if (p_animate)
    {
        [self.view bringSubviewToFront:self.actView];
        [self.actView startAnimating];
    }
    DICTIONARYCALLBACK l_returnHandler = ^(NSDictionary * p_returnData)
    {
        NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
        if (l_error==0)
        {
            NSDictionary * l_receiveddata = (NSDictionary*) [NSJSONSerialization
                                              JSONObjectWithData:[p_returnData valueForKey:@"returndata"]
                                              options:NSJSONReadingMutableLeaves
                                              error:NULL];
            l_error = [[l_receiveddata valueForKey:@"error"] integerValue];
            if (l_error==0)
            {
                [_merchantsList addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:[[l_receiveddata valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:NULL]];
                if ([l_receiveddata valueForKey:@"schema"])
                {
                    _schemaDict = (NSDictionary*) [NSJSONSerialization
                                                   JSONObjectWithData:[[l_receiveddata valueForKey:@"schema"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves
                                                   error:NULL];
                    _totalRecs = [[l_receiveddata valueForKey:@"noofrecs"] integerValue];
                }
                [self.merchantsListTV loadStatusListAgain];
            }
        }
        [self.actView stopAnimating];
    };
    NSString * l_sessionid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionid"];
    NSInteger l_userid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
    NSInteger l_isadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isadmin"] integerValue];
    NSInteger l_isbranchadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isbranchadmin"] integerValue];
    if (!_isMerchantSearch)
    {
        [[iMerchRESTProxy alloc]
         initProxyWithAPIType:@"GETBUSINESSESPAGINATED"
         andInputParams:@{@"userid":@(l_userid),
                          @"status":[_statusDict valueForKey:@"status"],
                          @"isadmin":@(l_isadmin),
                          @"isbranchadmin":@(l_isbranchadmin),
                          @"paginationrecs":@(_paginationRecs),
                          @"sessionid":l_sessionid,
                          @"prevrecs":@([_merchantsList count])}
         andReturnMethod:l_returnHandler];
    }
    else
    {
        NSMutableDictionary * l_inputDict = [[NSMutableDictionary alloc] init];
        [l_inputDict addEntriesFromDictionary:_searchDict];
        [l_inputDict addEntriesFromDictionary:@{@"userid":@(l_userid),
                                                @"isadmin":@(l_isadmin),
                                                @"isbranchadmin":@(l_isbranchadmin),
                                                @"paginationrecs":@(_paginationRecs),
                                                @"sessionid":l_sessionid,
                                                @"prevrecs":@([_merchantsList count])}];
        [[iMerchRESTProxy alloc]
         initProxyWithAPIType:@"GETMERCHANTSEARCHPAGINATED"
         andInputParams:l_inputDict
         andReturnMethod:l_returnHandler];
    }
}

- (void) setupMainViews
{
    [_viewsDictionary setValue:self.navBar forKey:@"navbar"];
    [self.navBar setHidden:NO];
    self.merchantsListTV = [iMerchMerchantsData new];
    self.merchantsListTV.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:self.merchantsListTV];
    self.merchantsListTV.handlerDelegate = self;
    [_viewsDictionary setValue:self.merchantsListTV forKey:@"merchantslist"];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[merchantslist]" options:0 metrics:nil views:_viewsDictionary]];
    _tvconstraints = @[[NSLayoutConstraint constraintWithItem:self.merchantsListTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0],[NSLayoutConstraint constraintWithItem:self.merchantsListTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-64.0-49.0)]];
    [self.view addConstraints:_tvconstraints];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[navbar][merchantslist]" options:0 metrics:nil views:_viewsDictionary]];
    [self.view layoutIfNeeded];
    [self.actView startAnimating];
}

- (void) popBackScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma navigation controller animation related delegates

- (void)pushAnimation:(TransitionType)p_pushAnimationType
{
    if (_popOutTopImgVw)
    {
        _popOutTopImgVw.transform = CGAffineTransformMakeTranslation(0, (-_popOutTopImgVw.frame.size.height));
        _popOutBottomImgVw.transform = CGAffineTransformMakeTranslation(0, (_popOutBottomImgVw.frame.size.height));
    }
}

- (void)popAnimation:(TransitionType)p_popAnimationType
{
    if (_popOutTopImgVw)
    {
        _popOutTopImgVw.transform = CGAffineTransformIdentity;
        _popOutBottomImgVw.transform = CGAffineTransformIdentity;
    }
    if (_isMerchantSearch)
    {
        //getmerchantinfoafterupdate
        [self.view bringSubviewToFront:self.actView];
        [self.actView startAnimating];
        NSString * l_sessionid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionid"];
        NSDictionary * l_merchantrawdict = [_merchantsList objectAtIndex:_selectedCellNo];
        NSNumber * l_leadid = [l_merchantrawdict valueForKey:[_schemaDict valueForKey:@"Lead Id"]];
        [[iMerchRESTProxy alloc]
         initProxyWithAPIType:@"GETMERCHANTINFOAFTERUPDATE"
         andInputParams:@{@"leadid":l_leadid,
                          @"sessionid":l_sessionid}
         andReturnMethod:^(NSDictionary * p_returnData)
         {
             NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
             if (l_error==0)
             {
                 NSDictionary * l_receiveddata = (NSDictionary*) [NSJSONSerialization
                                                                  JSONObjectWithData:[p_returnData valueForKey:@"returndata"]
                                                                  options:NSJSONReadingMutableLeaves
                                                                  error:NULL];
                 l_error = [[l_receiveddata valueForKey:@"error"] integerValue];
                 if (l_error==0)
                 {
                     NSDictionary * l_newDict = (NSDictionary*) [NSJSONSerialization JSONObjectWithData:[[l_receiveddata valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:NULL];
                     [_merchantsList replaceObjectAtIndex:_selectedCellNo withObject:l_newDict];
                     _selectedCellNo = -1;
                 }
             }
             [self.actView stopAnimating];
         }];
    }
}

- (void)popAnimationCompleted
{
    if (_popOutTopImgVw)
    {
        _popOutImage = nil;
        [_popOutTopImgVw removeFromSuperview];
        [_popOutBottomImgVw removeFromSuperview];
        _popOutTopImgVw = nil;
        _popOutBottomImgVw = nil;
    }
    [super popAnimationCompleted];
}

- (CGRect) getPopOutFrame
{
    return _popOutRect;
}

- (UIImage*) getPopOutTopImage
{
    return nil;
}

- (UIImage*) getPopOutBottomImage
{
    return nil;
}

- (UIImage*) getPopOutImage
{
    return _popOutImage;
}

#pragma merchants list related delegates

- (NSDictionary*) getSchemaDictionary
{
    return _schemaDict;
}

- (NSInteger)getTotalNumberOfMerchants
{
    return _totalRecs;
}

- (NSInteger) getCurrentNumberOfMerchantRowsForTV
{
    if (_merchantsList)
    {
        if (_totalRecs==[_merchantsList count])
            return [_merchantsList count];
        else
            return [_merchantsList count]+1;
    }
    else
        return 0;
}

- (NSDictionary*) getMerchantDataAtPosn:(NSInteger) p_posnNo
{
    if (_merchantsList)
        return [_merchantsList objectAtIndex:p_posnNo];
    else
        return nil;
}

- (void) showDetailsForMerchantAtPosn:(NSInteger) p_posnNo fromFrame:(CGRect) p_fromFrame andCellImage:(UIImage*) p_cellImage
{
    _selectedCellNo = p_posnNo;
    _popOutRect = [self.merchantsListTV convertRect:p_fromFrame toView:self.view];
    _popOutImage = p_cellImage;
    NSDictionary * l_merchantrawdict = [_merchantsList objectAtIndex:p_posnNo];
    NSMutableDictionary * l_merchantInfoForDrillDown = [[NSMutableDictionary alloc] init];
    for (NSString * l_keyname in [_schemaDict allKeys])
    {
        [l_merchantInfoForDrillDown setValue:[l_merchantrawdict valueForKey:[_schemaDict valueForKey:l_keyname]] forKey:l_keyname];
    }
    _popOutTopImgVw = [[UIImageView alloc] initWithImage:[iMerchCommonUtilities captureView:self.view ofFrame:CGRectMake(0, 0, self.view.frame.size.width, _popOutRect.origin.y)]];
    _popOutTopImgVw.translatesAutoresizingMaskIntoConstraints = NO;
    _popOutBottomImgVw = [[UIImageView alloc] initWithImage:[iMerchCommonUtilities captureView:self.view ofFrame:CGRectMake(0, _popOutRect.origin.y+_popOutRect.size.height, self.view.frame.size.width, self.view.frame.size.height - (_popOutRect.origin.y+_popOutRect.size.height))]];
    _popOutBottomImgVw.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_popOutTopImgVw];
    [self.view addSubview:_popOutBottomImgVw];
    [_popOutTopImgVw addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[topimg(w)]" options:0 metrics:@{@"w":@(self.view.frame.size.width)} views:@{@"topimg":_popOutTopImgVw}]];
    [_popOutBottomImgVw addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[botimg(w)]" options:0 metrics:@{@"w":@(self.view.frame.size.width)} views:@{@"botimg":_popOutBottomImgVw}]];
    [_popOutTopImgVw addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topimg(h)]" options:0 metrics:@{@"h":@(_popOutRect.origin.y)} views:@{@"topimg":_popOutTopImgVw}]];
    [_popOutBottomImgVw addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[botimg(h)]" options:0 metrics:@{@"h":@(self.view.frame.size.height-(_popOutRect.origin.y+_popOutRect.size.height))} views:@{@"botimg":_popOutBottomImgVw}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topimg]" options:0 metrics:nil views:@{@"topimg":_popOutTopImgVw}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[botimg]" options:0 metrics:nil views:@{@"botimg":_popOutBottomImgVw}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_popOutTopImgVw attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:(-20.0f)]]; // _bottomImgYConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_popOutBottomImgVw attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.merchantsListTV attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view layoutIfNeeded];
    /*iMerchMerchantData * l_merchantdata =
    [[iMerchMerchantData alloc]
     initWithPrevTitle:self.navItem.title
     merchantData:l_merchantInfoForDrillDown
     showStatus:_isMerchantSearch];*/
    
    self.navigateParams = @{@"prevtitle":self.navItem.title,@"merchantdict":l_merchantInfoForDrillDown,@"search":@(_isMerchantSearch)};
    if (_isMerchantSearch)
        [self performSegueWithIdentifier:@"showsearchmerchantdata" sender:self];
    else
        [self performSegueWithIdentifier:@"showstatusmerchantdata" sender:self];
}

- (void)paginateToNextMerchantsList
{
    [self initializeDataWithAnimation:NO];
}

@end
