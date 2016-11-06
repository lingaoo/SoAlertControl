//
//  ViewController.m
//  SoAlertControlDemo
//
//  Created by soso on 16/11/6.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "ViewController.h"
#import "SoAlertControl.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)clickButton:(id)sender {
    
    [SoAlertControl soAlertViewWithTitle:@"第一个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
        NSLog(@"clicked");
        [soAlertView dismiss];
    }].showView();
    
    // 第二个会在第一个消失时弹出
    [[SoAlertControl soAlertViewWithTitle:@"第二个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
        NSLog(@"clicked");
        [soAlertView dismiss];
    }] addButtontitle:@"取消" click:^(SoAlertControl *soAlertView) {
        NSLog(@"clicked");
        [soAlertView dismiss];
    }].showView();
    
    // 同理
    SoAlertControl *alertView = [SoAlertControl soAlertViewWithTitle:@"第三个" andMessage:@"一个简单AlertControl"];
    [alertView addButtonConfig:^(UIButton *btn) {
        [btn setBackgroundColor:UIColor.grayColor];
        [btn setTitle:@"一" forState:UIControlStateNormal];
    } click:^(SoAlertControl *soAlertView) {
        NSLog(@"clicked");
        [soAlertView dismiss];
    }];
    [alertView addButtonConfig:^(UIButton *btn) {
        [btn setBackgroundColor:UIColor.cyanColor];
        [btn setTitle:@"二" forState:UIControlStateNormal];
    } click:^(SoAlertControl *soAlertView) {
        NSLog(@"clicked");
        [soAlertView dismiss];
    }];
    [alertView show];
    
    // 自定义
    [[SoAlertControl soAlertCustomView] show];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self test];
//    [self test1]; //错误示范
}

-(void)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SoAlertControl soAlertViewWithTitle:@"第一个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
            NSLog(@"clicked");
            [soAlertView dismiss];
        }].showView();
        
        // 第二个会在第一个消失时弹出
        [[SoAlertControl soAlertViewWithTitle:@"第二个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
            NSLog(@"clicked");
            [soAlertView dismiss];
        }] addButtontitle:@"取消" click:^(SoAlertControl *soAlertView) {
            NSLog(@"clicked");
            [soAlertView dismiss];
        }].showView();
        
        // 同理
        SoAlertControl *alertView = [SoAlertControl soAlertViewWithTitle:@"第三个" andMessage:@"一个简单AlertControl"];
        [alertView addButtonConfig:^(UIButton *btn) {
            [btn setBackgroundColor:UIColor.grayColor];
            [btn setTitle:@"一" forState:UIControlStateNormal];
        } click:^(SoAlertControl *soAlertView) {
            NSLog(@"clicked");
            [soAlertView dismiss];
        }];
        [alertView addButtonConfig:^(UIButton *btn) {
            [btn setBackgroundColor:UIColor.cyanColor];
            [btn setTitle:@"二" forState:UIControlStateNormal];
        } click:^(SoAlertControl *soAlertView) {
            NSLog(@"clicked");
            [soAlertView dismiss];
        }];
        [alertView show];
        // 自定义
        [[SoAlertControl soAlertCustomView] show];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
