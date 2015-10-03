//
//  iMerchReEnterPwdChk.m
//  iMerchant
//
//  Created by Mohan Kumar on 09/03/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import "iMerchReEnterPwdChk.h"
#import "iMerchRESTProxy.h"

@interface iMerchReEnterPwdChk()<UITextFieldDelegate>
{
    NSString * _entryEMail;
    NSInteger _noOfAttemptsReqd;
    NSInteger _noOfAttempts;
    UIToolbar * _tbarReEntry;
    UIImageView * _imgWarning;
    UILabel * _lblEMail;
    UITextField * _txtPassword;
    UIButton * _btnOK, * _btnCancel;
    UIActivityIndicatorView * _actView;
}

@end

@implementation iMerchReEnterPwdChk

- (instancetype) initWithEMail:(NSString*) p_eMail andNoOfAttempts:(NSInteger) p_noOfAttempts;
{
    self = [super init];
    if (self)
    {
        _entryEMail = p_eMail;
        _noOfAttemptsReqd = p_noOfAttempts;
        _noOfAttempts = 1;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NOPARAMCALLBACK l_drawLines = ^()
    {
        CGContextRef l_ctxref = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(l_ctxref, 1.0);
        CGContextSetStrokeColorWithColor(l_ctxref, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(l_ctxref, 0, 38.0);
        CGContextAddLineToPoint(l_ctxref, rect.size.width, 38.0);
        CGContextStrokePath(l_ctxref);
    };
    if (_tbarReEntry)
    {
        return;
    }
    _tbarReEntry = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 38.0)];
    _tbarReEntry.translucent = NO;
    _tbarReEntry.barTintColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [self addSubview:_tbarReEntry];
    
    UILabel * l_lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width/2.0, 38)];
    l_lbltitle.text = @"Re-Enter";
    l_lbltitle.font = [UIFont boldSystemFontOfSize:18.0f];
    l_lbltitle.textColor = [UIColor whiteColor];
    l_lbltitle.textAlignment = NSTextAlignmentCenter;
    [l_lbltitle setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem * l_titlebarbtn = [[UIBarButtonItem alloc] initWithCustomView:l_lbltitle];
    
    UIBarButtonItem * l_flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * l_flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton * l_cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26.0, 26.0)];
    [l_cancelbtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [l_cancelbtn addTarget:self action:@selector(cancelReLoginAndLogout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * l_bar_cancel_btn = [[UIBarButtonItem alloc] initWithCustomView:l_cancelbtn];
    
    UIButton * l_okreloginbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26.0, 26.0)];
    [l_okreloginbtn setTitle:@"OK" forState:UIControlStateNormal];
    [l_okreloginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [l_okreloginbtn addTarget:self action:@selector(checkReloginPassWord) forControlEvents:UIControlEventTouchUpInside];
    l_okreloginbtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    UIBarButtonItem * l_bar_addnotes_btn = [[UIBarButtonItem alloc] initWithCustomView:l_okreloginbtn];
    _tbarReEntry.items = @[l_bar_cancel_btn, l_flex1, l_titlebarbtn, l_flex2, l_bar_addnotes_btn];
    
    _actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(rect.size.width/2.0-10.0, rect.size.height/2.0-10.0, 20.0, 20.0)];
    _actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _actView.transform = CGAffineTransformMakeScale(1.75, 1.75);
    _actView.hidesWhenStopped = YES;
    [self addSubview:_actView];
    
    _imgWarning = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 50, rect.size.height - 100.0)];
    _imgWarning.image = [UIImage imageNamed:@"pause"];
    [self addSubview:_imgWarning];
    
    _lblEMail = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, rect.size.width - 80.0, (rect.size.height - 70.0)/2.0)];
    _lblEMail.font = [UIFont systemFontOfSize:11.0f];
    _lblEMail.textAlignment = NSTextAlignmentLeft;
    _lblEMail.numberOfLines = 0;
    _lblEMail.text = [NSString stringWithFormat:@"Enter password for eMail: %@", _entryEMail];
    [self addSubview:_lblEMail];
    
    _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(70, rect.size.height-50, rect.size.width-80.0, 30)];
    [_txtPassword setSecureTextEntry:YES];
    _txtPassword.font = [UIFont systemFontOfSize:14.0];
    _txtPassword.textAlignment = NSTextAlignmentLeft;
    [_txtPassword setPlaceholder:@"Enter password"];
    _txtPassword.delegate = self;
    [self addSubview:_txtPassword];
    l_drawLines();
    [self setForAttempt:_noOfAttempts];
}

- (void) setForAttempt:(NSInteger) p_attemptNo
{
    NSString * l_imagename = nil;
    if (p_attemptNo>0)
        l_imagename = [NSString stringWithFormat:@"attempt%ld", (long)p_attemptNo];
    else
        l_imagename = @"loginfail";

    [_actView stopAnimating];
    [UIView animateWithDuration:0.2
                     animations:^(){
                         _imgWarning.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(0.10, 0.10));
                     }
                     completion:^(BOOL p_finished){
                         _imgWarning.image = [UIImage imageNamed:l_imagename];
                         [UIView
                          animateWithDuration:0.2
                          animations:^(){
                                  _imgWarning.transform = CGAffineTransformIdentity;
                          } completion:^(BOOL p_finished){
                              if (p_attemptNo<0)
                                  [self.pwdChkDelegate passWordCheckFailed];
                          }];
                     }];
    _txtPassword.text = @"";
}

- (void) getAuthenticationResultFromProxy:(NSString*) p_passWordEntered
{
    NOPARAMCALLBACK l_pwdFailureCountCheck = ^()
    {
        _noOfAttempts++;
        if (_noOfAttempts>_noOfAttemptsReqd)
        {
            [self setForAttempt:(-1)];
        }
        else
        {
            [self setForAttempt:_noOfAttempts];
        }
    };
    
    NSDictionary * l_inputParams = @{@"email":[[NSUserDefaults standardUserDefaults]
                                               valueForKey:@"loginemail"],
                                     @"password":p_passWordEntered};
    [[iMerchRESTProxy alloc] initProxyWithAPIType:@"LOGIN"
                                   andInputParams:l_inputParams
                                  andReturnMethod:^(NSDictionary * p_reloginCheckData)
     {
         NSInteger l_error = [[p_reloginCheckData valueForKey:@"error"] integerValue];
         if (l_error==0)
         {
             NSError * l_parseerror = nil;
             NSDictionary * l_loginreturn = [NSJSONSerialization
                                             JSONObjectWithData:[p_reloginCheckData
                                                                 valueForKey:@"returndata"]
                                             options:NSJSONReadingMutableLeaves
                                             error:&l_parseerror];
             if (!l_parseerror)
             {
                 if ([[l_loginreturn valueForKey:@"error"] intValue]==0)
                     [self.pwdChkDelegate passWordCheckSuccess];
                 else
                     l_pwdFailureCountCheck();
             }
             else
                 l_pwdFailureCountCheck();
         }
     }];
}

- (void) cancelReLoginAndLogout
{
    [self.pwdChkDelegate passWordCheckFailed];
}

- (void) checkReloginPassWord
{
    [_actView startAnimating];
    NSString * l_pwdEntered = _txtPassword.text;
    l_pwdEntered = !l_pwdEntered?@"":l_pwdEntered;
    [self getAuthenticationResultFromProxy:l_pwdEntered];
}

#pragma text field delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
