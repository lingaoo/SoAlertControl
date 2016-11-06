//
//  SoAlertCustomView.h
//  ZJNSBank
//
//  Created by soso on 16/9/14.
//  Copyright © 2016年 UCSMY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickClose)(void);
@interface SoAlertCustomView : UIView

@property (nonatomic ,copy)ClickClose clickClose;

+(instancetype)customAlertView ;

@end
