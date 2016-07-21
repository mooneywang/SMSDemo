//
//  ViewController.m
//  SMSDemo
//
//  Created by Mengjie.Wang on 16/7/21.
//  Copyright © 2016年 王梦杰. All rights reserved.
//

#import "ViewController.h"
#import "RegViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(UIButton *)sender {
    RegViewController *regVCtrl = [[RegViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVCtrl];
    [self.navigationController presentViewController:nav  animated:YES completion:nil];
}


@end
