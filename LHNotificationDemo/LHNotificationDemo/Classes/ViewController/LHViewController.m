//
//  LHViewController.m
//  LHNotificationDemo
//
//  Created by 李辉 on 15/3/9.
//  Copyright (c) 2015年 gushiwen.org. All rights reserved.
//

#import "LHViewController.h"
#import "LHNotificationView.h"

@implementation LHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showNotification:(id)sender
{
    [LHNotificationView showNotification:self withText:@"刷新失败"];
}

- (IBAction)showSuccessNotification:(id)sender
{
    [LHNotificationView showNotification:self withText:@"刷新成功" type:LHNotificationTypeSuccess];
}


@end
