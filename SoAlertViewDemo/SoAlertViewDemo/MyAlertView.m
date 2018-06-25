//
//  MyAlertView.m
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/6/21.
//  Copyright © 2018年 lingaoo. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView


+(instancetype)alertViewWithTitle:(NSString *)titleString Message:(NSString *)msgString {
    MyAlertView *myalertView = [MyAlertView alertView];
    myalertView.stringTitle = titleString;
    myalertView.stringMessage = msgString;
    return myalertView;
}


-(void)addButtonTitle:(NSString *)title click:(void (^)(SoAlertView *, UIButton *))clickBlock {
    __weak typeof(self) weakSelf = self;
    [self addLineView:nil];
    
    [self addButtonConfig:^(UIButton *button) {
        [weakSelf configOnlyButton:button corner:10];
        [button setTitle:title forState:UIControlStateNormal];
    } click:clickBlock];
    
}

-(void)addButtonLeft:(NSString *)leftTile right:(NSString *)rightTitle leftBlock:(void (^)(SoAlertView *, UIButton *))clickleftBlock rightBlock:(void (^)(SoAlertView *, UIButton *))clickrightBlock {
    __weak typeof(self) weakSelf = self;
    [self addButtonConfig:^(UIButton *button) {
        [weakSelf configLeftButton:button corner:10];
        [button setTitle:leftTile forState:UIControlStateNormal];
    } click:^(SoAlertView *alertView, UIButton *button) {
        [weakSelf dismiss];
    }];
    [self addButtonConfig:^(UIButton *button) {
        [weakSelf configRightButton:button corner:10];
        [button setTitle:rightTitle forState:UIControlStateNormal];
    } click:^(SoAlertView *alertView, UIButton *button) {
        [weakSelf dismiss];
    }];
    
    // 添加横线
    [self addLineView:^(UIView *lineView) {
        
    }];
    [self addLineView:^(UIView *lineView) {
        lineView.frame = CGRectMake(weakSelf.frame.size.width/2.0, weakSelf.frame.size.height - 48, 1.0/[UIScreen mainScreen].scale, 48);
    }];
    
}

@end
