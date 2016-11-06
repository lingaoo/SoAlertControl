//
//  SoAlertStandView.h
//  UCSDemo
//
//  Created by soso on 16/10/31.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SoAlertStdView : UIView

@property (weak, nonatomic) UILabel *alertTitleLabel;
@property (weak, nonatomic) UILabel *alertMessageLabel;

+(instancetype)soAlertStandViewWithFrame:(CGRect)frame andTitle:(NSString*)titleStr andMessage:(NSString*)messageStr;

@end
