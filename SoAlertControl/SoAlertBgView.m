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
    // 添加右边约束：blueView的右边距离父控件右边有10的间距

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
    //    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //    visualEfView.frame =self.bounds;
    //    [self addSubview:visualEfView];
    grayView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:grayView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:grayView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:grayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:grayView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomConstraint];
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
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"%@",NSStringFromCGSize(size));

    if (size.width > size.height) { // 横屏
        // 横屏布局 balabala
        
        
    } else {
        // 竖屏布局 balabala
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
