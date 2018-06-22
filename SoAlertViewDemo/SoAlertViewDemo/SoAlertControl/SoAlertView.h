//
//  SoAlertView.h
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoAlertControl.h"

#define KK_LABELTITLE_FONT 18   // title 字体
#define KK_LABELMESSAGE_FONT 15 // message 字体

#define kMESSAGEHEIGHT 44   // message 高度
#define kTITLEHEIGHT 44     // title 高度
#define kBUTTONHEIGHT 48     // button 高度

// 继承 SoAlertView 自定义 MyAlertView

@interface SoAlertView : UIView
{
    
}
/// 设置labelTitle的title，labelTitle和SoAlertView并适应内容大小
@property (copy, nonatomic) NSString *stringTitle;

/// 设置labelMessage的title，labelMessage和SoAlertView并适应内容大小
@property (copy, nonatomic) NSString *stringMessage;

/// title
@property (strong, nonatomic) UILabel *labelTitle;
/// message
@property (strong, nonatomic) UILabel *labelMessage;

/**
 初始化
 */
+(instancetype)alertView;

/**
 显示 & 消失
 complet 动画结束时回调
 */
-(void)show;
-(void)dismiss;
-(void)showComplete:(void(^)(void))complete;
-(void)dismissComplete:(void(^)(void))complete;

/**
 添加Label
 @param labelConfig label
 */
-(void)addLabelOther:(void (^)(UILabel *label))labelConfig;

/**
 添加线点
 @param lineViewConfig lineView
 */
-(void)addLineView:(void (^)(UIView *lineView))lineViewConfig;

/**
 初始化 Button
 configOnlyButton:corner:底边按钮 corner(推荐值10)
 configLeftButton:corner:与configRightButton:corner:一般搭配使用一左一右。
 @param buttonConfig button设置
 @param clickBlock button点击
 */
-(void)addButtonConfig:(void (^)(UIButton *button))buttonConfig click:(void (^)(SoAlertView *alertView,UIButton *button))clickBlock;
-(void)configOnlyButton:(UIButton *)btn corner:(CGFloat)corner;
-(void)configLeftButton:(UIButton *)leftBtn corner:(CGFloat)corner;
-(void)configRightButton:(UIButton *)rightBtn corner:(CGFloat)corner;



@end

















