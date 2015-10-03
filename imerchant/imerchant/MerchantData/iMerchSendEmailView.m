//
//  iMerchSendEmailView.m
//  iMerchant
//
//  Created by Mohan Kumar on 06/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchSendEmailView.h"
#import "iMerchDefaults.h"
#import "iMerchStandardValidations.h"

@interface iMerchSendEmailView()
{
    NSLayoutConstraint * _emailTextConstraint;
    int _currTextEntry;
    CGSize _keyboardsize;
}

@property (nonatomic,strong) UIToolbar * toolBar;
@property (nonatomic,strong) UIScrollView * mainScroll;
@property (nonatomic,strong) UILabel * subjCaption;
@property (nonatomic,strong) UITextField * subjText;
@property (nonatomic,strong) UILabel * bodyCaption;
@property (nonatomic,strong) UITextView * bodyTxtVw;

@end

@implementation iMerchSendEmailView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:0.98]];
        _currTextEntry = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBecomesVisible:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBecomesHidden:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    UIBarButtonItem * l_barcancel_btn, * l_barsend_btn;
    self.toolBar = [UIToolbar new];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolBar.barTintColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    self.toolBar.translucent = NO;
    [self addSubview:self.toolBar];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title(38)]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]]];
    UILabel * l_titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 38)];
    l_titlelabel.text = @"Send EMail";
    l_titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    l_titlelabel.textAlignment = NSTextAlignmentCenter;
    l_titlelabel.textColor = [UIColor whiteColor];
    UIBarButtonItem * l_bartitle_btn = [[UIBarButtonItem alloc] initWithCustomView:l_titlelabel];
    UIBarButtonItem * l_flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * l_flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton * l_cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 26, 26)];
    /*[l_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [l_cancelBtn setTitleColor:[iMerchDefaults getDefaultTextColor] forState:UIControlStateNormal];*/
    [l_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [l_cancelBtn addTarget:self action:@selector(cancelSendMailOperation) forControlEvents:UIControlEventTouchUpInside];
    l_cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    l_barcancel_btn = [[UIBarButtonItem alloc] initWithCustomView:l_cancelBtn];

    UIButton * l_sendmailBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 32, 32)];
    [l_sendmailBtn setImage:[UIImage imageNamed:@"email_nb"] forState:UIControlStateNormal];
    [l_sendmailBtn addTarget:self action:@selector(sendEmailToTheLead) forControlEvents:UIControlEventTouchUpInside];
    l_barsend_btn = [[UIBarButtonItem alloc] initWithCustomView:l_sendmailBtn];
    self.toolBar.items = @[l_barcancel_btn, l_flex1, l_bartitle_btn, l_flex2, l_barsend_btn];
    self.mainScroll = [UIScrollView new];
    self.mainScroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScroll setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.mainScroll];
    self.mainScroll.scrollEnabled = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-38.0)],[NSLayoutConstraint constraintWithItem:self.mainScroll attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(19.0)]]];
    [self addTextViewIntoScroll];
    [self layoutIfNeeded];
    [self addUnderLineToTxtObj:self.subjText];
}

- (void) addUnderLineToTxtObj:(UIView*) p_txtObject
{
    if ([p_txtObject.layer.sublayers count]>1)
    {
        [[p_txtObject.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
    }
    CAShapeLayer * l_subjUnderline = [[CAShapeLayer alloc] init];
    UIBezierPath * l_undelinepath = [[UIBezierPath alloc] init];
    [l_subjUnderline setLineWidth:0.5f];
    [l_subjUnderline setStrokeColor:[UIColor grayColor].CGColor];
    [l_undelinepath moveToPoint:CGPointMake(0, p_txtObject.bounds.size.height)];
    [l_undelinepath addLineToPoint:CGPointMake(p_txtObject.bounds.size.width*2.0, p_txtObject.bounds.size.height)];
    l_subjUnderline.path = [l_undelinepath CGPath];
    [l_subjUnderline setBackgroundColor:[UIColor clearColor].CGColor];
    [p_txtObject.layer addSublayer:l_subjUnderline];
}


- (void) addTextViewIntoScroll
{
    self.subjCaption = [iMerchDefaults getStandardLabelWithText:@"Subject"];
    [self.mainScroll addSubview:self.subjCaption];
    [self.mainScroll addConstraints:@[[NSLayoutConstraint constraintWithItem:self.subjCaption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0.0],[NSLayoutConstraint constraintWithItem:self.subjCaption attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    [self.subjCaption addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subj(30)]" options:0 metrics:nil views:@{@"subj":self.subjCaption}]];
    self.subjText = [iMerchDefaults getStandardTextField];
    self.subjText.delegate = self;
    [self.mainScroll addSubview:self.subjText];
    self.subjText.placeholder = @"Enter subject here..!!";
    self.subjText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.mainScroll addConstraints:@[[NSLayoutConstraint constraintWithItem:self.subjText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0.0],[NSLayoutConstraint constraintWithItem:self.subjText attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    [self.subjText addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subj(30)]" options:0 metrics:nil views:@{@"subj":self.subjText}]];
    self.bodyCaption = [iMerchDefaults getStandardLabelWithText:@"Body"];
    [self.mainScroll addSubview:self.bodyCaption];
    [self.mainScroll addConstraints:@[[NSLayoutConstraint constraintWithItem:self.bodyCaption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0.0],[NSLayoutConstraint constraintWithItem:self.bodyCaption attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    [self.bodyCaption addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[body(30)]" options:0 metrics:nil views:@{@"body":self.bodyCaption}]];
    self.bodyTxtVw = [UITextView new];
    self.bodyTxtVw.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyTxtVw.font = [UIFont systemFontOfSize:13.0f];
    self.bodyTxtVw.textColor = [iMerchDefaults getDefaultTextColor];
    self.bodyTxtVw.textAlignment = NSTextAlignmentLeft;
    [self.bodyTxtVw setBackgroundColor:[UIColor whiteColor]];
    self.bodyTxtVw.delegate = self;
    self.bodyTxtVw.text = @"Enter mail content here....!!";
    self.bodyTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.mainScroll addSubview:self.bodyTxtVw];
    [self.mainScroll addConstraints:@[[NSLayoutConstraint constraintWithItem:self.bodyTxtVw attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0.0],[NSLayoutConstraint constraintWithItem:self.bodyTxtVw attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    [self.mainScroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[sc]-2-[st]-5-[bc]-2-[bt]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"sc":self.subjCaption, @"st":self.subjText, @"bc":self.bodyCaption,@"bt":self.bodyTxtVw}]];
    _emailTextConstraint = [NSLayoutConstraint constraintWithItem:self.bodyTxtVw attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0-30.0-2.0-30.0-5.0-30.0-2.0-10.0)];
    [self.mainScroll addConstraint:_emailTextConstraint];
    
}

- (BOOL)resignFirstResponder
{
    [self.subjText resignFirstResponder];
    [self.bodyTxtVw resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) cancelSendMailOperation
{
    [self.emailDelegate cancelEMailSending];
}

- (void) sendEmailToTheLead
{
    //:(NSString*) p_subject withBody:(NSString*) p_bodyText
    [self.emailDelegate sendEMailWithSubj:self.subjText.text andBody:self.bodyTxtVw.text];
}

- (void) positionScrollForDataEntry
{
    CGRect l_selfFrame = self.frame;
    CGRect l_selfsuperFrame = self.superview.frame;
    CGFloat l_keyboardTopY = l_selfsuperFrame.size.height - _keyboardsize.height;
    if (l_keyboardTopY < (l_selfFrame.origin.y+l_selfFrame.size.height))
    {
        if (_currTextEntry==1)
        {
            CGRect l_subjtextframe = [self.mainScroll convertRect:self.subjText.frame toView:self.superview];
            if (l_keyboardTopY < (l_subjtextframe.origin.y+l_subjtextframe.size.height))
            {
                CGFloat l_liftHeight = (l_subjtextframe.origin.y+l_subjtextframe.size.height) - l_keyboardTopY+5;
                [UIView animateWithDuration:0.1
                                 animations:^(){
                                     [self.mainScroll setContentOffset:CGPointMake(0, l_liftHeight)];
                                 }];
            }
        }
        else if (_currTextEntry==2)
        {
            CGRect l_bodytextframe = [self.mainScroll convertRect:self.bodyTxtVw.frame toView:self.superview];
            if (l_keyboardTopY < (l_bodytextframe.origin.y+l_bodytextframe.size.height))
            {
                CGFloat l_liftHeight = (l_bodytextframe.origin.y+l_bodytextframe.size.height) - l_keyboardTopY+5;
                [self.mainScroll removeConstraint:_emailTextConstraint];
                _emailTextConstraint = [NSLayoutConstraint constraintWithItem:self.bodyTxtVw attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0-30.0-2.0-30.0-5.0-30.0-2.0-10.0-l_liftHeight)];
                [self.mainScroll addConstraint:_emailTextConstraint];
                
                [UIView animateWithDuration:0.1
                                 animations:^(){
                                     //[self.mainScroll setContentOffset:CGPointMake(0, l_liftHeight)];
                                     [self.mainScroll layoutIfNeeded];
                                 }];
            }
        }
    }
}

- (NSArray*) bValidateEMailData
{
    NSString * l_emailcontent = self.bodyTxtVw.text;
    l_emailcontent = [l_emailcontent stringByReplacingOccurrencesOfString:@"Enter mail content here....!!" withString:@""];
    l_emailcontent = [l_emailcontent stringByReplacingOccurrencesOfString:@" " withString:@""];
    l_emailcontent = [l_emailcontent stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if ([iMerchStandardValidations isTextFieldIsempty:self.subjText])
    {
        [self.subjText becomeFirstResponder];
        return @[@(NO),@"Subject Empty!!!"];
    }
    else if ((l_emailcontent==nil) | ([l_emailcontent length]==0))
    {
        [self.bodyTxtVw becomeFirstResponder];
        return @[@(NO),@"Mail Body Empty!!!"];
    }
    return @[@(YES),@"Validation Success"];
}

#pragma textview delegates to enable disable keyboard notifications

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter mail content here....!!"])
    {
        textView.text = @"";
    }
    _currTextEntry = 2;
    [self positionScrollForDataEntry];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString * l_enteredText = textView.text;
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@"Enter mail content here....!!" withString:@""];
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@" " withString:@""];
    l_enteredText = [l_enteredText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    _currTextEntry = 0;
    if ([l_enteredText length]==0)
    {
        textView.text = @"Enter mail content here....!!";
    }
}

#pragma text field (subject caption) related delegates

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currTextEntry = 1;
    [self positionScrollForDataEntry];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.bodyTxtVw becomeFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _currTextEntry = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma keyboard related notificaiton handlers

- (void) keyboardBecomesVisible:(NSNotification*) p_visibeNotification
{
    NSDictionary * l_userInfo = [p_visibeNotification userInfo];
    _keyboardsize = [[l_userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

- (void) keyboardBecomesHidden:(NSNotification*) p_hidingNotification
{
    [self.mainScroll removeConstraint:_emailTextConstraint];
    _emailTextConstraint = [NSLayoutConstraint constraintWithItem:self.bodyTxtVw attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mainScroll attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-4.0-30.0-2.0-30.0-5.0-30.0-2.0-10.0)];
    [self.mainScroll addConstraint:_emailTextConstraint];
    [UIView animateWithDuration:0.1
                     animations:^(){
                         //[self.mainScroll setContentOffset:CGPointMake(0, 0)];
                         [self.mainScroll layoutIfNeeded];
                     }];
}

@end
