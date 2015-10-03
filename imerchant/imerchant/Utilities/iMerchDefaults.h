//
//  iMerchDefaults.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define MAIN_API_HOST_URL  @"http://74.208.102.212/imerchantapi/v1/processapi.aspx"
#define MAIN_API_HOST_URL  @"http://crm1.iadvancenow.com/imerchantapi/v1/processapi.aspx"
#define PDF_TOP_MARGIN     20
#define PDF_LEFT_MARGIN   20
#define PAGINATION_RECS     200
#define INACTIVITY_SECONDS  5  // 5 MINUTES
#define IOS_VERSION_NO @"20.6.1"

typedef enum {
    noanimation,
    //horizontal,
    horizontalWithoutBounce,
    //vertical,
    popOutVerticalOpen,
    horizontalWithBounce,
    //pageCurlFromright
} TransitionType;

typedef void (^NOPARAMCALLBACK) ();
typedef void (^DICTIONARYCALLBACK) (NSDictionary*);
typedef void (^ARRAYCALLBACK) (NSArray*);
typedef void (^GENERICCALLBACK) (id);
typedef void (^STRINGCALLBACK) (NSString *);

@protocol iMerchCustNaviDelegates <NSObject>

@property (nonatomic) TransitionType transitionType;
@property (nonatomic,retain) NSDictionary * navigateParams;

@optional

- (void) pushAnimation:(TransitionType) p_pushAnimationType;
- (void) popAnimation:(TransitionType) p_popAnimationType;
- (void) popAnimationCompleted;
- (void) pushanimationCompleted;
- (CGRect) getPopOutFrame;
- (UIImage*) getPopOutTopImage;
- (UIImage*) getPopOutBottomImage;
- (UIImage*) getPopOutImage;
- (void) initializeDataWithParams:(NSDictionary*) p_initParams;

@end

@interface iMerchDefaults : NSObject

+ (UILabel*) getStandardLabelWithText:(NSString*) p_lblText;
+ (UITextField*) getStandardTextField;
+ (UIButton*) getStandardButton;
+ (UIButton*) getStandardButtonWithText:(NSString*) p_btnText;

+ (UIColor*) getDefaultTextColor;

@end
