//
//  iMerchBaseController.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMerchDefaults.h"

@interface iMerchBaseController : UIViewController <iMerchCustNaviDelegates>

@property (nonatomic,strong) UINavigationBar * navBar;
@property (nonatomic,strong) UINavigationItem * navItem;
@property (nonatomic) CGRect lastCellFrameForPopOut;
@property (nonatomic,strong) UILabel * lbl_prevtitle;
@property (nonatomic,strong) UIBarButtonItem * bar_back_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_prev_title_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_refresh_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_search_btn;
@property (nonatomic,strong) UIActivityIndicatorView * actView;
@property (nonatomic,strong) UIBarButtonItem * bar_logout_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_report_prev_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_printout_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_email_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_exitreport_btn;
@property (nonatomic,strong) UIBarButtonItem * bar_list_btn;

- (void) initializeData;
- (void) generateReportPreview;
- (void) makePrintOutOfReport;
- (void) sendShowingReportAsMail;
- (void) exitReportPreview;
- (void) performSearchOperation;
- (void) executeListButtonClicked;

@end
