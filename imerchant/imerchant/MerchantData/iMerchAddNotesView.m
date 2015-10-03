//
//  iMerchAddNotesView.m
//  iMerchant
//
//  Created by Mohan Kumar on 04/02/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchAddNotesView.h"
#import "iMerchDefaults.h"

@interface iMerchAddNotesView()
{
    NSArray * _notesYConstraints;
}

@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UITextView * notesText;

@end

@implementation iMerchAddNotesView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:0.94]];
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
    
    UIBarButtonItem * l_bar_cancel_btn, * l_bar_addnotes_btn;
    self.toolBar = [UIToolbar new];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolBar.barTintColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    self.toolBar.translucent = NO;
    [self addSubview:self.toolBar];
    
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title(38)]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]" options:0 metrics:nil views:@{@"title":self.toolBar}]];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    
    UILabel * l_titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 38.0)];
    l_titlelabel.text = @"Add Notes";
    l_titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    l_titlelabel.textAlignment = NSTextAlignmentCenter;
    l_titlelabel.textColor = [UIColor whiteColor];
    UIBarButtonItem * l_titlebtn = [[UIBarButtonItem alloc] initWithCustomView:l_titlelabel];
    UIBarButtonItem * l_flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * l_flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton * l_cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 2.0, 26.0, 26.0)];
    [l_cancelbtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    //[l_cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
    //[l_cancelbtn setTitleColor:[iMerchDefaults getDefaultTextColor] forState:UIControlStateNormal];
    [l_cancelbtn addTarget:self action:@selector(cancelNotesEntry) forControlEvents:UIControlEventTouchUpInside];
    l_cancelbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    l_bar_cancel_btn = [[UIBarButtonItem alloc] initWithCustomView:l_cancelbtn];
    
    UIButton * l_addnotesbtn = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 2.0, 45.0, 26.0)];
    [l_addnotesbtn setTitle:@"Post" forState:UIControlStateNormal];
    [l_addnotesbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [l_addnotesbtn addTarget:self action:@selector(addNotesEntryToDB) forControlEvents:UIControlEventTouchUpInside];
    l_addnotesbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    l_bar_addnotes_btn = [[UIBarButtonItem alloc] initWithCustomView:l_addnotesbtn];
    self.toolBar.items = @[l_bar_cancel_btn, l_flex1, l_titlebtn, l_flex2, l_bar_addnotes_btn];
    
    self.notesText = [UITextView new];
    self.notesText.translatesAutoresizingMaskIntoConstraints = NO;
    self.notesText.font = [UIFont systemFontOfSize:13.0f];
    self.notesText.textColor = [iMerchDefaults getDefaultTextColor];
    self.notesText.textAlignment = NSTextAlignmentLeft;
    self.notesText.delegate = self;
    [self.notesText.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.notesText setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.notesText];
    self.notesText.text = @"Enter Notes Here....";
    self.notesText.scrollEnabled = YES;
    self.notesText.showsVerticalScrollIndicator = YES;
    self.notesText.autocorrectionType = UITextAutocorrectionTypeNo;
    //[self.notesText setContentSize:CGSizeMake(rect.size.width*2.0, rect.size.height*2.0)];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]]];
    _notesYConstraints = @[[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-38.0)],[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(19.0)]];
    [self addConstraints:_notesYConstraints];
    //[self addTextViewIntoScroll];
    l_drawLine();
    [self layoutIfNeeded];
}


- (void) cancelNotesEntry
{
    [self resignFirstResponder];
    [self.notesDelegate addNotesCancelled];
}

- (void) addNotesEntryToDB
{
    [self resignFirstResponder];
    [self.notesDelegate addNotesMessage:self.notesText.text];
}

- (BOOL)resignFirstResponder
{
    [self.notesText resignFirstResponder];
    return [super resignFirstResponder];
}

- (NSArray*) bValidateNotesdata
{
    NSString * l_enteredText = self.notesText.text;
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@"Enter Notes Here...." withString:@""];
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@" " withString:@""];
    l_enteredText = [l_enteredText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if ((l_enteredText==nil) | ([l_enteredText length]==0))
    {
        [self.notesText becomeFirstResponder];
        return @[@(NO), @"Invalid Notes!!!"];
    }
    return @[@(YES),@"Validation Success"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma notifications for keyboard will show and hide related

- (void) keyboardBecomesVisible:(NSNotification*) p_visibeNotification
{
    NSDictionary * l_userInfo = [p_visibeNotification userInfo];
    CGSize l_keyboardsize = [[l_userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect l_selfFrame = self.frame;
    CGRect l_selfsuperFrame = self.superview.frame;
    CGFloat l_keyboardTopY = l_selfsuperFrame.size.height - l_keyboardsize.height;
    if (l_keyboardTopY < (l_selfFrame.origin.y+l_selfFrame.size.height))
    {
        CGFloat l_reduceHeight = (l_selfFrame.origin.y+l_selfFrame.size.height) - l_keyboardTopY+5;
        [self removeConstraints:_notesYConstraints];
        _notesYConstraints = @[[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-38.0-l_reduceHeight)],[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(19.0-l_reduceHeight/2.0)]];
        [self addConstraints:_notesYConstraints];
        [UIView animateWithDuration:0.1
                         animations:^(){
                             [self layoutIfNeeded];
                         }];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma textview delegates to enable disable keyboard notifications

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBecomesVisible:) name:UIKeyboardDidShowNotification object:nil];
    if ([textView.text isEqualToString:@"Enter Notes Here...."])
    {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString * l_enteredText = textView.text;
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@"Enter Notes Here...." withString:@""];
    l_enteredText = [l_enteredText stringByReplacingOccurrencesOfString:@" " withString:@""];
    l_enteredText = [l_enteredText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self removeConstraints:_notesYConstraints];
    _notesYConstraints = @[[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(-38.0)],[NSLayoutConstraint constraintWithItem:self.notesText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(19.0)]];
    [self addConstraints:_notesYConstraints];
    [UIView animateWithDuration:0.1
                     animations:^(){
                         [self.notesText setContentOffset:CGPointZero];
                         [self layoutIfNeeded];
                     }];
    if ([l_enteredText length]==0)
    {
        textView.text = @"Enter Notes Here....";
    }

}

@end
