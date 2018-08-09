//
//  SoAlertControl.m
//  Demo20170630
//
//  Created by soso on 2017/6/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import "SoAlertView.h"

@interface SoAlertControl ()
{
    
}
@property (nonatomic, copy) AnimationBlock animationShowBlock;
@property (nonatomic, copy) AnimationBlock animationDismissBlock;
@property (nonatomic, copy) ContraintBlock contraintBlock;

-(void)show;
-(void)dismiss;
-(void)showComplete:(void(^)(void))complete;
-(void)dismissComplete:(void(^)(void))complete;

@end

@interface SoAlertView ()
{
    
}
@property (nonatomic,strong,readwrite) NSMutableArray *buttonMutables;

@property (nonatomic,strong,readwrite) NSMutableArray *buttonMutableClicksBlock;

@end

@implementation SoAlertView

#pragma mark - set && get

-(NSMutableArray *)buttonMutables
{
    _buttonMutables = _buttonMutables?:[NSMutableArray array];
    return _buttonMutables;
}
-(NSMutableArray *)buttonMutableClicksBlock
{
    _buttonMutableClicksBlock = _buttonMutableClicksBlock?:[NSMutableArray array];
    return _buttonMutableClicksBlock;
}

-(void)setStringTitle:(NSString *)stringTitle
{
    _stringTitle = stringTitle;
    self.labelTitle.text = stringTitle;
}
-(void)setStringMessage:(NSString *)stringMessage
{
    _stringMessage = stringMessage;
    self.labelMessage.text = stringMessage;
}
-(UILabel*)labelTitle
{
    if(_labelTitle == nil) {
        _labelTitle = [self createLabelOther];
        _labelTitle.font = [UIFont systemFontOfSize:kLABELTITLE_FONT];
        _labelTitle.frame = CGRectMake(10, 20, self.frame.size.width - 20 , kTITLEHEIGHT);
        [self addSubview:_labelTitle];
        _labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-12];
        [self addConstraint:rightConstraint];
        
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:12];
        [self addConstraint:leftConstraint];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
        [self addConstraint:topConstraint];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kTITLEHEIGHT];
        [self addConstraint:bottomConstraint];
    }
    return _labelTitle;
}
-(UILabel *)labelMessage
{
    if(_labelMessage == nil) {
        _labelMessage = [self createLabelOther];
        _labelMessage.font = [UIFont systemFontOfSize:kLABELMESSAGE_FONT];
        _labelMessage.frame = CGRectMake(10, 20 + kTITLEHEIGHT + 10, self.frame.size.width - 20 , kMESSAGEHEIGHT);
        [self addSubview:_labelMessage];
        
        _labelMessage.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_labelMessage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-12];
        [self addConstraint:rightConstraint];

        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_labelMessage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:12];
        [self addConstraint:leftConstraint];

        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_labelMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.labelTitle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:12];
        [self addConstraint:topConstraint];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_labelMessage attribute:NSLayoutAttributeBottom  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-kBUTTONHEIGHT - 20];
        [self addConstraint:bottomConstraint];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_labelMessage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kMESSAGEHEIGHT];
        [self addConstraint:heightConstraint];
    }
    return _labelMessage;
}


#pragma mark- init

+(instancetype)alertView
{
    SoAlertView *alertView = [[[self class] alloc] initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width - 40,180}];
    alertView.layer.cornerRadius = 10;
    alertView.backgroundColor = [UIColor whiteColor];

    return alertView;
}
-(void)addLabelOther:(void (^)(UILabel *))labelConfig
{
    UILabel *labelOther = [self createLabelOther];
    labelOther.font = [UIFont systemFontOfSize:kLABELMESSAGE_FONT];
    [self addSubview:labelOther];
    !labelConfig?:labelConfig(labelOther);
}
-(UILabel *)createLabelOther
{
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.numberOfLines = 0;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    return labelTitle;
}

-(void)addLineView:(void (^)(UIView *))lineViewConfig
{
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){0,self.frame.size.height - kBUTTONHEIGHT,self.frame.size.width,1.0/[UIScreen mainScreen].scale}];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    !lineViewConfig?:lineViewConfig(lineView);
}

-(void)centerLineView
{
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){0,self.frame.size.height - kBUTTONHEIGHT,self.frame.size.width,1.0/[UIScreen mainScreen].scale}];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
 
}
-(void)configCenterLineView:(UIView *)lineView
{
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:1.0/[UIScreen mainScreen].scale];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-kBUTTONHEIGHT];
    [self addConstraint:bottomConstraint];
}
-(void)configButtonLineView:(UIView *)lineView
{
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:rightConstraint];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.0 constant:1.0/[UIScreen mainScreen].scale];
    [self addConstraint:topConstraint];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kBUTTONHEIGHT];
    [self addConstraint:heightConstraint];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomConstraint];
}

-(void)addButtonConfig:(void (^)(UIButton *))buttonConfig click:(void (^)(SoAlertView *alertView,UIButton *))clickBlock
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [self.buttonMutables addObject:btn];
    
    if(buttonConfig) buttonConfig(self.buttonMutables.lastObject);

    if(clickBlock)
        [self.buttonMutableClicksBlock addObject:clickBlock];
    else
        [self.buttonMutableClicksBlock addObject:^(SoAlertView *view,UIButton *btn){}];
    
}

-(void)clickOneButton:(UIButton *)sender {
    NSInteger index = [self.buttonMutables indexOfObject:sender];
    if(index == NSNotFound) return;
    
    if(self.buttonMutableClicksBlock.count > index && self.buttonMutableClicksBlock[index]) {
        void(^ClickBlock)(SoAlertView *,UIButton *) = self.buttonMutableClicksBlock[index];
        ClickBlock(self,sender);
     }
}

-(void)configOnlyButton:(UIButton *)btn corner:(CGFloat)corner
{
    CGFloat btnHeight = kBUTTONHEIGHT;
    CGFloat btnWidth = self.frame.size.width;
    CGFloat btnOriginY = self.frame.size.height - btnHeight;
    btn.frame = CGRectMake(0, btnOriginY, btnWidth, btnHeight);
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kBUTTONHEIGHT];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomConstraint];
    
    [self setNeedsLayout];
    [btn setNeedsLayout];

    btn.layer.masksToBounds = YES;
    
    [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forState:UIControlStateHighlighted];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btn.bounds;
    maskLayer.path = maskPath.CGPath;
    btn.layer.mask = maskLayer;
}

-(void)configLeftButton:(UIButton *)leftBtn corner:(CGFloat)corner
{
    CGFloat btnHeight = kBUTTONHEIGHT;
    CGFloat btnWidth = self.frame.size.width/2.0;
    CGFloat btnOriginY = self.frame.size.height - btnHeight;
    leftBtn.frame = CGRectMake(0, btnOriginY, btnWidth, btnHeight);

    leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kBUTTONHEIGHT];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomConstraint];
    
    [leftBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forState:UIControlStateHighlighted];
    leftBtn.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:leftBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = leftBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    leftBtn.layer.mask = maskLayer;
}

-(void)configRightButton:(UIButton *)rightBtn corner:(CGFloat)corner
{
    CGFloat btnHeight = kBUTTONHEIGHT;
    CGFloat btnWidth = self.frame.size.width/2.0;
    CGFloat btnOriginY = self.frame.size.height - btnHeight;
    
    rightBtn.frame = CGRectMake(btnWidth, btnOriginY, btnWidth, btnHeight);
    
    rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:rightBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:rightBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:rightBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.0 constant:kBUTTONHEIGHT];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:rightBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomConstraint];
    
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forState:UIControlStateHighlighted];

    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:rightBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = rightBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    rightBtn.layer.mask = maskLayer2;
    
}
//  颜色转换为背景图片
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(CGSize)sizeWithString:(NSString *)str size:(CGSize)size fontFloat:(CGFloat)fontFloat{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontFloat]};
    CGSize strSize = [str boundingRectWithSize:size
                                       options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:attribute context:nil].size;
    return strSize;
}

#pragma mark- 显示&隐藏

-(void)show
{
    [self showComplete:nil];
}

-(void)showComplete:(void (^)(void))complete
{
    SoAlertControl *altcTemp  = nil;
    
    for (SoAlertControl *altc in [SoAlertViewManager shareInstance].alertQueue) {
        if(altc.contentView == self) {
            altcTemp = altc;
            break;
        }
    }
    
    if(altcTemp == nil) {
        SoAlertControl * alctrol = [[SoAlertControl alloc] init];
        alctrol.animationShowBlock = self.animationShowBlock;
        alctrol.animationDismissBlock = self.animationDismissBlock;
        alctrol.contraintBlock = self.contraintBlock;
        alctrol.contentView = self;
        
        if([SoAlertViewManager shareInstance].controlType == SoAlertControlHeap) {
            [[SoAlertViewManager shareInstance].alertQueue insertObject:alctrol atIndex:0];
        }else{
            [[SoAlertViewManager shareInstance].alertQueue addObject:alctrol];
        }
    }
    
    SoAlertControl *alc =  [SoAlertViewManager shareInstance].alertQueue.firstObject;
    alc.animationShowBlock = self.animationShowBlock;
    alc.animationDismissBlock = self.animationDismissBlock;
    alc.contraintBlock = self.contraintBlock;
    
    [alc showComplete:^{
        if(complete) complete();
    }];
}

-(void)dismiss
{
    [self dismissComplete:nil];
}
-(void)dismissComplete:(void (^)(void))complete
{
    SoAlertControl *alc =  [SoAlertViewManager shareInstance].alertControl;
    if(alc.contentView != self) {
        for (SoAlertControl *altcTemp in [SoAlertViewManager shareInstance].alertQueue) {
            if(altcTemp.contentView == self) {
                alc = altcTemp;
                break;
            }
        }
    }
    [alc dismissComplete:^{
        if(complete) complete();
    }];
}


@end
