//
//  iMerchMerchantData.m
//  iMerchant
//
//  Created by Mohan Kumar on 03/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchMerchantData.h"
#import "iMerchMerchantDataView.h"
#import "iMerchRESTProxy.h"
#import "iMerchCommonUtilities.h"
#import "iMerchNotesZoomedView.h"
#import "iMerchMerchantOptions.h"
#import "iMerchStandardValidations.h"
#import "iMerchStatusChange.h"

@interface iMerchMerchantData () <iMerchMerchantDataViewDelegate,iMerchAddNotesDelegate, UIGestureRecognizerDelegate, iMerchSendEMailViewDelegate, iMerchNotesZoomedViewDelegate, iMerchMerchantOptionsDelegate, iMerchStatusChangeDelegate>
{
    NSDictionary * _viewsDictionary;
    NSMutableArray * _merchantNotesList;
    NSDictionary * _merchantData;
    NSArray * _merchantStatusesList;
    NSString * _prevTitle;
    UITapGestureRecognizer * _tapGesture;
    BOOL _searchMerchant;
    NSString * _merchCurrStatus;
}

@property (nonatomic,strong) iMerchMerchantDataView * merchantDataTV;
@property (nonatomic,strong) iMerchAddNotesView * addNotesView;
@property (nonatomic,strong) iMerchSendEmailView * sendEMailView;
@property (nonatomic,strong) iMerchNotesZoomedView * zoomedNotesView;
@property (nonatomic,strong) UIVisualEffectView * bgBlurView;
@property (nonatomic,strong) iMerchMerchantOptions * merchantOptionsDisp;
@property (nonatomic,strong) iMerchStatusChange * merchantStatChgDisp;

@end

@implementation iMerchMerchantData

- (void)awakeFromNib
{
    self.transitionType = popOutVerticalOpen;
    _viewsDictionary = [[NSMutableDictionary alloc] init];
    _merchantNotesList = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.97]];
}

- (void)initializeDataWithParams:(NSDictionary *)p_initParams
{
    _prevTitle = [p_initParams valueForKey:@"prevtitle"];
    _merchantData = [p_initParams valueForKey:@"merchantdict"];
    _searchMerchant = [[p_initParams valueForKey:@"search"] boolValue];
    self.lbl_prevtitle.text = _prevTitle;
    [self.navBar setHidden:NO];
    
    if (_searchMerchant)
    {
        self.navItem.title = [[_merchantData valueForKey:@"status"] capitalizedString];
        _merchCurrStatus = [[_merchantData valueForKey:@"status"]  copy];
    }
    else
    {
        self.navItem.title = @"Merchant";
        _merchCurrStatus = _prevTitle;
    }
    [self initializeData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMainViews];
    _tapGesture = [[UITapGestureRecognizer alloc] init];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = self;
    [self.view addGestureRecognizer:_tapGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeData
{
    [self.view bringSubviewToFront:self.actView];
    [self.actView startAnimating];
    NSInteger l_userid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
    
    [[iMerchRESTProxy alloc]
     initProxyWithAPIType:@"GETNOTES"
     andInputParams:@{@"leadid":[[_merchantData valueForKey:@"Lead Id"] copy]}
     andReturnMethod:^(NSDictionary * p_returnData)
     {
         NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
         if (l_error==0) {
             _merchantNotesList = [NSMutableArray
                               arrayWithArray:[NSJSONSerialization
                                               JSONObjectWithData:[p_returnData valueForKey:@"returndata"]
                                               options:NSJSONReadingMutableLeaves
                                               error:NULL]];
             [self.merchantDataTV loadNotesData];
         }
         [self.actView stopAnimating];
     }];
    [[iMerchRESTProxy alloc]
     initProxyWithAPIType:@"GETALLOWEDSTATUSES"
     andInputParams:@{@"userid":@(l_userid)}
     andReturnMethod:^(NSDictionary * p_returnData)
     {
         NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
         if (l_error==0)
         {
             _merchantStatusesList =
             (NSArray*) [NSJSONSerialization
                              JSONObjectWithData:
                              [p_returnData valueForKey:@"returndata"]
                              options:NSJSONReadingMutableLeaves
                              error:NULL];
         }
         else
             _merchantStatusesList = @[];
         
     }];
}


- (void) setupMainViews
{
    [_viewsDictionary setValue:self.navBar forKey:@"navbar"];
    
    self.navBar.items = @[self.navItem];
    self.navItem.leftBarButtonItems = @[self.bar_back_btn, self.bar_prev_title_btn];
    self.navItem.rightBarButtonItem = self.bar_list_btn;
    
    self.merchantDataTV = [iMerchMerchantDataView new];
    self.merchantDataTV.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:self.merchantDataTV];
    self.merchantDataTV.handlerDelegate = self;
    [_viewsDictionary setValue:self.merchantDataTV forKey:@"merchantslist"];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[merchantslist]" options:0 metrics:nil views:_viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.merchantDataTV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.merchantDataTV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-64.0-49.0)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[navbar][merchantslist]" options:0 metrics:nil views:_viewsDictionary]];
    [self.view layoutIfNeeded];
    [self.actView startAnimating];
}

- (void)executeListButtonClicked
{
    UIView * l_barprintvw = [self.bar_list_btn valueForKey:@"view"];
    CGRect l_pointrect = [l_barprintvw convertRect:l_barprintvw.bounds toView:self.view];
    CGPoint l_stPoint = CGPointMake(l_pointrect.origin.x-210.0, l_pointrect.origin.y+l_pointrect.size.height);
    _merchantOptionsDisp = [[iMerchMerchantOptions alloc] initWithFrame:CGRectZero andSuperPoint:CGPointZero dataDelegate:self];
    _merchantOptionsDisp.translatesAutoresizingMaskIntoConstraints = NO;
    //_rptselector.startingFrame = l_pointrect;
    [self.view addSubview:_merchantOptionsDisp];
    _merchantOptionsDisp.alpha =0.05;
    CGFloat l_shrink_x = l_pointrect.size.width / 210.0f;
    CGFloat l_shrink_y = l_pointrect.size.height / 140.0f;
    [_merchantOptionsDisp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[popup(210)]" options:0 metrics:nil views:@{@"popup":_merchantOptionsDisp}]];
    [_merchantOptionsDisp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[popup(140)]" options:0 metrics:nil views:@{@"popup":_merchantOptionsDisp}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xval-[popup]" options:0 metrics:@{@"xval":@(l_stPoint.x)} views:@{@"popup":_merchantOptionsDisp}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-yval-[popup]" options:0 metrics:@{@"yval":@(l_stPoint.y)} views:@{@"popup":_merchantOptionsDisp}]];
    [self.view layoutIfNeeded];
    CGAffineTransform l_totransform = CGAffineTransformConcat(CGAffineTransformMakeScale(l_shrink_x, l_shrink_y),CGAffineTransformMakeTranslation((+210.0/2.0), (-140.0/2.0)));
    _merchantOptionsDisp.transform =l_totransform; // CGAffineTransformMakeScale(l_shrink_x, l_shrink_y);
    _merchantOptionsDisp.alpha = 0.5;
    _merchantOptionsDisp.originalTransform = l_totransform;
    [UIView animateWithDuration:0.3
                     animations:^(){
                         _merchantOptionsDisp.transform = CGAffineTransformIdentity;
                         _merchantOptionsDisp.alpha = 1.0;
                     } completion:^(BOOL p_finished){
                         [self.navBar setUserInteractionEnabled:NO];
                     }];
}

- (void) addNewNotesFromFrame:(CGRect) p_newFrame
{
    self.addNotesView = [iMerchAddNotesView new];
    self.addNotesView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.addNotesView];
    self.addNotesView.notesDelegate = self;
    self.addNotesView.alpha = 0;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.addNotesView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.80 constant:0],[NSLayoutConstraint constraintWithItem:self.addNotesView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.60 constant:0],[NSLayoutConstraint constraintWithItem:self.addNotesView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:self.addNotesView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
    [self.view layoutIfNeeded];
    CGFloat l_shrink_x = p_newFrame.size.width /self.addNotesView.frame.size.width;
    CGFloat l_shrink_y = p_newFrame.size.height / self.addNotesView.frame.size.height;
    CGPoint l_startOffset = CGPointMake(p_newFrame.origin.x+p_newFrame.size.width/2.0-self.view.center.x, p_newFrame.origin.y+p_newFrame.size.height/2.0-self.view.center.y);
    CGAffineTransform l_startTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(l_shrink_x, l_shrink_y),CGAffineTransformMakeTranslation(l_startOffset.x, l_startOffset.y));
    self.addNotesView.transform = l_startTransform;
    self.addNotesView.transformStart = l_startTransform;
    self.addNotesView.alpha = 0.3;
    UIBlurEffect * l_blreffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _bgBlurView = [[UIVisualEffectView alloc] initWithEffect:l_blreffect];
    _bgBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bgBlurView];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:(1.0) constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
    [self.view layoutIfNeeded];
    [self.view bringSubviewToFront:self.addNotesView];
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.addNotesView.transform = CGAffineTransformIdentity;
                         self.addNotesView.alpha = 1.0;
                         _bgBlurView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL p_finished){
                         _bgBlurView.alpha = 0.95;
                         [self.navBar setUserInteractionEnabled:NO];
                     }];
}

- (void) popBackScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showAlertMessage:(NSString*) p_alertMessage
{
    UIAlertView * l_showAlert = [[UIAlertView alloc] initWithTitle:@"iMerchant" message:p_alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [l_showAlert show];
}

- (void) cancelZoomedNotesView
{
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.zoomedNotesView.transform = self.zoomedNotesView.transformStart;
                         self.zoomedNotesView.alpha = 0.0;
                     }
                     completion:^(BOOL p_finished){
                         [self.merchantDataTV stopWobblingAtDatePosn:self.zoomedNotesView.datePosnNo andDisplayPosn:self.zoomedNotesView.notesItemNo];
                         [self.zoomedNotesView removeFromSuperview];
                         self.zoomedNotesView = nil;
                     }];
}

- (void) unloadOptionsListSelector:(NOPARAMCALLBACK) p_afterUnloadExecuteCB
{
    if (self.merchantOptionsDisp.tag==1) return;
    self.merchantOptionsDisp.tag = 1;
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.merchantOptionsDisp.transform = self.merchantOptionsDisp.originalTransform;
                         self.merchantOptionsDisp.alpha = 0.1;
                     } completion:^(BOOL p_finished){
                         p_afterUnloadExecuteCB();
                         self.merchantOptionsDisp.tag = 0;
                         [self.view layoutIfNeeded];
                         [self.navBar setUserInteractionEnabled:YES];
                         [self.merchantOptionsDisp removeFromSuperview];
                         self.merchantOptionsDisp = nil;
                     }];
}

- (void) hideTheStatusChangeScreenWithCB:(NOPARAMCALLBACK) p_afterHideCB
{
    if (self.merchantStatChgDisp.tag==1) return;
    self.merchantStatChgDisp.tag = 1;
    CGAffineTransform l_hideTransform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2),CGAffineTransformMakeTranslation(self.view.frame.size.width, 0));
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.merchantStatChgDisp.transform = l_hideTransform;
                         _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
                         self.merchantStatChgDisp.alpha = 0.1;
                         
                     } completion:^(BOOL p_finished){
                         self.merchantStatChgDisp.tag = 0;
                         [self.navBar setUserInteractionEnabled:YES];
                         [_bgBlurView removeFromSuperview];
                         [self.merchantStatChgDisp removeFromSuperview];
                         self.merchantStatChgDisp = nil;
                         _bgBlurView = nil;
                         p_afterHideCB();
                     }];
}

#pragma gesture recognizer delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!self.addNotesView & !self.sendEMailView & !self.zoomedNotesView & !self.merchantOptionsDisp & !self.merchantStatChgDisp)
        return NO;
    CGPoint l_touchPoint = [touch locationInView:self.view];
    if (self.addNotesView)
    {
        if (CGRectContainsPoint(self.addNotesView.frame, l_touchPoint)==NO)
        {
            [self.addNotesView resignFirstResponder];
        }
    }
    if (self.sendEMailView)
    {
        if (CGRectContainsPoint(self.sendEMailView.frame, l_touchPoint)==NO)
        {
            [self.sendEMailView resignFirstResponder];
        }
    }
    if (self.zoomedNotesView)
    {
        if (CGRectContainsPoint(self.zoomedNotesView.frame, l_touchPoint)==NO)
        {
            [self cancelZoomedNotesView];
        }
    }
    if (self.merchantOptionsDisp)
    {
        if (CGRectContainsPoint(self.merchantOptionsDisp.frame, l_touchPoint)==NO)
        {
            [self unloadOptionsListSelector:^{}];
        }
    }
    if (self.merchantStatChgDisp)
    {
        if (CGRectContainsPoint(self.merchantStatChgDisp.frame, l_touchPoint)==NO)
        {
            [self hideTheStatusChangeScreenWithCB:^{}];
        }
    }
    return NO;
}

#pragma merchant individual details display delegates

- (NSString*) getMerchDataBusinessName
{
    return [_merchantData valueForKey:@"Business Name"];
}

- (NSString*) getMerchdataBusinessOwnerName
{
    return [_merchantData valueForKey:@"Owner Name"];
}

- (NSString*) getMerchDataBusinessPhone
{
    return [_merchantData valueForKey:@"Business Phone"];
}

- (NSString*) getMerchDataCellPhoneNo
{
    return [_merchantData valueForKey:@"Cell Phone"];
}

- (NSString*) getMerchDataeMailAddress
{
    return [_merchantData valueForKey:@"Email Address"];
}

- (NSInteger) getNumberOfNotesDaysForThisLead
{
    if (_merchantNotesList)
        return [_merchantNotesList count];
    else
        return 0;
}

- (NSString*) getMerchantNotesDateAtPosn:(NSInteger) p_posnNo
{
    NSString * l_retstring = [[[_merchantNotesList objectAtIndex:p_posnNo] valueForKey:@"fordate"] stringValue];
    return l_retstring;
}

- (NSInteger) getNumberOfNotesAtPosn:(NSInteger) p_posnNo
{
    return [[[_merchantNotesList objectAtIndex:p_posnNo] valueForKey:@"notes"] count];
}

- (NSDictionary*) getMerchantNotesDataAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn
{
    NSDictionary * l_retDict = [[[_merchantNotesList objectAtIndex:p_datePosn] valueForKey:@"notes"] objectAtIndex:p_displayPosn];
    return l_retDict;
}

- (BOOL) showNotesOnExpandedMode:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn fromFrame:(CGRect) p_fromFrame onView:(id)p_onView
{
    if (self.zoomedNotesView)
    {
        return NO;
    }
    CGRect l_fromframe = [(UIView*) p_onView convertRect:p_fromFrame toView:self.view];
    CGPoint l_fromFrameCenter = CGPointMake(l_fromframe.origin.x+l_fromframe.size.width/2.0, l_fromframe.origin.y+l_fromframe.size.height/2.0);
    self.zoomedNotesView = [iMerchNotesZoomedView new];
    [self.zoomedNotesView setDatePosn:p_datePosn andDisplayPosn:p_displayPosn andDataDelegate:self];
    self.zoomedNotesView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.zoomedNotesView];
    self.zoomedNotesView.zoomDelegate = self;
    self.zoomedNotesView.alpha = 0.0;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.zoomedNotesView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0.0],[NSLayoutConstraint constraintWithItem:self.zoomedNotesView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.6 constant:0.0],[NSLayoutConstraint constraintWithItem:self.zoomedNotesView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.zoomedNotesView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    [self.view layoutIfNeeded];
    CGFloat l_shrink_x = l_fromframe.size.width / self.zoomedNotesView.frame.size.width;
    CGFloat l_shrink_y = l_fromframe.size.height / self.zoomedNotesView.frame.size.height;
    CGFloat l_movecenter_x = l_fromFrameCenter.x - self.view.center.x;
    CGFloat l_movecenter_y = l_fromFrameCenter.y - self.view.center.y;
    CGAffineTransform l_reqdTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(l_shrink_x, l_shrink_y), CGAffineTransformMakeTranslation(l_movecenter_x, l_movecenter_y));
    self.zoomedNotesView.transform = l_reqdTransform ;
    self.zoomedNotesView.alpha = 0.3;
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.zoomedNotesView.alpha = 0.95;
                         self.zoomedNotesView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL p_finished){
                         _zoomedNotesView.transformStart = l_reqdTransform;
                     }];
    return YES;
}

- (void) sendEMailToLeadFromFrame:(CGRect)p_fromRect ofView:(id)p_onView
{
    CGRect l_fromViewRect = [(UIView*) p_onView convertRect:p_fromRect toView:self.view];
    self.sendEMailView = [iMerchSendEmailView new];
    self.sendEMailView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.sendEMailView];
    self.sendEMailView.emailDelegate = self;
    self.sendEMailView.alpha = 0;
    NSArray * l_toemailviewconsts = @[[NSLayoutConstraint constraintWithItem:self.sendEMailView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0.0f],[NSLayoutConstraint constraintWithItem:self.sendEMailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.6 constant:0.0f],[NSLayoutConstraint constraintWithItem:self.sendEMailView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.sendEMailView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraints:l_toemailviewconsts];
    [self.view layoutIfNeeded];
    CGFloat l_shrink_x = l_fromViewRect.size.width / self.sendEMailView.frame.size.width;
    CGFloat l_shrink_y = l_fromViewRect.size.height / self.sendEMailView.frame.size.height;
    CGAffineTransform l_starttransform = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeScale(l_shrink_x, l_shrink_y), CGAffineTransformMakeRotation(M_PI-0.1)),CGAffineTransformMakeTranslation(l_fromViewRect.origin.x+l_fromViewRect.size.width/2.0-self.view.center.x, l_fromViewRect.origin.y+l_fromViewRect.size.height/2.0-self.view.center.y));
    self.sendEMailView.transform = l_starttransform;
    self.sendEMailView.transformStart = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeScale(l_shrink_x, l_shrink_y), CGAffineTransformMakeRotation(0.1-M_PI)),CGAffineTransformMakeTranslation(l_fromViewRect.origin.x+l_fromViewRect.size.width/2.0-self.view.center.x, l_fromViewRect.origin.y+l_fromViewRect.size.height/2.0-self.view.center.y));
    self.sendEMailView.alpha = 0.3;
    //toolbar related
    UIBlurEffect * l_blreffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _bgBlurView = [[UIVisualEffectView alloc] initWithEffect:l_blreffect];
    _bgBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bgBlurView];
    NSArray * l_tbarfromconstraints = @[[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:(1.0) constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, self.view.frame.size.height);
    [self.view addConstraints:l_tbarfromconstraints];
    [self.view layoutIfNeeded];
    [self.view bringSubviewToFront:self.sendEMailView];
    _bgBlurView.alpha = 0.9;
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.sendEMailView.transform = CGAffineTransformIdentity;
                         self.sendEMailView.alpha = 1.0;
                         _bgBlurView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL p_finished){
                         [self.navBar setUserInteractionEnabled:NO];
                     }];
}

- (void) makePhoneCallUsingNo:(NSString*) p_phoneNo
{
    NSString *l_phoneNumber = [@"tel://"  stringByAppendingString:p_phoneNo];
    UIWebView *l_callWebview = [UIWebView new];
    [self.view addSubview:l_callWebview];
    [l_callWebview setHidden:YES];
    NSURL *telURL = [NSURL URLWithString:l_phoneNumber];
    [l_callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
}

#pragma imerchant add notes delegate

- (void) addNotesCancelled
{
    [UIView animateWithDuration:0.4
                     animations:^(){
                         _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
                         self.addNotesView.transform = self.addNotesView.transformStart;
                         self.addNotesView.alpha = 0.3;
                     }
                     completion:^(BOOL p_finished){
                         [self.navBar setUserInteractionEnabled:YES];
                         [self.addNotesView removeFromSuperview];
                         [_bgBlurView removeFromSuperview];
                         self.addNotesView = nil;
                         _bgBlurView = nil;
                     }];
}

- (void) addNotesMessage:(NSString*) p_notesMessage
{
    NSArray * l_validationResult = self.addNotesView.bValidateNotesdata;
    if ([[l_validationResult objectAtIndex:0] boolValue])
    {
        [self.view bringSubviewToFront:self.actView];
        [self.actView startAnimating];
        NSInteger l_userid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
        [[iMerchRESTProxy alloc]
         initProxyWithAPIType:@"ADDNOTES"
         andInputParams:@{@"leadid":[[_merchantData valueForKey:@"Lead Id"] copy],
                          @"userid":@(l_userid),
                          @"message":p_notesMessage}
         andReturnMethod:^(NSArray * p_resultData)
         {
             [self.addNotesView resignFirstResponder];
             NSInteger l_error = [[p_resultData valueForKey:@"error"] integerValue];
             if (l_error==0) {
                 NSArray *l_recdNotesData = (NSArray*) [NSJSONSerialization
                                                        JSONObjectWithData:[p_resultData valueForKey:@"returndata"]
                                                        options:NSJSONReadingMutableLeaves
                                                        error:NULL];
                 NSInteger l_dberror = [[[l_recdNotesData objectAtIndex:0] valueForKey:@"error"] integerValue];
                 if (l_dberror==0)
                 {
                     NSInteger l_dateval = [[[l_recdNotesData objectAtIndex:0] valueForKey:@"fordate"] integerValue];
                     if ([_merchantNotesList count]> 0)
                     {
                         NSMutableDictionary * l_firstdatedata =[NSMutableDictionary dictionaryWithDictionary:[_merchantNotesList objectAtIndex:0]];
                         if ([[l_firstdatedata valueForKey:@"fordate"] integerValue]==l_dateval)
                         {
                             NSMutableArray * l_datenotesdata = [NSMutableArray arrayWithArray: [l_firstdatedata valueForKey:@"notes"]];
                             [l_datenotesdata insertObject:[l_recdNotesData objectAtIndex:0] atIndex:0];
                             [l_firstdatedata setValue:l_datenotesdata forKey:@"notes"];
                             [_merchantNotesList replaceObjectAtIndex:0 withObject:l_firstdatedata];
                         }
                         else
                             [_merchantNotesList insertObject:@{@"fordate":@(l_dateval),@"notes":@[[l_recdNotesData objectAtIndex:0]]} atIndex:0];
                     }
                     else
                         [_merchantNotesList addObject:@{@"fordate":@(l_dateval),@"notes":@[[l_recdNotesData objectAtIndex:0]]}];
                     [self.merchantDataTV loadNotesData];
                 }
                 else
                     [self showAlertMessage:@"Add Notes Failed"];
             }
             else
                 [self showAlertMessage:@"Add Notes Failed"];
             [self.actView stopAnimating];
             [self addNotesCancelled];
         }];
    }
    else
    {
        [self showAlertMessage:[l_validationResult objectAtIndex:1]];
    }
}

#pragma merchant mail sending delegates

- (void) cancelEMailSending
{
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.sendEMailView.transform = self.sendEMailView.transformStart;
                         _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, self.view.frame.size.height);
                         self.sendEMailView.alpha = 0.3;
                     }
                     completion:^(BOOL p_finished){
                         [self.navBar setUserInteractionEnabled:YES];
                         [self.sendEMailView removeFromSuperview];
                         [_bgBlurView removeFromSuperview];
                         self.sendEMailView = nil;
                         _bgBlurView = nil;
                     }];
}

- (void) sendEMailWithSubj:(NSString*) p_mailSubj andBody:(NSString*) p_mailBody
{
    NSArray * l_validationResult = self.sendEMailView.bValidateEMailData;
    if ([[l_validationResult objectAtIndex:0] boolValue])
    {
        [self.view bringSubviewToFront:self.actView];
        [self.actView startAnimating];
        NSInteger l_userid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue];
        [[iMerchRESTProxy alloc]
         initProxyWithAPIType:@"SENDEMAIL"
         andInputParams:@{@"leadid":[[_merchantData valueForKey:@"Lead Id"] copy],
                          @"userid":@(l_userid),
                          @"message":p_mailBody,
                          @"subject":p_mailSubj}
         andReturnMethod:^(NSArray * p_resultData)
         {
             [self.sendEMailView resignFirstResponder];
             NSInteger l_error = [[p_resultData valueForKey:@"error"] integerValue];
             if (l_error==0) {
                 NSDictionary *l_recdMailReturn = (NSDictionary*) [NSJSONSerialization
                        JSONObjectWithData:[p_resultData valueForKey:@"returndata"]
                        options:NSJSONReadingMutableLeaves
                        error:NULL];
                 NSInteger l_dberror = [[l_recdMailReturn valueForKey:@"error"] integerValue];
                 if (l_dberror!=0)
                     [self showAlertMessage:@"Mail send Failed"];
             }
             else
                 [self showAlertMessage:@"Mail send Failed"];
             [self.actView stopAnimating];
             [self cancelEMailSending];
         }];
    }
    else
    {
        [self showAlertMessage:[l_validationResult objectAtIndex:1]];
    }
}

#pragma imerchant zoomed view delegates

- (NSDictionary*) getMerchantDataForZoomAtDatePosn:(NSInteger) p_datePosn andDisplayPosn:(NSInteger) p_displayPosn
{
    NSDictionary * l_retDict = [[[_merchantNotesList objectAtIndex:p_datePosn] valueForKey:@"notes"] objectAtIndex:p_displayPosn];
    return l_retDict;
}

- (void) notesZoomedViewCancelled
{
    [self cancelZoomedNotesView];
}

#pragma imerchant options selector delegates

- (void) addNewNotesToTheMerchant
{
    UIButton * l_reqdbtn = (UIButton*) [self.bar_list_btn customView];
    CGRect l_frombtnframe = [l_reqdbtn convertRect:l_reqdbtn.bounds toView:self.view];
    [self unloadOptionsListSelector:^{
        [self addNewNotesFromFrame:l_frombtnframe];
    }];
}

- (void) sendEMailAfterUnloadingPopupToLeadFromFrame:(CGRect) p_fromRect ofView:(id) p_onView
{
    CGRect l_fromViewRect = [(UIView*) p_onView convertRect:p_fromRect toView:self.view];
    NSString * l_emailaddr = [self getMerchDataeMailAddress];
    if ([iMerchStandardValidations isTextValueIsValidEMail:l_emailaddr])
    {
        [self unloadOptionsListSelector:^{
            [self sendEMailToLeadFromFrame:l_fromViewRect ofView:self.view];
        }];
    }
    else
    {
        [self unloadOptionsListSelector:^{
            [self showAlertMessage:@"Invalid email"];
        }];
    }
}

- (void) showStatusChangeScreen
{
    [self unloadOptionsListSelector:^{
        [self showStatusChangeScreenAboveBlurView];
    }];
}

- (void) showStatusChangeScreenAboveBlurView
{
    self.merchantStatChgDisp = [iMerchStatusChange new];
    self.merchantStatChgDisp.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.merchantStatChgDisp];
    self.merchantStatChgDisp.statChgDelegate = self;
    self.merchantStatChgDisp.alpha = 0;
    [self.merchantStatChgDisp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chgstat(358)]" options:0 metrics:nil views:@{@"chgstat":self.merchantStatChgDisp}]];
    [self.merchantStatChgDisp addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[chgstat(240)]" options:0 metrics:nil views:@{@"chgstat":self.merchantStatChgDisp}]];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.merchantStatChgDisp attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:self.merchantStatChgDisp attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(-32.0)]]];
    [self.view layoutIfNeeded];
    CGAffineTransform l_startTransform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2),CGAffineTransformMakeTranslation(self.view.frame.size.width, 0));
    self.merchantStatChgDisp.transform = l_startTransform;
    self.merchantStatChgDisp.alpha = 0.3;
    UIBlurEffect * l_blreffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _bgBlurView = [[UIVisualEffectView alloc] initWithEffect:l_blreffect];
    _bgBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bgBlurView];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:(1.0) constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    _bgBlurView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
    [self.view layoutIfNeeded];
    [self.view bringSubviewToFront:self.merchantStatChgDisp];
    NSInteger l_statusposnno = [_merchantStatusesList indexOfObject:[_merchCurrStatus lowercaseString]];
    [UIView animateWithDuration:0.4
                     animations:^(){
                         self.merchantStatChgDisp.transform = CGAffineTransformIdentity;
                         self.merchantStatChgDisp.alpha = 1.0;
                         _bgBlurView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL p_finished){
                         _bgBlurView.alpha = 0.95;
                         [self.merchantStatChgDisp animateStatusCell:l_statusposnno];
                         [self.navBar setUserInteractionEnabled:NO];
                     }];
}

#pragma status change related delegates for the new view

- (NSInteger) getNumberOfMerchantStatuses
{
    return [_merchantStatusesList count];
}

- (NSString*) getStatusNameAtPosn:(NSInteger) p_posnNo
{
    return [_merchantStatusesList objectAtIndex:p_posnNo];
}

- (void) cancelStatusChangeSelected
{
    [self hideTheStatusChangeScreenWithCB:^{}];
}

- (void) changeTheMerchantStatusToPosnNo:(NSInteger) p_toPosnNo
{
    [self.view bringSubviewToFront:self.actView];
    [self.actView startAnimating];
    NSInteger l_userid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue]; //changmerchantstatus
    NSString * l_newstatus = [_merchantStatusesList objectAtIndex:p_toPosnNo];
    if ([[_merchCurrStatus lowercaseString] isEqualToString:l_newstatus])
    {
        [self showAlertMessage:@"No status change"];
        [self hideTheStatusChangeScreenWithCB:^{
            [self.actView stopAnimating];
        }];
        return;
    }
    [[iMerchRESTProxy alloc]
     initProxyWithAPIType:@"CHANGMERCHANTSTATUS"
     andInputParams:@{@"leadid":[[_merchantData valueForKey:@"Lead Id"] copy],
                      @"userid":@(l_userid),
                      @"newstatus":l_newstatus}
     andReturnMethod:^(NSDictionary * p_changeResult)
     {
         [self.actView stopAnimating];
         NSInteger l_error = [[p_changeResult valueForKey:@"error"] integerValue];
         if (l_error==0)
         {
             NSDictionary * l_resultDict = (NSDictionary*)
             [NSJSONSerialization JSONObjectWithData:[p_changeResult valueForKey:@"returndata"] options:NSJSONReadingMutableLeaves
                                               error:NULL];
             l_error = [[l_resultDict valueForKey:@"error"] integerValue];
             if (l_error==0)
             {
                 [self hideTheStatusChangeScreenWithCB:^{
                     if (!_searchMerchant)
                     {
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     else
                         [self.navItem setTitle:[l_newstatus capitalizedString]];
                 }];
             }
             else
                 [self showAlertMessage:@"Error during\nstatus change"];
         }
         else
             [self showAlertMessage:@"Error during\nstatus change"];
     }];
}

- (NSInteger) getCurrentMerchantStatusPosn
{
    return [_merchantStatusesList indexOfObject:[_merchCurrStatus lowercaseString]];
}


@end
