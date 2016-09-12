### 前言：如果页面显示不完整或图片看不了还请移步：[简书](http://www.jianshu.com/p/3e31baf7f681)

## SJGestureUnlock.h

---
- 常用自定义属性

	```
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

	```

- 代理方法

	```
		@protocol SJGestureUnlockDelegate <NSObject>

		/**
		 *  返回对应的密码
 		*/
		- (void)gestureUnlock:(SJGestureUnlock *)GestureUnlock result:(NSInteger)result;

		@end

	```

## SJGestureUnlock使用
- 实例化

	```
		// 实例化手势解锁
		SJGestureUnlock *gestureUnlock = [SJGestureUnlock gestureUnlockWithFrame:CGRectMake(unlockX, unlockY, unlockW, unlockH)];
		gestureUnlock.delegate = self;
		[self.view addSubview:gestureUnlock];
		
	```
- 实现代理方法

	```
		/**
		 *  返回记录的结果
 		*
 		*  @param GestureUnlock 当前手势解锁View
 		*  @param result        结果
 		*/
		- (void)gestureUnlock:(SJGestureUnlock *)GestureUnlock result:(NSInteger)result {

    		NSLog(@"结果：%ld", result);
		}

	```

效果：
![效果.gif](http://upload-images.jianshu.io/upload_images/1923109-266ff6f192956cab.gif?imageMogr2/auto-orient/strip)
