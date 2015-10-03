//
//  iMerchSignInController.m
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchSignInController.h"
#import "iMerchRESTProxy.h"

@interface iMerchSignInController ()<UIGestureRecognizerDelegate>
{
    CGPoint _scrollOffset;
    UITapGestureRecognizer * _resignGesture;
    CGSize _keyBdSize;
}

@property (nonatomic,strong) UIScrollView * mainScroll;
@property (nonatomic,strong) iMerchLogin * loginView;
@property (nonatomic,strong) UILabel * loginTitle;

@end

@implementation iMerchSignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitionType = horizontalWithoutBounce;
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.97]];
    [self setLoginScreenScroll];
    [self setUpLoginViewInsideScroll];
    [self.loginView checkForSingleSignOptions];
    _resignGesture = [[UITapGestureRecognizer alloc] init];
    _resignGesture.numberOfTapsRequired = 1;
    _resignGesture.delegate = self;
    [self.mainScroll addGestureRecognizer:_resignGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsHidden:) name:UIKeyboardDidHideNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void) keyBoardIsShown:(NSNotification*) p_kbVisibleNotifyInfo
{
    NSDictionary * l_notifyInfo = [p_kbVisibleNotifyInfo userInfo];
    _keyBdSize = [[l_notifyInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.loginView setScrollPositionSetAppropriately];
    _scrollOffset = self.mainScroll.contentOffset;
}

- (void) keyBoardIsHidden:(NSNotification*) p_hidingNotifyInfo
{
    [UIView animateWithDuration:0.2
                     animations:^(){
                         [self.mainScroll setContentOffset:_scrollOffset];
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLoginScreenScroll
{
    //CGRect l_applframe = [[UIScreen mainScreen] applicationFrame];
    self.mainScroll = [UIScrollView new];
    self.mainScroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScroll setScrollEnabled:NO];
    [self.mainScroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.mainScroll];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:self.mainScroll
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeWidth
      multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:self.mainScroll
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeHeight
      multiplier:1.0 constant:0.0]];
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width*1.5, self.view.frame.size.height*2.5)];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[mainscroll]"
      options:0
      metrics:nil
      views:@{@"mainscroll":self.mainScroll}]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[mainscroll]"
      options:0
      metrics:nil
      views:@{@"mainscroll":self.mainScroll}]];
    
    [self.view layoutIfNeeded];
}

- (void) setUpLoginViewInsideScroll
{
    self.loginTitle = [iMerchDefaults getStandardLabelWithText:@"Login"];
    [self.mainScroll addSubview:self.loginTitle];
    self.loginTitle.font = [UIFont boldSystemFontOfSize:28.0f];
    
    self.loginView = [[iMerchLogin alloc] init];
    self.loginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScroll addSubview:self.loginView];
    [self.mainScroll setScrollEnabled:YES];
    [self.mainScroll setBounces:YES];
    self.loginView.handlerDelegate = self;
    [self.loginView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loginview(205)]" options:0 metrics:nil views:@{@"loginview":self.loginView}]];
    [self.loginView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginview(250)]" options:0 metrics:nil views:@{@"loginview":self.loginView}]];
    [self.mainScroll addConstraint:[NSLayoutConstraint constraintWithItem:self.loginView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.mainScroll addConstraint:[NSLayoutConstraint constraintWithItem:self.loginView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.loginTitle addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[logintitle(35)]" options:0 metrics:nil views:@{@"logintitle":self.loginTitle}]];
    [self.mainScroll addConstraint:[NSLayoutConstraint constraintWithItem:self.loginTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginView attribute:NSLayoutAttributeTop multiplier:1.0 constant:(-50)]];
    [self.mainScroll addConstraint:[NSLayoutConstraint constraintWithItem:self.loginTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.loginView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.mainScroll addConstraint:[NSLayoutConstraint constraintWithItem:self.loginTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.loginView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.mainScroll layoutIfNeeded];
}

- (void) shakeForAuthenticationFailure
{
    CABasicAnimation * l_shakeanimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [l_shakeanimation setDuration:0.1];
    [l_shakeanimation setRepeatCount:4];
    [l_shakeanimation setAutoreverses:YES];
    CGFloat l_shakeshift = 20.0;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        l_shakeshift = 35.0;
    [l_shakeanimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.loginView.center.x-l_shakeshift, self.loginView.center.y)]];
    [l_shakeanimation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.loginView.center.x+l_shakeshift, self.loginView.center.y)]];
    [self.loginView.layer addAnimation:l_shakeanimation forKey:@"position"];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    CGSize l_bouncesize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*1.25);
    [self.mainScroll setContentSize:l_bouncesize];
}

#pragma login view related delegates

- (void) executeLogin:(NSDictionary*) p_loginInfo
{
    [self.view bringSubviewToFront:self.actView];
    [self.actView startAnimating];
    NSUserDefaults * l_stdDefalts = [NSUserDefaults standardUserDefaults];
    [[iMerchRESTProxy alloc] initProxyWithAPIType:@"LOGIN" andInputParams:p_loginInfo andReturnMethod:^(NSDictionary * p_returnData)
    {
        NSInteger l_error = [[p_returnData valueForKey:@"error"] integerValue];
        [self.actView stopAnimating];
        [self.loginView stopButtonWobble];
        if (l_error==0) {
            NSError * l_parseerror = nil;
            NSDictionary * l_loginreturn = [NSJSONSerialization JSONObjectWithData:[p_returnData valueForKey:@"returndata"] options:NSJSONReadingMutableLeaves error:&l_parseerror];
            if (!l_parseerror)
            {
                if ([[l_loginreturn valueForKey:@"error"] intValue]==0)
                {
                    [l_stdDefalts setBool:[[l_loginreturn valueForKey:@"singlesign"] boolValue] forKey:@"singlesign"];
                    [l_stdDefalts setValue:[l_loginreturn valueForKey:@"email"] forKey:@"email"];
                    [l_stdDefalts setValue:[l_loginreturn valueForKey:@"password"] forKey:@"password"];
                    [l_stdDefalts setInteger:[[l_loginreturn valueForKey:@"userid"] integerValue] forKey:@"userid"];
                    [l_stdDefalts setValue:[l_loginreturn valueForKey:@"name"] forKey:@"username"];
                    [l_stdDefalts setInteger:[[l_loginreturn valueForKey:@"isbranchadmin"] integerValue] forKey:@"isbranchadmin"];
                    [l_stdDefalts setValue:[l_loginreturn valueForKey:@"sessionid"] forKey:@"sessionid"];
                    [l_stdDefalts setInteger:[[l_loginreturn valueForKey:@"isadmin"] integerValue] forKey:@"isadmin"];
                    [l_stdDefalts setInteger:[[l_loginreturn valueForKey:@"branchid"] integerValue] forKey:@"branchid"];
                    [l_stdDefalts setValue:[l_loginreturn valueForKey:@"loginemail"] forKey:@"loginemail"];
                    [l_stdDefalts synchronize];
                    [self performSegueWithIdentifier:@"loginsuccess" sender:self];
                    return ;
                }
            }
        }
        [l_stdDefalts removeObjectForKey:@"email"];
        [l_stdDefalts removeObjectForKey:@"password"];
        [l_stdDefalts removeObjectForKey:@"userid"];
        [l_stdDefalts removeObjectForKey:@"username"];
        [l_stdDefalts removeObjectForKey:@"isbranchadmin"];
        [l_stdDefalts removeObjectForKey:@"sessionid"];
        [l_stdDefalts removeObjectForKey:@"isadmin"];
        [l_stdDefalts removeObjectForKey:@"branchid"];
        [l_stdDefalts removeObjectForKey:@"loginemail"];
        [self shakeForAuthenticationFailure];
    }];
}

- (void) setTextDisplayFromRect:(CGRect) p_fromRect
{
    CGRect l_viewrect = [self.loginView convertRect:p_fromRect toView:self.view];
    CGFloat l_distancefrombottom = self.view.frame.size.height - l_viewrect.origin.y - l_viewrect.size.height;
    if (l_distancefrombottom < _keyBdSize.height)
    {
        _scrollOffset = CGPointMake(0, _keyBdSize.height - l_distancefrombottom);
        [UIView animateWithDuration:0.2
                 animations:^(){
                     [self.mainScroll setContentOffset:_scrollOffset];
                 }];
    }
}

#pragma gesture recognizer delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint l_gesturePt = [touch locationInView:self.mainScroll];
    if (CGRectContainsPoint(self.loginView.frame, l_gesturePt)==NO)
    {
        [self.loginView resignFirstResponder];
        return NO;
    }
    return NO;
}

@end
