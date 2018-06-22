//
//  SoAlertControl.m
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import "SoAlertControl.h"
#import <Accelerate/Accelerate.h>
#import "SoAlertBgView.h"
@interface SoAlertViewManager ()

@end;

@implementation SoAlertViewManager

-(NSMutableArray*)alertQueue {
    _alertQueue = _alertQueue ?:[NSMutableArray array];
    return _alertQueue;
}
+(instancetype)shareInstance {
    static SoAlertViewManager *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SoAlertViewManager alloc]init];
        share.controlType = KK_ALERTCONTROL_STACK ? SoAlertControlStack:SoAlertControlHeap;        
    });
    return share;
}

@end

#pragma mark - SoAlertControl
@interface SoAlertControl ()

@property (nonatomic, strong) UIWindow *window;

/// 显示状态 同(SoAlertViewManager)
@property (nonatomic,assign)BOOL isVisiable;

@end

@implementation SoAlertControl


#pragma mark - set && get
-(BOOL)isVisiable {
    return [SoAlertViewManager shareInstance].isVisiable;
}
-(void)setIsVisiable:(BOOL)isVisiable {
    [SoAlertViewManager shareInstance].isVisiable = isVisiable;
}
-(void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.bgView.center;
    [self.bgView addSubview:contentView];
    if([[SoAlertViewManager shareInstance].alertQueue indexOfObject:self] != NSNotFound && [SoAlertViewManager shareInstance].alertControl != self){
        [[SoAlertViewManager shareInstance].alertQueue removeObject:self];
    }
}
-(UIView *)bgView {
    if(_bgView) return _bgView;
    SoAlertBgView *bgView = [[SoAlertBgView alloc]init];
    self.center = bgView.center;
    self.bgView = bgView;
    return bgView;
}
-(UIWindow *)window {
    if(_window) return _window;
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelAlert - 1;
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    ///防止释放，显示完后  要手动设置为 nil
    _window = window;
    return _window;
}
+(instancetype)soAlertControl {
    SoAlertControl *alertControl = [[SoAlertControl alloc]init];
    return alertControl;
}



#pragma mark - Animation
-(void)show {
    [self showComplete:nil];
}
-(void)dismiss {
    [self dismissComplete:nil];
}
-(void)showComplete:(void (^)(void))complete {
    if([SoAlertViewManager shareInstance].controlType == SoAlertControlHeap) {
        if(self.isVisiable ) {
            SoAlertControl *alert = [SoAlertViewManager shareInstance].alertControl;
            if(alert == self) return;
            [[SoAlertViewManager shareInstance].alertQueue removeObject:alert];
            [[SoAlertViewManager shareInstance].alertQueue insertObject:alert atIndex:1];
            [alert dismissControlComplete:^{
                [self showComplete:complete];
            }];
            return;
        }
    }else {
        if(self.isVisiable) return;
    }
    
    [self.bgView addSubview:self.contentView];
    [self.window addSubview:self.bgView];

    self.isVisiable = YES;
    [SoAlertViewManager shareInstance].alertControl = self;
    self.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1,1);
        self.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isVisiable = YES;
        if(complete) complete();
    }];
}
-(void)dismissComplete:(void (^)(void))complete {
    [[SoAlertViewManager shareInstance].alertQueue removeObject:self];

    [UIView animateWithDuration:0.3  animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.9,0.9);
        self.contentView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        self.isVisiable = NO;
        if(complete) complete();
        if ([SoAlertViewManager shareInstance].alertQueue.count > 0) {
            SoAlertControl *soAlert = [SoAlertViewManager shareInstance].alertQueue.firstObject;
            [soAlert show];
        }else{
            [SoAlertViewManager shareInstance].alertControl = nil;
            [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {[obj removeFromSuperview];}];
            self.window.alpha = 0;
            self.window.hidden = YES;
            self.window = nil;
        }
    }];
}
-(void)dismissControlComplete:(void (^)(void))complete {
    [UIView animateWithDuration:0.3  animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
        self.contentView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        self.isVisiable = NO;
        if(complete) complete();
        if ([SoAlertViewManager shareInstance].alertQueue.count > 0) {
            SoAlertControl *soAlert = [SoAlertViewManager shareInstance].alertQueue.firstObject;
            [soAlert show];
        }else{
            [SoAlertViewManager shareInstance].alertControl = nil;
            [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {[obj removeFromSuperview];}];
            self.window.alpha = 0;
            self.window.hidden = YES;
            self.window = nil;
        }
    }];
}
@end
