//
//  MyAlertView.h
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/6/21.
//  Copyright © 2018年 lingaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoAlertView.h"

@interface MyAlertView : SoAlertView


+(instancetype)alertViewWithTitle:(NSString *)titleString Message:(NSString *)msgString;

/// 单个按钮
-(void)addButtonTitle:(NSString *)title
                click:(void (^)(SoAlertView *alertView,UIButton *button))clickBlock;

/// 两个按钮
-(void)addButtonLeft:(NSString *)leftTile
               right:(NSString *)rightTitle
           leftBlock:(void (^)(SoAlertView *alertView,UIButton *button))clickleftBlock
          rightBlock:(void (^)(SoAlertView *alertView,UIButton *button))clickrightBlock;


@end
