# SoAlertControl

继承SoAlertView 自定义MyAlertView。


- 支持横竖屏切换
- 支持xib自定义UI
- 支持先进先显或后进先显
- 支持操作alertView显示队列
- 支持自定义动画


#### 使用

```
   /// 纯代码
   MyAlertView *myalert = [MyAlertView alertViewWithTitle:@"TITLE" Message:@"MESSAGE"];
    
   [myalert addButtonTitle:@"Cancel" click:^(SoAlertView *alertView, UIButton *button) {
       NSLog(@"%@",button);
       [alertView dismiss];
   }];
    
   [myalert show];
    
   /// xib
   MyXIBAlertView *alertView = [MyXIBAlertView alertViewXIB];
   [alertView.buttonCanel addTarget:alertView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
   [alertView.buttonOk addTarget:self action:@selector(nslog) forControlEvents:UIControlEventTouchUpInside];
   [alertView show];
            
```



