//
//  iMerchLogin.m
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchLogin.h"
#import "iMerchDefaults.h"
#import "iMerchStandardValidations.h"


@interface iMerchLogin()
{
    NSMutableDictionary * _viewsDictionary;
    NSMutableDictionary * _sizeMetrics;
}

@property (nonatomic,strong) UILabel * lblemail;
@property (nonatomic,strong) UILabel * lblpassword;
@property (nonatomic,strong) UITextField * txtemail;
@property (nonatomic,strong) UITextField * txtpassword;
@property (nonatomic,strong) UIButton * btnlogin;
@property (nonatomic,strong) UIButton * btnsinglesignin;
@property (nonatomic,strong) UILabel * lblsinglesign;

@end

@implementation iMerchLogin

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [self setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:0.98]];
        _viewsDictionary = [[NSMutableDictionary alloc] init];
        _sizeMetrics = [[NSMutableDictionary alloc] init];
        //_textconstraintsdict = [[NSMutableDictionary alloc] init];
    
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.lblemail = [iMerchDefaults getStandardLabelWithText:@"Email"];
    [self addSubview:self.lblemail];
    self.lblpassword = [iMerchDefaults getStandardLabelWithText:@"Password"];
    [self addSubview:self.lblpassword];
    self.txtemail = [iMerchDefaults getStandardTextField];
    [self addSubview:self.txtemail];
    [self.txtemail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.txtemail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtemail setDelegate:self];
    self.txtpassword = [iMerchDefaults getStandardTextField];
    [self addSubview:self.txtpassword];
    [self.txtpassword setDelegate:self];
    [self.txtpassword setSecureTextEntry:YES];
    self.btnlogin = [iMerchDefaults getStandardButton];
    [self.btnlogin setTitle:@"Log In" forState:UIControlStateNormal];
    [self addSubview:self.btnlogin];
    self.btnlogin.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(155.0/255.0) blue:(0.0/255.0) alpha:0.8];
    self.btnlogin.layer.cornerRadius = 5.0f;
    self.btnlogin.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.btnlogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnlogin addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnsinglesignin = [iMerchDefaults getStandardButton];
    [self.btnsinglesignin setImage:[UIImage imageNamed:@"chkbox_check"] forState:UIControlStateSelected];
    [self.btnsinglesignin setImage:[UIImage imageNamed:@"chkbox_uncheck"] forState:UIControlStateNormal];
    [self.btnsinglesignin addTarget:self action:@selector(singleSignInClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnsinglesignin];
    [_viewsDictionary setValue:self.btnsinglesignin forKey:@"btnauto"];
    [self.btnsinglesignin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btnauto(22)]" options:0 metrics:nil views:@{@"btnauto":self.btnsinglesignin}]];
    
    self.lblsinglesign = [iMerchDefaults getStandardLabelWithText:@"Single sign in"];
    [self addSubview:self.lblsinglesign];
    [_viewsDictionary setValue:self.lblsinglesign forKey:@"lblauto"];
    
    [_viewsDictionary setValuesForKeysWithDictionary:@{@"lblemail":self.lblemail,
                                                       @"lblpassword":self.lblpassword,
                                                       @"txtemail":self.txtemail,
                                                       @"txtpassword":self.txtpassword,
                                                       @"btnlogin":self.btnlogin}];
    for (NSString * l_keyname in @[@"txtemail",@"txtpassword",@"btnlogin"])
    {
        UIView * l_tmpview = (UIView*) [_viewsDictionary valueForKey:l_keyname];
        NSLayoutConstraint * l_newconstraint = [NSLayoutConstraint constraintWithItem:l_tmpview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0.0];
        //[_textconstraintsdict setValue:l_newconstraint forKey:l_keyname];
        [self addConstraint:l_newconstraint];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lblsinglesign attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.85 constant:(-35.0f)]];
    
    
    for (NSString * l_keyname in [_viewsDictionary allKeys])
    {
        UIView * l_tmpview = (UIView*) [_viewsDictionary valueForKey:l_keyname];
        [l_tmpview addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(22)]",l_keyname] options:0 metrics:nil views:_viewsDictionary]];
    }
    
    for (UIView * l_tmpview in @[self.txtemail, self.txtpassword, self.btnlogin])
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:l_tmpview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lblemail attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.txtemail attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lblpassword attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.txtpassword attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnsinglesignin attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.txtpassword attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lblsinglesign attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.btnsinglesignin attribute:NSLayoutAttributeRight multiplier:1.0 constant:13.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lblsinglesign attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.btnsinglesignin attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-10-[lblemail]-2-[txtemail]-5-[lblpassword]-2-[txtpassword]-15-[btnauto]-15-[btnlogin]"
      options:0
      metrics:nil
      views:_viewsDictionary]];
    
    [self.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:0.8].CGColor];
    [self.layer setBorderWidth:0.5];
    self.layer.cornerRadius = 3.0f;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = 0.3;
    
    UIBezierPath * l_shadowpath = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(self.layer.bounds,-3,3) cornerRadius:3.0f];
    self.layer.shadowPath = [l_shadowpath CGPath];
    self.clipsToBounds = NO;
    [self layoutIfNeeded];
    
    [self checkForSingleSignOptions];
    self.txtemail.text = @"dmurphy@businessbounce.com";
    self.txtpassword.text = @"THIRSTY";
}

- (void)checkForSingleSignOptions
{
    BOOL l_singlesign = [[[NSUserDefaults standardUserDefaults] valueForKey:@"singlesign"] boolValue];
    self.btnsinglesignin.selected = l_singlesign;
    if (l_singlesign)
    {
        self.txtemail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        self.txtpassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    }
    else
    {
        self.txtemail.text = @"";
        self.txtpassword.text = @"";
    }
}

- (IBAction) singleSignInClicked:(id)sender
{
    self.btnsinglesignin.selected = !self.btnsinglesignin.selected;
}

- (IBAction) loginClicked:(id)sender
{
    [self resignFirstResponder];
    
    if ([iMerchStandardValidations isTextFieldIsempty:self.txtemail])
    {
        [self showAlertMessage:@"email invalid!!"];
        return;
    }
    if ([iMerchStandardValidations isTextFieldIsempty:self.txtpassword])
    {
        [self showAlertMessage:@"password empty!!"];
        return;
    }
    [self startButtonWobble];
    [self.handlerDelegate executeLogin:@{@"email":self.txtemail.text,
                                         @"password":self.txtpassword.text,
                                         @"singlesign":@(self.btnsinglesignin.selected)}];
    if (!self.btnsinglesignin.selected)
    {
        //self.txtemail.text = @"";
        self.txtpassword.text = @"";
    }
}

- (void) startButtonWobble
{
    self.btnlogin.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [UIView animateWithDuration:.3
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         self.btnlogin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                         self.btnlogin.alpha = 0.5;
                     }
                     completion:NULL];
}

- (void)stopButtonWobble
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.btnlogin.transform = CGAffineTransformIdentity;
                         self.btnlogin.alpha = 1.0;
                     }
                     completion:NULL
     ];
}


- (void) showAlertMessage:(NSString*) p_alertMessage
{
    UIAlertView * l_showAlert = [[UIAlertView alloc] initWithTitle:@"iMerchant" message:p_alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [l_showAlert show];
}

- (BOOL)resignFirstResponder
{
    [self.txtemail resignFirstResponder];
    [self.txtpassword resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) setScrollPositionSetAppropriately
{
    if (self.txtemail.layer.borderColor==[UIColor blueColor].CGColor)
    {
        [self textFieldDidBeginEditing:self.txtemail];
        return;
    }
    if (self.txtpassword.layer.borderColor==[UIColor blueColor].CGColor)
    {
        [self textFieldDidBeginEditing:self.txtpassword];
        return;
    }
}

#pragma text field related delegates handling for email and password

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect l_inputfieldbounds = [textField convertRect:textField.bounds toView:self];
    [textField.layer setBorderColor:[UIColor blueColor].CGColor];
    [textField.layer setBorderWidth:0.0f];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [textField.layer setBorderWidth:0.5f];
                     }];
    [self.handlerDelegate setTextDisplayFromRect:l_inputfieldbounds];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:[UIColor clearColor].CGColor];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [textField.layer setBorderWidth:0.0f];
                     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.txtemail])
        [self.txtpassword becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end
