//
//  iMerchRESTProxy.m
//  iMerchant
//
//  Created by Mohan Kumar on 28/01/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchRESTProxy.h"
#import "iMerchDefaults.h"

@interface iMerchRESTProxy()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSString * _responseType;
    NSMutableData * _webData;
    NSMutableDictionary * _inputParams;
    GENERICCALLBACK _proxyReturnMethod;
    NSInteger _expDataLength;
}

@property (nonatomic, weak) id<iMerchDataProxyReceptionDelegate> receptionDelegate;

- (void) generateData;

@end

@implementation iMerchRESTProxy

- (void) initProxyWithAPIType:(NSString*) p_apiType andInputParams:(NSDictionary*) p_prmDict andReturnMethod:(GENERICCALLBACK) p_returnMethod withReceptionDelegate:(id<iMerchDataProxyReceptionDelegate>) p_receptionDelegate
{
    self.receptionDelegate = p_receptionDelegate;
    [self initProxyWithAPIType:p_apiType andInputParams:p_prmDict andReturnMethod:p_returnMethod];
}

- (void) initProxyWithAPIType:(NSString*) p_apiType andInputParams:(NSDictionary*) p_prmDict andReturnMethod:(GENERICCALLBACK) p_returnMethod
{
    _responseType = p_apiType;
    _proxyReturnMethod = p_returnMethod;
    _inputParams = [[NSMutableDictionary alloc] init];
    if (p_prmDict)
    {
        [_inputParams addEntriesFromDictionary:p_prmDict];
    }
    NSString * l_iosversionno = IOS_VERSION_NO;
    [_inputParams setValue:l_iosversionno forKey:@"iosversion"];
    [self generateData];
}

- (void) generateData
{
    NSURL * l_url;
    NSMutableURLRequest * l_theRequest;
    NSURLConnection * l_theConnection;
    NSString * l_messagebody, * l_requesttype, * l_msglength, * l_apiaction;
    NSError * l_error;
    l_url =  [NSURL URLWithString:MAIN_API_HOST_URL];
    if ([_responseType isEqualToString:@"LOGIN"])
    {
        l_apiaction = @"authenticateuser";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETSTATUSES"])
    {
        l_apiaction = @"getstatuses";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETBRANCHES"])
    {
        l_apiaction = @"getbranches";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETUSERS"])
    {
        l_apiaction = @"getusers";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETBUSINESSES"])
    {
        l_apiaction = @"getbusineseses";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETBUSINESSESPAGINATED"])
    {
        l_apiaction = @"getbusinesesespaginated";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETMERCHANTSEARCHPAGINATED"])
    {
        l_apiaction = @"getmerchsearchpaginated";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETMERCHANTSEARCH"])
    {
        l_apiaction = @"getsearchmerchants";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETNOTES"])
    {
        l_apiaction = @"getnotes";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"ADDNOTES"])
    {
        l_apiaction = @"addnotes";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"SENDEMAIL"])
    {
        l_apiaction = @"sendemail";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"FUNDINGRPT"])
    {
        l_apiaction = @"fundingrpt";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"REPORT_MAIL"])
    {
        l_apiaction = @"reportmail";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETSEARCHOPTIONS"])
    {
        l_apiaction = @"getsearchoptions";
        l_requesttype = @"POST";
    }
    else if ([_responseType isEqualToString:@"GETALLOWEDSTATUSES"])
    {
        l_apiaction = @"getallowedstatuses";
        l_requesttype = @"POST";
    }
    else //if ([_responseType isEqualToString:@"CHANGMERCHANTSTATUS"])
    {
        l_apiaction = [_responseType lowercaseString];
        l_requesttype = @"POST";
    }
    
    l_theRequest = [NSMutableURLRequest requestWithURL:l_url];
    [l_theRequest addValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [l_theRequest setHTTPMethod:l_requesttype];
    if ([l_requesttype isEqualToString:@"POST"])
    {
        NSData * l_passdata = [NSJSONSerialization dataWithJSONObject:_inputParams options:kNilOptions error:&l_error];
        if (l_error!=nil) {
            _proxyReturnMethod(@{@"error":@(1),@"errmsg":[l_error description]});
            return;
        }
        l_messagebody = [[NSString alloc] initWithData:l_passdata encoding:NSUTF8StringEncoding];
        l_msglength = [NSString stringWithFormat:@"%ld",(unsigned long) [l_messagebody length]];
        [l_theRequest addValue:l_msglength forHTTPHeaderField:@"Content-Length"];
        [l_theRequest addValue:l_apiaction forHTTPHeaderField:@"api-action"];
        [l_theRequest setHTTPBody:[l_messagebody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    l_theConnection = [[NSURLConnection alloc] initWithRequest:l_theRequest delegate:self];
    if (l_theConnection)
        _webData = [[NSMutableData data] init];
    else
        _proxyReturnMethod(@{@"error":@(1),@"errmsg":@"Error in connection"});
}

#pragma url connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_webData setLength:0];
    if (self.receptionDelegate)
    {
        NSHTTPURLResponse * l_httpresponse = (NSHTTPURLResponse*) response;
        _expDataLength = [[[l_httpresponse allHeaderFields] valueForKey:@"contentlength"] integerValue];
        [self.receptionDelegate proxyDataReceptionStarted];
        //NSLog(@"the expected length is %d", _expDataLength);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /*if ([_responseType isEqualToString:@"GETBUSINESSESPAGINATED"])
    {
        NSLog(@"the received string is %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }*/
    [_webData appendData:data];
    if (self.receptionDelegate)
    {
        //NSLog(@"the web data received length is %d", [[[NSString alloc] initWithData:_webData encoding:NSUTF8StringEncoding] length] );
        NSInteger l_downloadPerc = [[[NSString alloc] initWithData:_webData encoding:NSUTF8StringEncoding] length] * 100.0 / _expDataLength;
        [self.receptionDelegate proxyDataReceiving:l_downloadPerc];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _proxyReturnMethod(@{@"error":@(0),@"returndata":_webData});
    if (self.receptionDelegate)
    {
        [self.receptionDelegate proxyDataReceptionCompleted];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _proxyReturnMethod(@{@"error":@(1),@"errmsg":[error description]});
    if (self.receptionDelegate)
    {
        [self.receptionDelegate proxyDataReceptionCompleted];
    }
}

@end
