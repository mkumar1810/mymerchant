//
//  iMerchStatusesListing.m
//  iMerchant
//
//  Created by Mohan Kumar on 29/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchStatusesListing.h"
#import "iMerchRESTProxy.h"
#import "iMerchStatusMerchants.h"

@interface iMerchStatusesListing ()
{
    NSDictionary * _viewsDictionary;
    NSMutableArray * _statusesList;
    NSInteger _selectedCellNo;
}

@property (nonatomic,strong) iMerchStatusesList * selStatusesList;

@end

@implementation iMerchStatusesListing

- (void)awakeFromNib
{
    self.transitionType = horizontalWithBounce;
    _viewsDictionary = [[NSMutableDictionary alloc] init];
    _statusesList = [NSMutableArray arrayWithArray:@[]];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.97]];
}

- (void) initializeData
{
    [self.view bringSubviewToFront:self.actView];
    [self.actView startAnimating];
    NSInteger l_userId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
    NSInteger l_isadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isadmin"] integerValue];
    NSInteger l_isbranchadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isbranchadmin"] integerValue];
    [[iMerchRESTProxy alloc]
     initProxyWithAPIType:@"GETSTATUSES"
     andInputParams:@{@"userid":@(l_userId),
                      @"isadmin":@(l_isadmin),
                      @"isbranchadmin":@(l_isbranchadmin),
                      @"businesssearch":@(0),
                      @"ownersearch":@(0),
                      @"idsearch":@(0)}
     andReturnMethod:^(NSDictionary * p_returnData)
     {
         NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
         if (l_error==0) {
             _statusesList = [NSMutableArray
                              arrayWithArray:[NSJSONSerialization
                                              JSONObjectWithData:[p_returnData valueForKey:@"returndata"]
                                              options:NSJSONReadingMutableLeaves
                                              error:NULL]];
             [_statusesList removeObjectAtIndex:([_statusesList count]-1)];
             [self.selStatusesList loadStatusListAgain];
         }
         [self.actView stopAnimating];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainViews];
    [self initializeData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupMainViews
{
    [_viewsDictionary setValue:self.navBar forKey:@"navbar"];
    [self.navBar setHidden:NO];
    self.navItem.title = @"Status List";
    self.navBar.items = @[self.navItem];
    self.navItem.leftBarButtonItems = @[self.bar_logout_btn];
    self.navItem.rightBarButtonItems = @[self.bar_refresh_btn];
    
    self.selStatusesList = [iMerchStatusesList new];
    self.selStatusesList.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:self.selStatusesList];
    self.selStatusesList.handlerDelegate = self;
    [_viewsDictionary setValue:self.selStatusesList forKey:@"statuslist"];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[statuslist]" options:0 metrics:nil views:_viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selStatusesList attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selStatusesList attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-64.0-49.0)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[navbar][statuslist]" options:0 metrics:nil views:_viewsDictionary]];
    [self.view layoutIfNeeded];
    [self.actView startAnimating];
}

- (void) popBackScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma custom navigation delegates animation

- (void)pushAnimation:(TransitionType)p_pushAnimationType
{
    //[self.selStatusesList animateCellForPush:_selectedCellNo];
}

- (void)popAnimation:(TransitionType)p_popAnimationType
{
    //[self.selStatusesList restoreCellForOriginalPosn:_selectedCellNo];
    [self initializeData];
}

#pragma status list table delegates

- (NSInteger) getNumberOfStatuses
{
    if (_statusesList)
        return [_statusesList count];
    else
        return 0;
}

/*- (NSDictionary*) getStatusDataAtPosn:(NSInteger) p_posnNo
{
    if (_statusesList)
        return [_statusesList objectAtIndex:p_posnNo];
    else
        return nil;
}*/

- (void) showDetailsForStatusAtPosn:(NSInteger) p_posnNo andOffset:(NSInteger) p_offsetNo
{
    _selectedCellNo = p_posnNo;
    self.navigateParams = @{@"prevtitle":@"Status",
                            @"statusdict":[self getStatusDictAtPosn:p_posnNo andOffset:p_offsetNo]};
    [self performSegueWithIdentifier:@"showstatusmerchants" sender:self];
}

- (NSInteger) getNumberOfStatusPairs
{
    if (_statusesList)
    {
        NSInteger l_noofparis = [_statusesList count] / 2;
        if (l_noofparis*2==[_statusesList count])
            return l_noofparis;
        else
            return l_noofparis+1;
    }
    else
        return 0;
}

- (NSDictionary*) getStatusDictAtPosn:(NSInteger) p_posnNo andOffset:(NSInteger) p_offsetNo
{
    if (_statusesList)
        return [_statusesList objectAtIndex:(p_posnNo*2+p_offsetNo)];
    else
        return nil;
}

@end
