//
//  iMerchBaseNavigatorSeque.m
//  imerchant
//
//  Created by Mohan Kumar on 02/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchBaseNavigatorSeque.h"
#import "iMerchBaseController.h"

@implementation iMerchBaseNavigatorSeque

- (instancetype) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        //
    }
    return self;
}

- (void) perform
{
    UIViewController * l_src = (UIViewController*) self.sourceViewController;
    UIViewController * l_dest = (UIViewController*) self.destinationViewController;
    if ([l_dest respondsToSelector:@selector(initializeDataWithParams:)])
    {
        id<iMerchCustNaviDelegates>  l_srcdlg = (id<iMerchCustNaviDelegates>) l_src;
        id<iMerchCustNaviDelegates>  l_destdlg = (id<iMerchCustNaviDelegates>) l_dest;
        [l_destdlg initializeDataWithParams:l_srcdlg.navigateParams];
    }
    [l_src.navigationController pushViewController:l_dest animated:YES];
}

@end
