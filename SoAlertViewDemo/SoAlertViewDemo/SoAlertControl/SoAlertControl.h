//
//  SoAlertControl.h
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SoAlertControl : UIControl
{

}

typedef void(^AnimationCompleteBlock)(void);
typedef void(^CompletionBlock)(SoAlertControl *control);
typedef void(^ContraintBlock)(SoAlertControl *control);
typedef void(^AnimationBlock)(SoAlertControl *control,AnimationCompleteBlock animationComplete);

/// SoAlertBgView
@property (nonatomic,strong)UIView *bgView;
/// 继承SoAlertView 自定义
@property (nonatomic,strong)UIView *contentView;
/// 显示动画 (结束必需回调 animationComplete Block)
@property (nonatomic, copy) AnimationBlock animationShowBlock;
/// 消动动画 (结束必需回调 animationComplete Block)
@property (nonatomic, copy) AnimationBlock animationDismissBlock;
/// 修改约束 （主要修改contentView的约束）
@property (nonatomic, copy) ContraintBlock contraintBlock;
/// contentView的约束
@property (nonatomic, copy) NSArray *contentViewContraints;

@end

#pragma mark - SoAlertViewManager

// alert 显示顺序
#define KK_ALERTCONTROL_STACK NO

typedef enum : NSUInteger {
    SoAlertControlStack = 0,  // 先进先显示
    SoAlertControlHeap = 1,  //  后进先显示
} SoAlertControlType;

@interface SoAlertViewManager : NSObject
/// 当前alertControl
@property (nonatomic,strong)SoAlertControl *alertControl;
/// alert 队列
@property (nonatomic,strong)NSMutableArray *alertQueue;
/// 是否在显示
@property (nonatomic,assign)BOOL isVisiable;
/// 显示规则
@property (nonatomic,assign)SoAlertControlType controlType;

+ (instancetype)shareInstance;

@end








