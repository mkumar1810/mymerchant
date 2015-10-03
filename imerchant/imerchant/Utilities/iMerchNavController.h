//
//  iMerchNavController.h
//  iMerchant
//
//  Created by Mohan Kumar on 10/03/15.
//  Copyright (c) 2015 iMerchant IT Products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMerchDefaults.h"

@interface iMerchNavController : UINavigationController<UINavigationControllerDelegate>

@end

@interface iMerchNavControllerTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype) initWithNavOperation:(UINavigationControllerOperation) p_navOperation;

@end
