# SoAlertControl

继承SoAlertView 自定义MyAlertView

```
    MyAlertView *myalert = [MyAlertView alertViewWithTitle:@"TITLE" Message:@"MESSAGE"];
    
    [myalert addButtonTitle:@"Cancel" click:^(SoAlertView *alertView, UIButton *button) {
        NSLog(@"%@",button);
        [alertView dismiss];
    }];
    
    [myalert show];
```

