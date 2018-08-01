//
//  MyXIBAlertView.m
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/8/1.
//  Copyright © 2018年 lingaoo. All rights reserved.
//

#import "MyXIBAlertView.h"

@implementation MyXIBAlertView


+(instancetype)alertViewXIB {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"MyXIBAlertView" owner:nil options:nil];

    return nibView.firstObject;
}


@end
