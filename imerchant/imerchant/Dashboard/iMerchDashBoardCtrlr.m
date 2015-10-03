//
//  iMerchDashBoardCtrlr.m
//  imerchant
//
//  Created by Mohan Kumar on 04/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchDashBoardCtrlr.h"
#import "iMerchReEnterPwdChk.h"

#define kMaxIdleTimeSeconds 300.0

@interface iMerchDashBoardCtrlr ()<iMerchReEnterPwdChkDelegate>
{
    iMerchReEnterPwdChk * _reEntryChkPwdCapture;
    UIVisualEffectView * _bgBlurViewForHide;
}

@end

@implementation iMerchDashBoardCtrlr
@synthesize transitionType;
@synthesize navigateParams;

static NSTimer * _idleTimer;

- (void)awakeFromNib
{
    self.transitionType = horizontalWithoutBounce;
    self.pwdEntryForInactivity = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetIdleTimer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reEnterPasswordForNoActivity
{
    NSString * l_loginemail = [[NSUserDefaults standardUserDefaults]
                               valueForKey:@"loginemail"];
    _reEntryChkPwdCapture = [[iMerchReEnterPwdChk alloc] initWithEMail:l_loginemail andNoOfAttempts:3];
    _reEntryChkPwdCapture.pwdChkDelegate = self;
    _reEntryChkPwdCapture.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_reEntryChkPwdCapture];
    [_reEntryChkPwdCapture addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reenter(150)]" options:0 metrics:nil views:@{@"reenter":_reEntryChkPwdCapture}]];
    [_reEntryChkPwdCapture addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[reenter(240)]" options:0 metrics:nil views:@{@"reenter":_reEntryChkPwdCapture}]];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_reEntryChkPwdCapture attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_reEntryChkPwdCapture attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.65 constant:0.0]]];
    _reEntryChkPwdCapture.alpha = 0;
    [self.view layoutIfNeeded];
    _reEntryChkPwdCapture.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    UIBlurEffect * l_blreffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _bgBlurViewForHide = [[UIVisualEffectView alloc] initWithEffect:l_blreffect];
    _bgBlurViewForHide.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bgBlurViewForHide];
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_bgBlurViewForHide attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurViewForHide attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:_bgBlurViewForHide attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_bgBlurViewForHide attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
    [self.view layoutIfNeeded];
    _bgBlurViewForHide.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
    //_bgHideToolbar.translucent = NO;
    //_bgHideToolbar.barTintColor = [UIColor colorWithWhite:0.94 alpha:0.95];
    [self.view bringSubviewToFront:_reEntryChkPwdCapture];
    //_bgHideToolbar.alpha = 0.95;
    [UIView animateWithDuration:0.4
                     animations:^(){
                         _reEntryChkPwdCapture.transform = CGAffineTransformIdentity;
                         _bgBlurViewForHide.transform = CGAffineTransformIdentity;
                         _reEntryChkPwdCapture.alpha = 1.0;
                     }
                     completion:^(BOOL p_finished){
                         //[self.navBar setUserInteractionEnabled:NO];
                     }];
}

- (void) passwordReEntryHandle:(DICTIONARYCALLBACK) p_returnPwdChkInfo
{
    BOOL l_singleSignOn = [[[NSUserDefaults standardUserDefaults] valueForKey:@"singlesign"] boolValue];
    if (l_singleSignOn)
    {
        [self passWordCheckSuccess];
        return;
    }
}

#pragma mark -
#pragma mark Handling idle timeout

- (void) resetIdleTimer
{
    if (!_idleTimer)
    {
        _idleTimer = [NSTimer
                      scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                      target:self
                      selector:@selector(idleTimerExceeded)
                      userInfo:nil
                      repeats:NO];
    }
    else
    {
        if (fabs([_idleTimer.fireDate timeIntervalSinceNow])< (kMaxIdleTimeSeconds-1.0))
        {
            [_idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void) idleTimerExceeded
{
    if (self.pwdEntryForInactivity)
    {
        // need to write idle timer alert view to re-enter password
        [self reEnterPasswordForNoActivity];
    }
    else
    {
        _idleTimer = nil;
        [self resetIdleTimer];
    }
}

- (UIResponder*) nextResponder
{
    [self resetIdleTimer];
    return [super nextResponder];
}

- (void) unLoadPassWordCheckScreen:(BOOL) p_includeToolBar
{
    [UIView
     animateWithDuration:0.4
     animations:^(){
         _reEntryChkPwdCapture.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
         if (p_includeToolBar)
             _bgBlurViewForHide.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
     }
     completion:^(BOOL p_finished){
         [_reEntryChkPwdCapture removeFromSuperview];
         [_bgBlurViewForHide removeFromSuperview];
         _bgBlurViewForHide = nil;
         _reEntryChkPwdCapture = nil;
     }];
}

#pragma password reentry check delegates

- (void)passWordCheckFailed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self unLoadPassWordCheckScreen:NO];
    _idleTimer = nil;
    [self resetIdleTimer];
}

-(void)passWordCheckSuccess
{
    [self unLoadPassWordCheckScreen:YES];
    _idleTimer = nil;
    [self resetIdleTimer];
}

@end
