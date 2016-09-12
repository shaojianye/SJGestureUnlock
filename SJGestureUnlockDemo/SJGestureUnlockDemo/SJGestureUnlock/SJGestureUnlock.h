//
//  ClockView.h
//  07-手势解锁
//
//  Created by apple on 20/3/21.
//  Copyright © 2020年 弓虽_子. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJGestureUnlock;

@protocol SJGestureUnlockDelegate <NSObject>

/**
 *  返回对应的密码
 */
- (void)gestureUnlock:(SJGestureUnlock *)GestureUnlock result:(NSInteger)result;

@end

@interface SJGestureUnlock : UIView

@property (nonatomic, weak) id<SJGestureUnlockDelegate> delegate;
/**
 *  默认图片
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  高亮图片
 */
@property (nonatomic, strong) UIImage *selectedImage;
/**
 *  连接线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *  连接线宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  实例化手势解锁
 */
+ (instancetype)gestureUnlockWithFrame:(CGRect)frame;

@end
