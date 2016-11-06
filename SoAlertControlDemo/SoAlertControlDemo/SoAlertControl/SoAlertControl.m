//
//  SoAlertView.m
//  UCSDemo
//
//  Created by soso on 16/9/7.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import "SoAlertControl.h"
#import <Accelerate/Accelerate.h>
#import "SoAlertCustomView.h"
#import "SoAlertStdView.h"

#pragma mark - SoAlertViewShare
@interface SoAlertViewShare : NSObject
@property (nonatomic,strong)SoAlertControl *alertView;
@property (nonatomic,strong)NSMutableArray *alerts;
@property (nonatomic,assign)BOOL isVisiable;

+(instancetype)shareInstance;

@end

@implementation SoAlertViewShare
-(NSMutableArray*)alerts {
    _alerts = _alerts ?:[NSMutableArray array];
    return _alerts;
}
+(instancetype)shareInstance {
    static SoAlertViewShare *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SoAlertViewShare alloc]init];
    });
    return share;
}

@end

#pragma mark - SoAlertViewBg
@interface SoAlertViewBg : UIView
@property (nonatomic, strong) UIImageView *screenShotView;
@end

@interface SoAlertViewBg ()

@end
@implementation SoAlertViewBg

-(instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    [self grayLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addScreenShot {
    UIWindow *screenWindow = [UIApplication sharedApplication].windows.firstObject;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *originalImage = nil;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)) {
        originalImage = viewImage;
    } else {
        originalImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460))];
    }
    self.screenShotView = [[UIImageView alloc] initWithImage:originalImage];
    [self addSubview:self.screenShotView];
}

-(void)grayLayer {
    UIView *grayView = [[UIView alloc]initWithFrame:self.frame];
    grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    [self addSubview:grayView];
}
#pragma mark- 键盘监听的通知执行方法
- (void)keyboardWasShown:(NSNotification*)aNotification {
    double animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint aRect = self.center;
    CGFloat offset = kbSize.height*0.4;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.center=CGPointMake(aRect.x, aRect.y-offset);
    } completion:NULL];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    double animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGPoint aRect = self.center;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.center=aRect;
    } completion:NULL];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end

#pragma mark - SoAlertControl
@interface SoAlertControl ()
@property (nonatomic,strong)NSMutableArray *buttons;
@property (nonatomic,strong)NSMutableArray *buttonsBlock;
@property (nonatomic,strong)SoAlertViewBg *bgView;
@property (nonatomic,strong)UIView *contentView;
@end
@implementation SoAlertControl

#pragma mark - set && get
-(NSMutableArray *)buttons {
    _buttons = _buttons?:[NSMutableArray array];
    return _buttons;
}
-(NSMutableArray *)buttonsBlock {
    _buttonsBlock = _buttonsBlock?:[NSMutableArray array];
    return _buttonsBlock;
}
-(BOOL)isVisiable {
    return [SoAlertViewShare shareInstance].isVisiable;
}
-(void)setIsVisiable:(BOOL)isVisiable {
    [SoAlertViewShare shareInstance].isVisiable = isVisiable;
}
#pragma mark - AlertView 初始化
// 自定义
+(instancetype)soAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    SoAlertControl *alertView = [SoAlertControl soAlertViewWithFrame:UIScreen.mainScreen.bounds];
    __weak typeof(alertView) weakView = alertView;
    alertView.showView = ^{[weakView show];};
    CGRect frame = (CGRect){20,0,[UIScreen mainScreen].bounds.size.width - 40,[UIScreen mainScreen].bounds.size.width/1.5 - 40/1.5};
    [alertView alertViewAddSubContentViewFrame:frame andTitle:title andMessage:message];
    if([SoAlertViewShare shareInstance].isVisiable) {
        [[SoAlertViewShare shareInstance].alerts addObject:alertView];
    }
    return alertView;
}
+(instancetype)soAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message clickOK:(void (^)(SoAlertControl *soAlertView))clickBlock {
    SoAlertControl *alertView = [SoAlertControl soAlertViewWithTitle:title andMessage:message];
    [alertView addButtontitle:@"确定" click:clickBlock];
    return alertView;
}
+(instancetype)soAlertViewWithFrame:(CGRect)frame {
    SoAlertControl *alertView = [[SoAlertControl alloc]init];
    alertView.bgView = [[SoAlertViewBg alloc]init];
     alertView.center = alertView.bgView.center;
    [alertView.bgView addSubview:alertView];
    return alertView;
}
-(instancetype)addButtontitle:(NSString *)buttonTitle click:(void (^)(SoAlertControl *))clickBlock {
    if(self.buttons.count>=3 || self.contentView == nil || [UIApplication sharedApplication].keyWindow ==nil) {
        NSLog(@"\n *注意:可能有以下错误*\n 1.请使用-soAlertViewWith..方法初始化(自定义除外) \n 2.最多三个按钮，超过推荐使用UIActionSheet\n 3.AppDelegate 未初始化完成。请延迟执行");
        return self;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 10.f;
    btn.layer.borderWidth  = 0.6f;
    btn.tag = 9000 + self.buttons.count;
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [self.buttons addObject:btn];
    [self.buttonsBlock addObject:clickBlock];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    for(NSInteger i = 0;i<self.buttons.count;i++) {
        NSInteger btnCount = self.buttons.count > 3?3:self.buttons.count;
        UIButton *bton = self.buttons[i];
        bton.frame = CGRectMake(16 + (self.contentView.bounds.size.width - 16) / btnCount * i , self.contentView.bounds.size.height - 60 ,(self.contentView.bounds.size.width - 16) / btnCount - 16 , 44);
    }
    return self;
}
-(instancetype)addButtonConfig:(void (^)(UIButton *))buttonConfig click:(void (^)(SoAlertControl *))clickBlock {
    [self addButtontitle:@"" click:clickBlock];
    if(buttonConfig) buttonConfig(self.buttons.lastObject);
    return self;
}
-(void)clickOneButton:(UIButton *)sender {
    if(self.buttonsBlock[sender.tag - 9000])
        ((void(^)(SoAlertControl *soAlertView))self.buttonsBlock[sender.tag - 9000])(self);
}
/// ContentView
-(SoAlertStdView *)alertViewAddSubContentViewFrame:(CGRect)frame andTitle:(NSString *)title andMessage:(NSString *)message{
    SoAlertStdView *standView = [SoAlertStdView soAlertStandViewWithFrame:frame andTitle:title andMessage:message];
    standView.center = self.bgView.center;
    [self.bgView addSubview:standView];
    self.contentView = standView;
    return standView;
}
#pragma mark - Animation
-(void)show {
    [self showComplete:nil];
}
-(void)dismiss {
    [self dismissComplete:nil];
}
-(void)showComplete:(void (^)(void))complete {
    if(self.contentView == nil || [UIApplication sharedApplication].keyWindow == nil) {
        NSLog(@"\n *注意:可能有以下错误*\n 1.请使用-soAlertViewWith..方法初始化(自定义除外)\n 2.AppDelegate 未初始化完成。请延迟执行");
        return;
    }
    
    if(self.isVisiable) return;
    
    if([SoAlertViewShare shareInstance].alerts.count > 0)
        [[SoAlertViewShare shareInstance].alerts removeObjectAtIndex:0];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.bgView];
    self.isVisiable = YES;
    self.contentView.transform = CGAffineTransformMakeScale(1.2,1.2);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1,1);
    } completion:^(BOOL finished) {
        self.isVisiable = YES;
        if(complete) complete();
    }];
}
-(void)dismissComplete:(void (^)(void))complete {
    [UIView animateWithDuration:0.2  animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        self.isVisiable = NO;
        if(complete) complete();
        if ([SoAlertViewShare shareInstance].alerts.count > 0) {
            SoAlertControl *soAlert = [SoAlertViewShare shareInstance].alerts[0];
            [soAlert show];
        }
    }];
}
/// 自定义
+(instancetype)soAlertCustomView {
    SoAlertControl *alertView = [SoAlertControl soAlertViewWithFrame:UIScreen.mainScreen.bounds];
    SoAlertCustomView *customView = [SoAlertCustomView customAlertView];
    customView.clickClose = ^(){[alertView dismiss];};
    __weak typeof(alertView) weakSelf = alertView;
    alertView.showView = ^(){[weakSelf dismiss];};
    [alertView.bgView addSubview:customView];
    alertView.contentView = customView;
    if([SoAlertViewShare shareInstance].isVisiable)
        [[SoAlertViewShare shareInstance].alerts addObject:alertView];
    return alertView;
}
@end
