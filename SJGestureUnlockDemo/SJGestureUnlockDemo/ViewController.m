//
//  ViewController.m
//  SJGestureUnlockDemo
//
//  Created by yeshaojian on 16/9/12.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import "ViewController.h"
#import "SJGestureUnlock.h"


@interface ViewController () <SJGestureUnlockDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    backgroundImage.image = [UIImage imageNamed:@"home_bg.jpg"];
    backgroundImage.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    [self.view addSubview:backgroundImage];
    
    CGFloat unlockW = 300;
    CGFloat unlockH = unlockW;
    CGFloat unlockX = (bounds.size.width - unlockW) * 0.5;
    CGFloat unlockY = (bounds.size.height - unlockH) * 0.5;
    
    SJGestureUnlock *gestureUnlock = [SJGestureUnlock gestureUnlockWithFrame:CGRectMake(unlockX, unlockY, unlockW, unlockH)];
    gestureUnlock.delegate = self;
    // 可选设置
    //    gestureUnlock.lineColor = [UIColor yellowColor];
    //    gestureUnlock.lineWidth = 10;
    //    gestureUnlock.image = ;
    //    gestureUnlock.selectedImage = ;
    [self.view addSubview:gestureUnlock];
}

#pragma mark - 代理
/**
 *  返回记录的结果
 *
 *  @param GestureUnlock 当前手势解锁View
 *  @param result        结果
 */
- (void)gestureUnlock:(SJGestureUnlock *)GestureUnlock result:(NSInteger)result {
    
    NSLog(@"结果：%ld", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
