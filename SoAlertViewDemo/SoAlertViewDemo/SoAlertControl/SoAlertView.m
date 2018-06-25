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
    CGRect frame = self.labelTitle.frame;
    CGSize size = [self sizeWithString:stringTitle size:CGSizeMake(self.labelTitle.frame.size.width, MAXFLOAT) fontFloat:self.labelTitle.font.pointSize];
    if(size.height < kTITLEHEIGHT ) return;
    frame.size = CGSizeMake(frame.size.width, size.height);
    
    CGRect selfFrame = self.bounds;
    selfFrame.size.height =  selfFrame.size.height + size.height - kTITLEHEIGHT;
    self.bounds = selfFrame;
    self.labelTitle.frame = frame;
}
-(void)setStringMessage:(NSString *)stringMessage
{
    _stringMessage = stringMessage;
    self.labelMessage.text = stringMessage;
    CGRect frame = self.labelMessage.frame;
    CGSize size = [self sizeWithString:stringMessage size:CGSizeMake(self.labelMessage.frame.size.width, MAXFLOAT) fontFloat:self.labelMessage.font.pointSize];
    if(size.height < kMESSAGEHEIGHT ) return;

    frame.size = CGSizeMake(frame.size.width, size.height);;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height =  selfFrame.size.height + size.height - kMESSAGEHEIGHT;
    self.frame = selfFrame;
    self.labelMessage.frame = frame;
}
-(UILabel*)labelTitle {
    if(_labelTitle == nil) {
        _labelTitle = [self createLabelOther];
        _labelTitle.font = [UIFont systemFontOfSize:kLABELTITLE_FONT];
        _labelTitle.frame = CGRectMake(10, 20, self.frame.size.width - 20 , kTITLEHEIGHT);
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}
-(UILabel *)labelMessage {
    if(_labelMessage == nil) {
        _labelMessage = [self createLabelOther];
        _labelMessage.font = [UIFont systemFontOfSize:kLABELMESSAGE_FONT];
        _labelMessage.frame = CGRectMake(10, 20 + kTITLEHEIGHT + 10, self.frame.size.width - 20 , kMESSAGEHEIGHT);
        [self addSubview:_labelMessage];
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

-(void)clickOneButton:(UIButton *)sender
{
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
    
    [leftBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forState:UIControlStateHighlighted];
    leftBtn.frame = CGRectMake(0, btnOriginY, btnWidth, btnHeight);
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
        alctrol.contentView = self;
        
        if([SoAlertViewManager shareInstance].controlType == SoAlertControlHeap) {
            [[SoAlertViewManager shareInstance].alertQueue insertObject:alctrol atIndex:0];
        }else{
            [[SoAlertViewManager shareInstance].alertQueue addObject:alctrol];
        }
    }
    
    SoAlertControl *alc =  [SoAlertViewManager shareInstance].alertQueue.firstObject;
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
