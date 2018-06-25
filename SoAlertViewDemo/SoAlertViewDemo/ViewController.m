//
//  ViewController.m
//  SoAlertViewDemo
//
//  Created by teamotto on 2018/6/21.
//  Copyright © 2018年 lingaoo. All rights reserved.
//

#import "ViewController.h"
#import "MyAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self asdf];
    
}


-(void)asdf {
    
    MyAlertView *myalert2 = [MyAlertView alertViewWithTitle:@"title"
                                                    Message:@"mesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmesgmessgmesg"];
    [myalert2 addButtonLeft:@"111" right:@"33" leftBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    } rightBlock:^(SoAlertView *alertView, UIButton *button) {
        [alertView dismiss];
    }];
    [myalert2 showComplete:^{
        NSLog(@"asdfasdf");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MyAlertView *myalert = [MyAlertView alertViewWithTitle:@"TITLE" Message:@"MESSAG"];
        [myalert addButtonTitle:@"Cancel" click:^(SoAlertView *alertView, UIButton *button) {
            NSLog(@"%@",button);
            [alertView dismiss];
        }];
        [myalert show];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
