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

/// 所有alert统一显示 SoAlertBgView
@property (nonatomic,strong)UIView *bgView;

/// 继承SoAlertView 自定义
@property (nonatomic,strong)UIView *contentView;

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

@property (nonatomic,assign)BOOL isVisiable;

@property (nonatomic,assign)SoAlertControlType controlType;

+(instancetype)shareInstance;

@end








