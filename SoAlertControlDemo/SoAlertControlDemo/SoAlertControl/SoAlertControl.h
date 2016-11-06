//
//  SoAlertView.h
//  UCSDemo
//
//  Created by soso on 16/9/7.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoAlertControl : UIControl
/// 显示状态
@property (nonatomic,assign) BOOL isVisiable;
/// 与-show方法相同
@property (nonatomic,copy) void(^showView)();
/*
 eg.
    [[SoAlertControl soAlertViewWithTitle:@"确业" andMessage:@"dfjjjdfjdskk" clickOK:^(SoAlertControl *soAlertView) {
        [soAlertView dismiss];
    }] addButtontitle:@"去刀" click:^(SoAlertControl *soAlertView) {
        [soAlertView dismiss];
    }].showView();
 */
/** 无按钮 */
+(instancetype)soAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
/** 带'确定'按钮 */
+(instancetype)soAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message clickOK:(void(^)(SoAlertControl *soAlertView))clickBlock;

/** 添加按钮 */
-(instancetype)addButtontitle:(NSString *)buttonTitle click:(void(^)(SoAlertControl *soAlertView))clickBlock ;
/** 添加按钮 button样式可设置 */
-(instancetype)addButtonConfig:(void(^)(UIButton *btn))buttonConfig click:(void(^)(SoAlertControl *soAlertView))clickBlock;

-(void)show;
-(void)dismiss;
-(void)showComplete:(void(^)(void))complete;
-(void)dismissComplete:(void(^)(void))complete;

// ==================== 自定义 ===========================
/** 
    自定义View
    eg. [[SoAlertControl soAlertCustomView] show];
 */
+(instancetype)soAlertCustomView;

@end
