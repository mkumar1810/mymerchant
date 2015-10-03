//
//  iMerchMerchantOptions.m
//  imerchant
//
//  Created by Mohan Kumar on 18/06/15.
//  Copyright (c) 2015 iMerchant Systems. All rights reserved.
//

#import "iMerchMerchantOptions.h"
#import "iMerchDefaults.h"

@interface iMerchMerchantOptions()<UITableViewDataSource, UITableViewDelegate>
{
    id<iMerchMerchantOptionsDelegate> _dataDelegate;
    UITableView * _optionsView;
    CGFloat _rowHeight;
    CGRect _originalFrame;
    CGPoint _superPoint;
    NSArray * _optionsList;
}

@end

@implementation iMerchMerchantOptions

- (instancetype) initWithFrame:(CGRect) p_frame andSuperPoint:(CGPoint) p_superPoint dataDelegate:(id<iMerchMerchantOptionsDelegate>) p_dataDelegate
{
    self = [super init];
    if (self)
    {
        _dataDelegate = p_dataDelegate;
        _rowHeight = 36.0f;
        _originalFrame = p_frame;
        _superPoint = p_superPoint;
        [self setBackgroundColor:[UIColor clearColor]];
        _optionsList = @[@"Add Notes",@"Send EMail",@"Change Status"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * l_polygonpath = [UIBezierPath bezierPath];
    [l_polygonpath moveToPoint:CGPointMake(rect.size.width, 0.0f)];
    [l_polygonpath addLineToPoint:CGPointMake(rect.size.width-30.0, 60.0f)];
    [l_polygonpath addLineToPoint:CGPointMake(rect.size.width-30.0, rect.size.height-20.0)];
    [l_polygonpath addArcWithCenter:CGPointMake(rect.size.width - 50.0, rect.size.height-20.0) radius:20.0f startAngle:0.0 endAngle:M_PI_2 clockwise:YES];
    [l_polygonpath addArcWithCenter:CGPointMake(50.0, rect.size.height-20.0) radius:20.0 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    //[l_polygonpath addLineToPoint:CGPointMake(30.0f, rect.size.height)];
    //[l_polygonpath addLineToPoint:CGPointMake(30.0f, 30.0f)];
    [l_polygonpath addArcWithCenter:CGPointMake(50.0, 50.0) radius:20.0 startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    [l_polygonpath addLineToPoint:CGPointMake(rect.size.width-60.0, 30.0f)];
    [l_polygonpath closePath];
    [[UIColor colorWithRed:0.3 green:0.5 blue:0.7 alpha:1.0] setFill];
    [l_polygonpath fill];
    [self createOptionListTableView:rect];
}

- (void) createOptionListTableView:(CGRect) p_reqdRect
{
    
    _optionsView = [[UITableView alloc] initWithFrame:
                    CGRectMake(30.0f, 30.0f, p_reqdRect.size.width-60.0, 110.0f)
                                                style:UITableViewStylePlain];
    if ([_optionsView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_optionsView setSeparatorInset:UIEdgeInsetsZero];
    }
    _optionsView.showsVerticalScrollIndicator = YES;
    _optionsView.showsHorizontalScrollIndicator = NO;
    _optionsView.backgroundColor = [UIColor clearColor];
    _optionsView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _optionsView.separatorColor = [UIColor clearColor];
    [_optionsView setScrollEnabled:NO];
    [_optionsView setDelegate:self];
    [_optionsView setDataSource:self];
    [self addSubview:_optionsView];
}



#pragma delegates for table view  option and branches table view delegates

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * l_optioncellid = @"optioncell";
    UILabel * l_lbloption;
    UITableViewCell * l_newcell = [tableView dequeueReusableCellWithIdentifier:l_optioncellid];
    if (!l_newcell)
    {
        l_newcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:l_optioncellid];
        l_lbloption = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, _optionsView.frame.size.width-10.0, _rowHeight - 2.0f)];
        [l_lbloption setBackgroundColor:[UIColor clearColor]];
        [l_lbloption setTextColor:[UIColor whiteColor]];
        [l_lbloption setTextAlignment:NSTextAlignmentCenter];
        l_lbloption.font = [UIFont boldSystemFontOfSize:16.0f];
        l_lbloption.numberOfLines= 0;
        l_lbloption.tag = 101;
        [l_newcell setBackgroundColor:[UIColor clearColor]];
        [l_newcell.contentView addSubview:l_lbloption];
        [l_newcell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    else
        l_lbloption = (UILabel*) [l_newcell.contentView viewWithTag:101];
    l_lbloption.text = [_optionsList objectAtIndex:indexPath.row];
    return l_newcell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_optionsList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * l_selcell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel * l_lblcontent = (UILabel*) [l_selcell.contentView viewWithTag:101];
    CGRect l_startRect = [l_lblcontent convertRect:l_lblcontent.bounds toView:self];
    [UIView animateWithDuration:0.2
                     animations:^{
                         l_lblcontent.textColor = [UIColor brownColor];
                         l_lblcontent.transform = CGAffineTransformMakeScale(0.90, 0.90);
                     }
                     completion:^(BOOL p_finished){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              l_lblcontent.transform = CGAffineTransformMakeScale(1.10, 1.10);
                                          }
                                          completion:^(BOOL p_finished){
                                              //l_lblcontent.transform = CGAffineTransformIdentity;
                                              switch (indexPath.row) {
                                                  case 0:
                                                      [_dataDelegate addNewNotesToTheMerchant];
                                                      break;
                                                  case 1:
                                                      [_dataDelegate sendEMailAfterUnloadingPopupToLeadFromFrame:l_startRect ofView:self];
                                                      break;
                                                  case 2:
                                                      [_dataDelegate showStatusChangeScreen];
                                                      break;
                                                  default:
                                                      break;
                                              }
                                          }];
                     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
