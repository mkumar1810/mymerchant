//
//  iMerchGenPrintPreview.h
//  iMerchant
//
//  Created by Mohan Kumar on 11/02/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iMerchGenPrintPreviewDelegate <NSObject>

- (void) previewReportGenerated;

@end

@interface iMerchGenPrintPreview : UIScrollView

@property (nonatomic,retain) UIWebView * printWebView;
@property (nonatomic,retain) NSArray * frameConstraints;
@property (nonatomic,retain) NSString * fileName;
@property (nonatomic,retain) NSString * reportName;

- (instancetype) initWithFileName:(NSString*) p_fileName andReportType:(NSString*) p_reportType;
- (IBAction) printContentsFromBarButton:(UIBarButtonItem*) p_printButton;
- (void) startZoomingOfView;
- (void) resizeToScale:(CGFloat) p_resizeScale;
- (void) makeZoomingConcluded;
@end
