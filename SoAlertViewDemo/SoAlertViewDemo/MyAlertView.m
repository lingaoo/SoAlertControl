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
    
    myalertView.animationDismissBlock = ^(SoAlertControl *control,AnimationCompleteBlock animationComplete) {
        [UIView animateWithDuration:.3 animations:^{
            control.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
            control.contentView.alpha = 0.5;
        }completion:^(BOOL finished) {
            animationComplete();
        }];
    };
    
    myalertView.animationShowBlock = ^(SoAlertControl *control,AnimationCompleteBlock animationComplete) {
        control.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
            control.contentView.transform = CGAffineTransformMakeScale(1,1);
            control.contentView.alpha = 1;
        } completion:^(BOOL finished) {
            animationComplete();
        }];
    };
    
    myalertView.stringTitle = titleString;
    myalertView.stringMessage = msgString;
    return myalertView;
}


-(void)addButtonTitle:(NSString *)title click:(void (^)(SoAlertView *, UIButton *))clickBlock {
    __weak typeof(self) weakSelf = self;
    [self addLineView:^(UIView *lineView) {
        [weakSelf configCenterLineView:lineView];
    }];
    
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
        [weakSelf configCenterLineView:lineView];
    }];
    [self addLineView:^(UIView *lineView) {
        [weakSelf configButtonLineView:lineView];
    }];
    
}
-(void)dealloc {
    NSLog(@"qweqweweqwe");
}

@end
