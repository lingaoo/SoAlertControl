//
//  SoAlertCustomView.m
//  ZJNSBank
//
//  Created by soso on 16/9/14.
//  Copyright © 2016年 UCSMY. All rights reserved.
//

#import "SoAlertCustomView.h"

@interface SoAlertCustomView ()

@end

@implementation SoAlertCustomView

+(instancetype)customAlertView {
    SoAlertCustomView *customView = [[SoAlertCustomView alloc]initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width - 40,200}];
    customView.center = [UIApplication sharedApplication].windows.firstObject.center;
    customView.layer.cornerRadius = 8.0f;
    customView.backgroundColor    = [UIColor whiteColor];
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(customView.bounds.size.width - 28,8, 20, 20);
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *url = [bundle URLForResource:@"SoAlertControl" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"ic_close_alt@2x" ofType:@"png"];
    [btnClose setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [btnClose addTarget:customView action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnClose];
    return customView;
}

-(void)clickClose:(UIButton *)sender {
    if(self.clickClose)
        self.clickClose();
}


@end
