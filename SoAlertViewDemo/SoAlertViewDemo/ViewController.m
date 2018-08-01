//
//  ViewController.m
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/6/21.
//  Copyright © 2018年 lingaoo. All rights reserved.
//

#import "ViewController.h"
#import "MyAlertView.h"
#import "MyXIBAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self soAlertControlStack];
//    [self soAlertControlHeap];
    
}

-(void)soAlertControlStack {
    [SoAlertViewManager shareInstance].controlType = SoAlertControlStack;
    
    //e.g 1
    MyAlertView *myalert2 = [MyAlertView alertViewWithTitle:@"title"
                                                    Message:@"mesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmes"];
    [myalert2 addButtonLeft:@"111" right:@"33" leftBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    } rightBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    }];
    [myalert2 showComplete:^{
        NSLog(@"asdfasdf");
    }];
    
    //e.g 2
    MyXIBAlertView *alertView = [MyXIBAlertView alertViewXIB];
    [alertView.buttonCanel addTarget:alertView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [alertView.buttonOk addTarget:self action:@selector(nslog) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView show];
    
    
}

-(void)soAlertControlHeap {
    //e.g 1
    MyAlertView *myalert2 = [MyAlertView alertViewWithTitle:@"title"
                                                    Message:@"mesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmesmesgmesgmesgmesgmes"];
    [myalert2 addButtonLeft:@"111" right:@"33" leftBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    } rightBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    }];
    [myalert2 showComplete:^{
        NSLog(@"asdfasdf");
    }];
    
    //e.g 2
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MyXIBAlertView *alertView = [MyXIBAlertView alertViewXIB];
        [alertView.buttonCanel addTarget:alertView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [alertView.buttonOk addTarget:self action:@selector(nslog) forControlEvents:UIControlEventTouchUpInside];

        [alertView show];
        
    });
    
}
-(void)nslog {
    NSLog(@"hello world");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
