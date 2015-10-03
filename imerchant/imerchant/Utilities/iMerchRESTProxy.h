//
//  iMerchRESTProxy.h
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iMerchDefaults.h"

@protocol iMerchDataProxyReceptionDelegate <NSObject>

- (void) proxyDataReceptionStarted;
- (void) proxyDataReceiving:(NSInteger) p_recdPerc;
- (void) proxyDataReceptionCompleted;

@end

@interface iMerchRESTProxy : NSObject

- (void) initProxyWithAPIType:(NSString*) p_apiType andInputParams:(NSDictionary*) p_prmDict andReturnMethod:(GENERICCALLBACK) p_returnMethod;
- (void) initProxyWithAPIType:(NSString*) p_apiType andInputParams:(NSDictionary*) p_prmDict andReturnMethod:(GENERICCALLBACK) p_returnMethod withReceptionDelegate:(id<iMerchDataProxyReceptionDelegate>) p_receptionDelegate;
@end
