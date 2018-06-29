//
//  SoAlertBgView.m
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import "SoAlertBgView.h"

@implementation SoAlertBgView

-(instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    [self grayLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addScreenShot 
{
//    UIWindow *screenWindow = [UIApplication sharedApplication].windows.firstObject;
//    UIGraphicsBeginImageContext(screenWindow.frame.size);
//    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImage *originalImage = nil;
//    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)) {
//        originalImage = viewImage;
//    } else {
//        originalImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460))];
//    }
//    self.screenShotView = [[UIImageView alloc] initWithImage:originalImage];
//    [self addSubview:self.screenShotView];
    //    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //    visualEfView.frame =self.bounds;
    //    [self addSubview:visualEfView];
}

-(void)grayLayer
{
    UIView *grayView = [[UIView alloc]initWithFrame:self.frame];
    grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    grayView.userInteractionEnabled = NO;
//    self.grayView = grayView;
    [self addSubview:grayView];
}
#pragma mark- 键盘监听的通知执行方法
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGFloat animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = CGRectMake(0, -kbSize.height, self.frame.size.width, self.frame.size.height);
    } completion:NULL];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGFloat animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion:NULL];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
