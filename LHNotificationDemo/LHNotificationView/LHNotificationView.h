//
//  LHNotification.h
//  LHNotification
//
//  Created by 李辉 on 15/3/9.
//  Copyright (c) 2015年 gushiwen.org. All rights reserved.
//

#import <UIKit/UIKit.h>

///通知类型
typedef NS_ENUM(NSInteger, LHNotificationType)
{
    LHNotificationTypeWarrning,
    LHNotificationTypeSuccess
};

@interface LHNotificationView : UIView

- (instancetype) initWithController:(UIViewController *)controller text:(NSString *)text;

///文字颜色
@property (nonatomic, strong) UIColor *textColor;

///画面停留时间
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) LHNotificationType type;

///显示
- (void) show:(BOOL)aAnimation;

///隐藏
- (void) dismiss:(BOOL)aAnimation;

///显示信息
+ (void) showNotification:(id)aTarget withText:(NSString *)text type:(LHNotificationType)aType;
+ (void) showNotification:(id)aTarget withText:(NSString *)text;

@end
