//
//  RegViewController.m
//  SMSDemo
//
//  Created by Mengjie.Wang on 16/7/21.
//  Copyright © 2016年 王梦杰. All rights reserved.
//

#import "RegViewController.h"
#import <Masonry.h>
#import "RegionsViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "UIButton+CountDown.h"

@interface RegViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *contentView;
/** 手机号码输入框*/
@property (nonatomic, weak) UITextField *telTextField;
/** 验证码输入框*/
@property (nonatomic, weak) UITextField *securityTextField;


@end


@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self replaceView];
    [self addContentView];
    [self setupSubViewsInContentView];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)replaceView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height - 64);
    scrollView.alwaysBounceVertical = YES;
    // 使用scrollView替换view
    [self setView:scrollView];
}

- (void)addContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _contentView = contentView;
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)setupSubViewsInContentView {
    // noticeLabel
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(0, 10, self.view.bounds.size.width, 30);
    noticeLabel.text = @"请确认您的国家或地区并输入手机号";
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:noticeLabel];
    
    // regionTableView
    UITableView *regionTableView = [[UITableView alloc] init];
    regionTableView.dataSource = self;
    regionTableView.delegate = self;
    regionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:regionTableView];
    [regionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabel.mas_bottom);
        make.width.equalTo(noticeLabel.mas_width);
        make.height.equalTo(@44);
        make.left.equalTo(noticeLabel.mas_left);
    }];
    
    // telView
    UIView *telView = [[UIView alloc] init];
    telView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [_contentView addSubview:telView];
    [telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(regionTableView.mas_bottom);
        make.width.equalTo(regionTableView.mas_width);
        make.height.equalTo(@44);
        make.left.equalTo(noticeLabel.mas_left);
    }];
    
    // regionNumLabel
    UILabel *regionNumLabel = [[UILabel alloc] init];
    regionNumLabel.backgroundColor = [UIColor whiteColor];
    regionNumLabel.text = @"+86";
    regionNumLabel.textAlignment = NSTextAlignmentCenter;
    [telView addSubview:regionNumLabel];
    [regionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telView).offset(1);
        make.bottom.equalTo(telView);
        make.left.equalTo(telView);
        make.width.equalTo(@60);
    }];
    
    // telTextField
    UITextField *telTextField = [[UITextField alloc] init];
    telTextField.backgroundColor = [UIColor whiteColor];
    telTextField.keyboardType = UIKeyboardTypePhonePad;
    telTextField.placeholder = @"请填写手机号码";
    telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [telView addSubview:telTextField];
    [telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telView).offset(1);
        make.bottom.equalTo(telView);
        make.left.equalTo(regionNumLabel.mas_right).offset(1);
        make.right.equalTo(telView);
    }];
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 10, 0);
    telTextField.leftView = leftView;
    telTextField.leftViewMode = UITextFieldViewModeAlways;
    _telTextField = telTextField;
    
    // securityView
    UIView *securityView = [[UIView alloc] init];
    securityView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [_contentView addSubview:securityView];
    [securityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telView.mas_bottom);
        make.width.equalTo(telView.mas_width);
        make.height.equalTo(@44);
        make.left.equalTo(telView.mas_left);
    }];
    
    // securityLabel
    UILabel *securityLabel = [[UILabel alloc] init];
    securityLabel.backgroundColor = [UIColor whiteColor];
    securityLabel.text = @"验证码 :";
    securityLabel.textAlignment = NSTextAlignmentCenter;
    [securityView addSubview:securityLabel];
    [securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(securityView).offset(1);
        make.bottom.equalTo(securityView).offset(-1);
        make.left.equalTo(securityView);
        make.width.equalTo(@100);
    }];
    
    // securityButton
    UIButton *securityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    securityButton.backgroundColor = [UIColor whiteColor];
    [securityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [securityButton setTitleColor:[UIColor colorWithRed:0.000 green:0.566 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    securityButton.titleLabel.font = [UIFont systemFontOfSize:13];
    securityButton.layer.borderWidth = 1;
    securityButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.566 blue:1.000 alpha:1.000].CGColor;
    securityButton.layer.cornerRadius = 5;
    securityButton.layer.masksToBounds = YES;
    [securityView addSubview:securityButton];
    [securityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(securityView).offset(5);
        make.bottom.equalTo(securityView).offset(-5);
        make.right.equalTo(securityView).offset(-5);
        make.width.equalTo(@80);
    }];
    [securityButton addTarget:self action:@selector(getSecurityCode:) forControlEvents:UIControlEventTouchUpInside];
    
    // securityTextField
    UITextField *securityTextField = [[UITextField alloc] init];
    securityTextField.backgroundColor = [UIColor whiteColor];
    securityTextField.placeholder = @"请输入验证码";
    securityTextField.textAlignment = NSTextAlignmentCenter;
    securityTextField.keyboardType = UIKeyboardTypeNumberPad;
    securityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [securityView addSubview:securityTextField];
    [securityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(securityView).offset(1);
        make.bottom.equalTo(securityView).offset(-1);
        make.left.equalTo(securityLabel.mas_right).offset(1);
        make.right.equalTo(securityButton.mas_left).offset(-5);
    }];
    _securityTextField = securityTextField;
    
    // registerButton
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor whiteColor];
    [registerButton setTitle:@"注  册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:0.000 green:0.566 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    registerButton.layer.borderWidth = 1;
    registerButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.566 blue:1.000 alpha:1.000].CGColor;
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    [_contentView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(securityView.mas_bottom).offset(20);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(securityView).offset(-20);
        make.height.equalTo(@40);
    }];
    registerButton.userInteractionEnabled = YES;
    [registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)getSecurityCode:(UIButton *)sender {
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:_telTextField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    
    [sender countDownFromTime:60 title:@"重新获取" unitTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
}

- (void)registerButtonAction {
    NSLog(@"注册");
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    [SMSSDK commitVerificationCode:_securityTextField.text phoneNumber:_telTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"验证成功");
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"regionCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"国家和地区";
    cell.detailTextLabel.text = @"中国";
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择国家或地区");
}

@end
