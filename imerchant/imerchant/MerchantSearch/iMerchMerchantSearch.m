//
//  iMerchMerchantSearch.m
//  iMerchant
//
//  Created by Mohan Kumar on 17/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import "iMerchMerchantSearch.h"
#import "iMerchSearchItems.h"
#import "iMerchStandardValidations.h"
#import "iMerchStatusMerchants.h"
#import "iMerchRESTProxy.h"


@interface iMerchMerchantSearch ()<UITextFieldDelegate, UIGestureRecognizerDelegate, iMerchSearchItemsDelegate>
{
    //NSString * _prevTitle;
    NSMutableDictionary * _viewsDictionary;
    //UIBarButtonItem * _backbar_btn, * _prevtitle_bar, * _bar_search_btn;
    NSArray * _searchItemsConsts;
    NSArray * _searchTxtBoxConsts;
    UITapGestureRecognizer *_tapGesture;
    NSMutableArray * _optionsList;
}

@property (nonatomic,strong) UIScrollView * mainScroll;
@property (nonatomic,strong) iMerchSearchItems * searchItems;
@property (nonatomic,strong) UITextField * searchTextStr;

@end

@implementation iMerchMerchantSearch

- (void)awakeFromNib
{
    _viewsDictionary = [[NSMutableDictionary alloc] init];
    self.transitionType = horizontalWithBounce;
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.97]];
    [self initializeData];
}


- (void) initializeData
{
    [self.view bringSubviewToFront:self.actView];
    [self.actView startAnimating];
    NSInteger l_userId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
    NSInteger l_isadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isadmin"] integerValue];
    NSInteger l_isbranchadmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isbranchadmin"] integerValue];
    [[iMerchRESTProxy alloc]
     initProxyWithAPIType:@"GETSEARCHOPTIONS"
     andInputParams:@{@"userid":@(l_userId),
                      @"isadmin":@(l_isadmin),
                      @"isbranchadmin":@(l_isbranchadmin)}
     andReturnMethod:^(NSDictionary * p_returnData)
     {
         NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
         if (l_error==0) {
             _optionsList = [NSMutableArray
                                   arrayWithArray:[NSJSONSerialization
                                                   JSONObjectWithData:[p_returnData valueForKey:@"returndata"]
                                                   options:NSJSONReadingMutableLeaves
                                                   error:NULL]];
             [self.searchItems loadOptionsList];
         }
         [self.actView stopAnimating];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarAndDateRangeSelectorView];
    _tapGesture = [UITapGestureRecognizer new];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = self;
    [self.view addGestureRecognizer:_tapGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addNavBarAndDateRangeSelectorView
{
    
    [_viewsDictionary setValue:self.navBar forKey:@"navbar"];
    [self.navBar setHidden:NO];
    self.navItem.title = @"Merchant Search";
    self.navBar.items = @[self.navItem];
    self.navItem.leftBarButtonItems = @[self.bar_logout_btn];
    self.navItem.rightBarButtonItems = @[self.bar_search_btn];
    
    self.mainScroll = [UIScrollView new];
    self.mainScroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainScroll];
    self.mainScroll.backgroundColor = [UIColor clearColor];
    [_viewsDictionary setValue:self.mainScroll forKey:@"mainscroll"];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-64.0-49.0)],[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]]];
    //,[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:32.0]
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[navbar][mainscroll]" options:0 metrics:nil views:_viewsDictionary]];
    
    self.searchItems = [iMerchSearchItems new];
    self.searchItems.searchDelegate = self;
    self.searchItems.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScroll addSubview:self.searchItems];
    
    self.searchTextStr = [UITextField new];
    self.searchTextStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScroll addSubview:self.searchTextStr];
    self.searchTextStr.delegate = self;
    self.searchTextStr.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextStr.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.98];
    [self.searchTextStr.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:0.8].CGColor];
    [self.searchTextStr.layer setBorderWidth:0.5];
    self.searchTextStr.layer.cornerRadius = 3.0f;
    self.searchTextStr.layer.shadowColor = [UIColor grayColor].CGColor;
    self.searchTextStr.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.searchTextStr.layer.shadowRadius = 3.0f;
    self.searchTextStr.layer.shadowOpacity = 0.3;
    self.searchTextStr.clipsToBounds = NO;
    self.searchTextStr.placeholder = @"Enter Search Text";
    self.searchTextStr.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchTextStr.returnKeyType = UIReturnKeySearch;
    [_viewsDictionary setValue:self.searchTextStr forKey:@"searchtxt"];
    [self.searchTextStr addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchtxt(40)]" options:0 metrics:nil views:_viewsDictionary]];
}

- (void)updateViewConstraints
{
    if (_searchItemsConsts)
        [self.view removeConstraints:_searchItemsConsts];
    if (_searchTxtBoxConsts)
        [self.view removeConstraints:_searchTxtBoxConsts];
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        _searchItemsConsts = @[[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterY multiplier:0.6 constant:0.0]];
        _searchTxtBoxConsts = @[[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchItems attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.searchItems attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchItems attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20.0]];
    }
    else
    {
        _searchItemsConsts = @[[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeHeight multiplier:0.85 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:0.55 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchItems attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterY multiplier:0.95 constant:0.0]];
        _searchTxtBoxConsts = @[[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchItems attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.45 constant:0.0],[NSLayoutConstraint constraintWithItem:self.searchTextStr attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchItems attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    }
    [self.view addConstraints:_searchItemsConsts];
    [self.view addConstraints:_searchTxtBoxConsts];
    [self.searchItems updateConstraints];
    [super updateViewConstraints];
    //[self.mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2.0)];
}

- (void) popBackScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) performSearchOperation
{
    if (self.searchItems.bValidateAtleastOneCheck==NO)
    {
        [self showAlertMessage:@"Select a\nsearch Option!!!"];
        return;
    }
    if ([iMerchStandardValidations isTextFieldIsempty:self.searchTextStr])
    {
        [self showAlertMessage:@"Select \nText invalid!!!"];
        return;
    }
    NSMutableDictionary * l_searchoptions = [[NSMutableDictionary alloc] init];
    [l_searchoptions setValue:self.searchTextStr.text forKey:@"searchstr"];
    for (NSDictionary * l_tmpdict in _optionsList)
    {
        NSInteger l_checked = [[l_tmpdict valueForKey:@"checked"] integerValue];
        [l_searchoptions setValue:@(l_checked) forKey:[l_tmpdict valueForKey:@"paramname"]];
    }
    
    self.navigateParams = @{@"searchdict":l_searchoptions, @"prevtitle":@"Search"};
    [self performSegueWithIdentifier:@"searchedmerchants" sender:self];
}

- (void) showAlertMessage:(NSString*) p_alertMessage
{
    UIAlertView * l_showAlert = [[UIAlertView alloc] initWithTitle:@"iMerchant" message:p_alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [l_showAlert show];
}

- (void) keyboardBecomesVisible:(NSNotification*) p_visibeNotification
{
    NSDictionary * l_userInfo = [p_visibeNotification userInfo];
    CGSize l_keyboardsize = [[l_userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect l_txtFrame = [self.mainScroll convertRect:self.searchTextStr.frame toView:self.view];
    CGRect l_selfFrame = self.view.frame;
    CGFloat l_keyboardTopY = l_selfFrame.size.height - l_keyboardsize.height;
    if (l_keyboardTopY < (l_txtFrame.origin.y+l_txtFrame.size.height))
    {
        CGFloat l_reduceHeight = (l_txtFrame.origin.y+l_txtFrame.size.height) - l_keyboardTopY+10.0;
        [UIView animateWithDuration:0.15
                         animations:^(){
                             [self.mainScroll setContentOffset:CGPointMake(0, l_reduceHeight)];
                         }];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma gesture recognizer delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint l_touchPoint = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.searchTextStr.frame, l_touchPoint)==NO)
    {
        [self.searchTextStr resignFirstResponder];
    }
    return NO;
}


#pragma text field delegates are handled here

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBecomesVisible:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.mainScroll.contentOffset.y>0)
    {
        [UIView animateWithDuration:0.15
                         animations:^(){
                             [self.mainScroll setContentOffset:CGPointZero];
                         }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performSearchOperation];
    return YES;
}

#pragma merchant search items list delegates

- (NSDictionary*) getOptionDataAtPosn:(NSInteger) p_posnNo
{
    if (_optionsList)
        return [_optionsList objectAtIndex:p_posnNo];
    else
        return nil;
}

- (NSInteger) numberOfOptionsForSearch
{
    if (_optionsList)
        return [_optionsList count];
    else
        return 0;
}

- (void) updateStatusAtPosn:(NSInteger) p_posnNo checkStatus:(BOOL) p_status
{
    int l_checkvalue = p_status?1:0;
    NSMutableDictionary * l_searchchangedata =
    [NSMutableDictionary
     dictionaryWithDictionary:[_optionsList objectAtIndex:p_posnNo]];
    [l_searchchangedata setValue:@(l_checkvalue) forKey:@"checked"];
    [_optionsList replaceObjectAtIndex:p_posnNo withObject:[l_searchchangedata copy]];
}

@end
