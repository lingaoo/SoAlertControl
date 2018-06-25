//
//  SoAlertBgView.m
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import "SoAlertBgView.h"
#import "SoAlertControl.h"

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
    CGRect contentViewFrame = [SoAlertViewManager shareInstance].alertControl.contentView.frame;
    CGFloat animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat move = 0.0f;
    if(contentViewFrame.origin.y + contentViewFrame.size.height > self.bounds.size.height - kbSize.height) {
        move = contentViewFrame.origin.y + contentViewFrame.size.height - (self.bounds.size.height - kbSize.height);
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, -(move+8) , self.frame.size.width, self.frame.size.height);
        } completion:NULL];
    }
   
  
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGFloat animationDuration=0;
    NSDictionary* info = [aNotification userInfo];
    animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(self.frame.origin.y != 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        } completion:NULL];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
