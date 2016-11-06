# SoAlertControl
 精简的alertView

[SoAlertControl soAlertViewWithTitle:@"第一个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
    [soAlertView dismiss];
}].showView();

## 第二个会在第一个消失时弹出
[[SoAlertControl soAlertViewWithTitle:@"第二个" andMessage:@"一个简单的AlertControl" clickOK:^(SoAlertControl *soAlertView) {
    [soAlertView dismiss];
}] addButtontitle:@"取消" click:^(SoAlertControl *soAlertView) {
    [soAlertView dismiss];
}].showView();

## 同理
SoAlertControl *alertView = [SoAlertControl soAlertViewWithTitle:@"第三个" andMessage:@"一个简单AlertControl"];
[alertView addButtonConfig:^(UIButton *btn) {
    [btn setBackgroundColor:UIColor.grayColor];
    [btn setTitle:@"一" forState:UIControlStateNormal];
} click:^(SoAlertControl *soAlertView) {
    [soAlertView dismiss];
}];
[alertView addButtonConfig:^(UIButton *btn) {
    [btn setBackgroundColor:UIColor.cyanColor];
    [btn setTitle:@"二" forState:UIControlStateNormal];
} click:^(SoAlertControl *soAlertView) {
    [soAlertView dismiss];
}];
[alertView show];

## 自定义
[[SoAlertControl soAlertCustomView] show];

运行效果展示
--------------
![image](https://github.com/lingaoo/SoAlertControl/blob/master/demo.gif)
