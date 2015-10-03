//
//  iMerchGenPrintPreview.m
//  iMerchant
//
//  Created by Mohan Kumar on 11/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import "iMerchGenPrintPreview.h"
#import "iMerchGenPrintRenderer.h"
#import "iMerchCommonUtilities.h"

@interface iMerchGenPrintPreview()<UIWebViewDelegate>
{
    //NSString * _fileName;
    NSString * _rptType;
    CGSize _basicStartSize;
    UIImageView * _imgPrintPreview;
    NSArray * _wvWidthConstraint;
}

@property (nonatomic,strong) UIActivityIndicatorView * actView;

@end

@implementation iMerchGenPrintPreview

- (instancetype) initWithFileName:(NSString*) p_fileName andReportType:(NSString*) p_reportType
{
    self = [super init];
    if (self)
    {
        _fileName = p_fileName;
        _rptType = p_reportType;
        //self.delegate = self;
        self.printWebView = [UIWebView new];
        self.printWebView.delegate = self;
        [self loadReportToView];
        [self setBackgroundColor:[UIColor whiteColor]];
        if ([_rptType isEqualToString:@"FRADMIN"]==YES)
        {
            _reportName = @"Funding Report(Admin)";
        }
        else if ([_rptType isEqualToString:@"FRBRANCH"]==YES)
        {
            _reportName = @"Funding Report(Branch)";
        }
        else if ([_rptType isEqualToString:@"FRUSER"]==YES)
        {
            _reportName = @"Funding Report(Salesman)";
        }
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.printWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.printWebView];
    _wvWidthConstraint = @[[NSLayoutConstraint constraintWithItem:self.printWebView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[printview]" options:0 metrics:nil views:@{@"printview":self.printWebView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[printview]" options:0 metrics:nil views:@{@"printview":self.printWebView}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.printWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraints:_wvWidthConstraint];

    self.actView = [UIActivityIndicatorView new];
    [self.actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.actView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actView];
    self.actView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    [self.actView setHidesWhenStopped:YES];
    [self.actView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[actview(20)]" options:0 metrics:nil views:@{@"actview":self.actView}]];
    [self.actView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actview(20)]" options:0 metrics:nil views:@{@"actview":self.actView}]];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.actView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:self.actView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:32.0]]];
    [self.actView startAnimating];
    [self layoutIfNeeded];
    _basicStartSize = self.printWebView.frame.size;
    NSLog(@"the printwebview rect is %@", NSStringFromCGRect(self.printWebView.frame));
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.actView stopAnimating];
    NSLog(@"the printwebview scrollview conten sise is %@", NSStringFromCGSize(self.printWebView.scrollView.contentSize));
}

- (void) loadReportToView
{
    [self.printWebView loadHTMLString:@"" baseURL:nil];
    NSURL * l_targetURL = [NSURL fileURLWithPath:_fileName];
    NSURLRequest * l_request = [NSURLRequest requestWithURL:l_targetURL];
    [self.printWebView loadRequest:l_request];
}

- (IBAction) printContentsFromBarButton:(UIBarButtonItem*) p_printButton
{
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
        }
    };
    
    
    // Obtain a printInfo so that we can set our printing defaults.
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // This application produces General content that contains color.
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    // We'll use the URL as the job name
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = _reportName;
    // Set duplex so that it is available if the printer supports it. We
    // are performing portrait printing so we want to duplex along the long edge.
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // Use this printInfo for this print job.
    controller.printInfo = printInfo;
    
    
    // Be sure the page range controls are present for documents of > 1 page.
    controller.showsPageRange = YES;
    
    // This code uses a custom UIPrintPageRenderer so that it can draw a header and footer.
    iMerchGenPrintRenderer *colnPrint = [[iMerchGenPrintRenderer alloc] init];
    // The MyPrintPageRenderer class provides a jobtitle that it will label each page with.
    colnPrint.jobTitle = printInfo.jobName;
    // To draw the content of each page, a UIViewPrintFormatter is used.
    UIViewPrintFormatter *viewFormatter = [self viewPrintFormatter];
    viewFormatter.startPage =0;
    
    
#if SIMPLE_LAYOUT
    /*
     For the simple layout we simply set the header and footer height to the height of the
     text box containing the text content, plus some padding.
     
     To do a layout that takes into account the paper size, we need to do that
     at a point where we know that size. The numberOfPages method of the UIPrintPageRenderer
     gets the paper size and can perform any calculations related to deciding header and
     footer size based on the paper size. We'll do that when we aren't doing the simple
     layout.
     */
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    CGSize titleSize = [colnPrint.jobTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                                               nil]];
    colnPrint.headerHeight = colnPrint.footerHeight = titleSize.height + HEADER_FOOTER_MARGIN_PADDING;
#endif
    [colnPrint addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = colnPrint;
    
    // The method we use presenting the printing UI depends on the type of
    // UI idiom that is currently executing. Once we invoke one of these methods
    // to present the printing UI, our application's direct involvement in printing
    // is complete. Our custom printPageRenderer will have its methods invoked at the
    // appropriate time by UIKit.
    [controller presentFromBarButtonItem:p_printButton
                                animated:YES
                       completionHandler:completionHandler];
}

//this method called during pinching gesture of report generator. the content web view is resized accordingly
CGFloat _resizedScale;
- (void) startZoomingOfView
{
    _imgPrintPreview = [[UIImageView alloc] initWithFrame:self.printWebView.frame];
    _imgPrintPreview.image = [iMerchCommonUtilities captureView:self.printWebView];
    [self insertSubview:_imgPrintPreview aboveSubview:self.printWebView];
    [self removeConstraints:_wvWidthConstraint];
    [self layoutIfNeeded];
    [self.printWebView setHidden:YES];
}

- (void) resizeToScale:(CGFloat) p_resizeScale
{
    if (p_resizeScale>1)
    {
        _resizedScale = p_resizeScale;
        CGAffineTransform l_reqdTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(_resizedScale, _resizedScale),CGAffineTransformMakeTranslation(_basicStartSize.width*(_resizedScale-1)/2.0, _basicStartSize.height*(_resizedScale-1)/2.0));
        _imgPrintPreview.transform = l_reqdTransform;
    }
    else
    {
        _resizedScale = 1;
        _imgPrintPreview.transform = CGAffineTransformIdentity;
    }
    _wvWidthConstraint = @[[NSLayoutConstraint constraintWithItem:self.printWebView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:_resizedScale constant:0.0]];
}

- (void) makeZoomingConcluded
{
    [self.printWebView setHidden:NO];
    [self addConstraints:_wvWidthConstraint];
    [_imgPrintPreview removeFromSuperview];
    _imgPrintPreview = nil;
    [self layoutIfNeeded];
    [self setScrollEnabled:YES];
    [self setContentSize:self.printWebView.frame.size];
    [self setShowsHorizontalScrollIndicator:YES];
}

@end
