//
//  MyXIBAlertView.h
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/8/1.
//  Copyright © 2018年 lingaoo. All rights reserved.
// asdfas df

#import <UIKit/UIKit.h>
#import "SoAlertView.h"

@interface MyXIBAlertView : SoAlertView

@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
@property (weak, nonatomic) IBOutlet UIButton *buttonCanel;

+(instancetype)alertViewXIB;

@end
