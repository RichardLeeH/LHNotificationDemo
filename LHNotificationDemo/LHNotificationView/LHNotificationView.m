//
//  LHNotification.m
//  LHNotification
//
//  Created by 李辉 on 15/3/9.
//  Copyright (c) 2015年 gushiwen.org. All rights reserved.
//

#import "LHNotificationView.h"
#import "NSString+LHExtensions.h"

#define DEFAULT_EDGE              24.0f
#define DEFAULT_SPACE_IMG_TEXT    5.0f
#define DEFAULT_RATE_WIDTH        0.8f
#define DEFAULT_DURATION          0.5f
#define DEFAULT_ANIMATON_DURATION 0.3f
#define DEFAULT_HEIGHT            45.0f

//状态栏高度
#define STATUSBAR_HEIGHT     CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
//导航栏高度
#define NAVIGATIONBAR_HEIGHT(self) CGRectGetHeight(self.navigationController.navigationBar.frame)

@interface LHNotificationView()

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString         *text;
@property (nonatomic, strong) UIImage          *image;

@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, assign) CGRect imgRect;

@end

@implementation LHNotificationView

////////////////////////////////////////////////////////////////////////////////////////////////////
//类方法
+ (void) showNotification:(id)aTarget withText:(NSString *)text
{
    [self showNotification:aTarget withText:text type:LHNotificationTypeWarrning];
}

+ (void) showNotification:(id)aTarget withText:(NSString *)text type:(LHNotificationType)type
{
    LHNotificationView *notification = [[LHNotificationView alloc] initWithController:aTarget text:text];
    [((UIViewController *)aTarget).view addSubview:notification];
    notification.type = type;
    [notification show:YES];
}

#pragma system func
- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.opacity = 0.25;
        self.duration = DEFAULT_DURATION;
        self.layer.masksToBounds = YES;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (id) initWithController:(UIViewController *)controller text:(NSString *)text
{
    if([self initWithFrame:CGRectMake(0, -DEFAULT_HEIGHT, controller.view.bounds.size.width*DEFAULT_RATE_WIDTH, DEFAULT_HEIGHT)])
    {
        self.text = text;
        self.controller = controller;
        
        //计算文字图片区域
        CGSize size = [self.text stringSizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        
        int offsetX = (CGRectGetWidth(self.frame) - (DEFAULT_EDGE + DEFAULT_SPACE_IMG_TEXT + size.width)) / 2;
        int offsetY = (CGRectGetHeight(self.frame) - DEFAULT_EDGE)/2;
        
        self.imgRect = CGRectMake(offsetX, offsetY, DEFAULT_EDGE, DEFAULT_EDGE);
        
        offsetX += DEFAULT_EDGE + 2*DEFAULT_SPACE_IMG_TEXT;
        offsetY  = (CGRectGetHeight(self.frame) - size.height)/2;
        
        self.textRect = CGRectMake(offsetX, offsetY, size.width, size.height);
        
        //设置主控件的中心点位置
        self.center = CGPointMake(controller.view.center.x, self.center.y);
    }
    return self;
}

- (void)drawRect:(CGRect)aRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //drawText
    [self drawText:context text:self.text rect:self.textRect];
    //drawImage
    [self drawImage:context image:self.image.CGImage rect:self.imgRect];
}

- (void) drawText:(CGContextRef) aContext text:(NSString *) aText rect:(CGRect) aRect
{
    UIGraphicsPushContext( aContext );

    [self.text drawInRect:aRect withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]] , NSForegroundColorAttributeName:self.textColor}];
    UIGraphicsPopContext();
}

- (void) drawImage:(CGContextRef) aContext image:(CGImageRef) aImage rect:(CGRect) aRect
{
    UIGraphicsPushContext( aContext );
    [self.image drawInRect:aRect];
    UIGraphicsPopContext();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setType:(LHNotificationType)aType
{
    switch (aType)
    {
        case LHNotificationTypeWarrning:
        {
            self.image = [UIImage imageNamed:@"LHNotification.bundle/notification_warring"];
        }
        break;
        case LHNotificationTypeSuccess:
        {
            self.image = [UIImage imageNamed:@"LHNotification.bundle/notification_success"];
        }
        break;
    }//end of switch (aType)
}

-(void)show:(BOOL)aAnimation
{
    CGRect frame = self.frame;
    if([self.controller.parentViewController isKindOfClass:[UINavigationController class]] && !self.controller.navigationController.navigationBar.isHidden)
    {
        frame.origin.y = (STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT(self.controller)) - DEFAULT_SPACE_IMG_TEXT;
    }
    else
    {
        frame.origin.y = -DEFAULT_SPACE_IMG_TEXT;
    }
    
    if(aAnimation)
    {
        [UIView animateWithDuration:DEFAULT_ANIMATON_DURATION animations:^{
            self.frame = frame;
        }
        completion:^(BOOL finished)
        {
            [self showHandle];
        }];
    }
    else
    {
        self.frame = frame;
        [self showHandle];
    }
}

#pragma private FUNC
- (void) showHandle
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss:YES];
    });
}

- (void) dismiss:(BOOL)aAnimation
{
    CGRect frame = self.frame;
    frame.origin.y = -DEFAULT_HEIGHT;
    if(aAnimation)
    {
        [UIView animateWithDuration:DEFAULT_ANIMATON_DURATION animations:^{
            self.frame = frame;
        }
        completion:^(BOOL finished)
        {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}

@end
