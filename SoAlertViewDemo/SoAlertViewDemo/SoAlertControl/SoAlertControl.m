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
{
    
}
///
@property (nonatomic, strong) UIWindow *window;
/// 显示状态 同(SoAlertViewManager)
@property (nonatomic,assign)BOOL isVisiable;
///
@property (nonatomic, copy) AnimationBlock animationShowBlock;
///
@property (nonatomic, copy) AnimationBlock animationDismissBlock;
/// 修改约束 （主要修改contentView的约束）
@property (nonatomic, copy) ContraintBlock contraintBlock;


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
    [self autolayout];
    
    self.isVisiable = YES;
    [SoAlertViewManager shareInstance].alertControl = self;

    
    if(self.animationShowBlock) {
        __block AnimationCompleteBlock animatioCompleteBlock = ^{[self completionWithShow:complete];};
        self.animationShowBlock(self,animatioCompleteBlock);
        return;
    }
    
    self.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1,1);
            self.contentView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [self completionWithShow:complete];
    }];
}
-(void)dismissComplete:(void (^)(void))complete {
    [[SoAlertViewManager shareInstance].alertQueue removeObject:self];
    [self dismissControlComplete:complete];
}

-(void)dismissControlComplete:(void (^)(void))complete {
    if(self.animationDismissBlock) {
         AnimationCompleteBlock animatioCompleteBlock = ^{[self completionWithDismiss:complete];};
        self.animationDismissBlock(self,animatioCompleteBlock);
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [self animationDismissScale];
        } completion:^(BOOL finished) {
            [self completionWithDismiss:complete];
        }];
    }
}

-(void)animationDismissScale {
    self.contentView.transform = CGAffineTransformMakeScale(0.8,0.8);
    self.contentView.alpha = 0.5;
}

-(void)completionWithShow:(void (^)(void))complete {
    self.isVisiable = YES;
    if(complete) complete();
}

-(void)completionWithDismiss:(void (^)(void))complete {
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.isVisiable = NO;
    [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {[obj removeFromSuperview];}];
    self.window.alpha = 0;
    self.window.hidden = YES;
    self.window = nil;
    if(complete) complete();
    if ([SoAlertViewManager shareInstance].alertQueue.count > 0) {
        SoAlertControl *soAlert = [SoAlertViewManager shareInstance].alertQueue.firstObject;
        [soAlert show];
    }else{
        [SoAlertViewManager shareInstance].alertControl = nil;
    }
    
}
-(void)autolayout {
     self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.window attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.window addConstraint:rightConstraint];

    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.window attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.window addConstraint:leftConstraint];

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.window attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.window addConstraint:topConstraint];

    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.window attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.window addConstraint:bottomConstraint];

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0];
    [self.bgView addConstraint:widthConstraint];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.bgView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:120];
    [self.bgView addConstraint:heightConstraint];

    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.bgView addConstraint:centerXConstraint];

    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.bgView addConstraint:centerYConstraint];
    
    self.contentViewContraints = @[widthConstraint,heightConstraint,centerXConstraint,centerYConstraint];
   
    !self.contraintBlock?:self.contraintBlock(self);

    [self layoutIfNeeded];
}


@end














