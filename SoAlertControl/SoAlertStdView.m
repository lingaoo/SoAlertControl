//
//  SoAlertStandView.m
//  UCSDemo
//
//  Created by soso on 16/10/31.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import "SoAlertStdView.h"

@implementation SoAlertStdView

+(instancetype)soAlertStandViewWithFrame:(CGRect)frame andTitle:(NSString*)titleStr andMessage:(NSString*)messageStr{
    SoAlertStdView *stdView = [[SoAlertStdView alloc]initWithFrame:frame];
    CGRect frameN = frame;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:(CGRect){20,20,frame.size.width - 40,30}];
    titleLabel.font     = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment     = NSTextAlignmentCenter;
    stdView.alertTitleLabel = titleLabel;
    stdView.alertTitleLabel.text = titleStr;
    
    if(![titleStr isKindOfClass:[NSString class]] || [titleStr isEqualToString:@""]) {
        frameN.size.height -= 50;
        titleLabel.hidden = YES;
    }else {
        titleLabel.hidden = NO;
        [stdView addSubview:titleLabel];
    }
 
    if(![messageStr isKindOfClass:[NSString class]] || [messageStr isEqualToString:@""]) {
        messageStr = @"";
    }

    stdView.backgroundColor    = [UIColor whiteColor];
    stdView.layer.cornerRadius = 8.0f;
    NSDictionary *attribute    = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [messageStr boundingRectWithSize:CGSizeMake(frameN.size.width - 40, MAXFLOAT)
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:attribute context:nil].size;
    UILabel *message = [[UILabel alloc]initWithFrame:(CGRect){20,!titleLabel.hidden?60:20,frameN.size.width - 40,15+size.height}];
    frameN.size.height += (size.height - 15);
    stdView.frame  = frameN;
    CGPoint point  = CGPointMake(message.center.x,frameN.size.height/2.0 - (!titleLabel.hidden?10:25));
    message.center = point;
    message.font   = [UIFont systemFontOfSize:15.0f];
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    stdView.alertMessageLabel      = message;
    stdView.alertMessageLabel.text = messageStr;
    [stdView addSubview:message];
    return stdView;
}
@end


