//
//  ClockView.m
//  07-手势解锁
//
//  Created by apple on 20/3/21.
//  Copyright © 2020年 弓虽_子. All rights reserved.
//

#import "SJGestureUnlock.h"

static NSInteger const maxValue = 9;  // 最大个数
static NSInteger const totalCol = 3;  // 总列数

@interface SJGestureUnlock ()

// 存放当前选中的按钮
@property (strong, nonatomic) NSMutableArray *selectBtnArray;
// 记录当前手指的点
@property (nonatomic , assign) CGPoint curP;

@end

@implementation SJGestureUnlock

- (NSMutableArray *)selectBtnArray {
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

- (void)awakeFromNib {
    // 添加按钮
    [self setUp];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加按钮
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化配置
/**
 *  初始化配置
 */
- (void)setUp {
    
    // 默认颜色
    self.backgroundColor = [UIColor clearColor];
    
    // 默认图片
    _image = [UIImage imageNamed:@"gesture_normal"];
    _selectedImage = [UIImage imageNamed:@"gesture_highlighted"];
    
    // 默认连接线属性
    _lineColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _lineWidth = 5;
    
    // 添加按钮
    for (int i = 0; i < maxValue; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.tag = i + 1;
        // 设置按钮图片
        [btn setImage:_image forState:UIControlStateNormal];
        [btn setImage:_selectedImage forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

#pragma mark - 手指点击时

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取当前手指的点
    CGPoint curP = [self getCurPoint:touches];
    
    // 判断点在不在按钮身上.
    UIButton *btn = [self btnRectContainPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
}

#pragma mark - 手指移动时

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    // 获取当前手指的点
    CGPoint curP = [self getCurPoint:touches];
    self.curP = curP;
    
    // 判断点在不在按钮身上.
    UIButton *btn = [self btnRectContainPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
    
    // 重绘
    [self setNeedsDisplay];
    
}

#pragma mark - 手指离开时

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSMutableString *str = [NSMutableString string];
    
    // 取消所有选中的按钮
    for (UIButton *btn in self.selectBtnArray) {
        
        btn.selected = NO;
        // 记录选中按钮的顺序
        [str appendFormat:@"%ld", btn.tag];
    }
    
    if (![self.delegate respondsToSelector:@selector(gestureUnlock:result:)]) {
        @throw [NSException exceptionWithName:@"SJGestureUnlock" reason:@"未实现 gestureUnlock:result:" userInfo:nil];
        return;
    }else {
        [self.delegate gestureUnlock:self result:str.integerValue];
    }
    
    // 清空所有连接线
    [self.selectBtnArray removeAllObjects];

    // 重绘
    [self setNeedsDisplay];
    

}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect {
    
    if (self.selectBtnArray.count) {
        // 描述路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 取出所有选中的按钮
        for (int i = 0;i < self.selectBtnArray.count; i++) {
            // 取出选中的按钮
            UIButton *btn = self.selectBtnArray[i];
            if (i == 0) {
                // 如果是第一个按钮,让它的center,成为路径的起点.
                [path moveToPoint:btn.center];
            }else {
                // 如果不是第一个按钮,直接添加一根线到按钮中心
                [path addLineToPoint:btn.center];
            }
        }
        
        // 添加一根线到当前手指的点.
        [path addLineToPoint:self.curP];
        
        // 设置线的状态
        [path setLineWidth:_lineWidth];
        [_lineColor set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        [path stroke];
    }
}

#pragma mark - 布局
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGFloat btnWH = _image.size.width;
    // 间隙
    CGFloat margin = 0;
    // 最后一个按钮在第几行
    CGFloat row = (maxValue) / totalCol;
    
    // 当前视图尺寸是否符合最低要求
    if (frame.size.width == 0 || frame.size.height == 0 || frame.size.width < btnWH * totalCol || frame.size.height < row * btnWH) {  // 设置默认尺寸
        
        margin = [self AdaptationValue:5.0];
        frame.size.width = totalCol * btnWH + totalCol * margin;
        frame.size.height = row * btnWH + margin * row;
        self.frame = frame;
    }else {
        
        margin = (self.bounds.size.width - (btnWH * totalCol)) / (totalCol + 1);
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat curCol = 0;
    CGFloat curRow = 0;
    // 取出按钮,设置尺寸
    for (int i = 0 ; i < self.subviews.count; i++) {
        // 取出按钮
        UIButton *btn = self.subviews[i];
        // 计算按钮尺寸
        curCol = i % totalCol;
        curRow = i / totalCol;
        x = margin + (btnWH + margin) * curCol;
        y = margin + (btnWH + margin) * curRow;
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}

#pragma mark - 手指位置判断
/**
 *  获取当前手指的点
 */
- (CGPoint)getCurPoint:(NSSet *)touches {
    // 获取当前手指的点
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    
    return curP;
}

/**
 *  判断点在不在按钮身上
 */
- (UIButton *)btnRectContainPoint:(CGPoint)point {
    
    for (UIButton *btn in self.subviews) {
        // 点在按钮身上
        if (CGRectContainsPoint(btn.frame, point)) {
            // 让按钮成为选中状态
            // btn.selected = YES;
            return btn;
        }
    }
    return nil;
}

#pragma mark - 适配相关

/**
 *  数值适配
 */
- (CGFloat)AdaptationValue:(CGFloat)value {

    CGRect bounds = [UIScreen mainScreen].bounds;
    if (bounds.size.height == 736) {
        return (value) / 414.0f * bounds.size.width;
    }else if(bounds.size.height == 667) {
        return (value) / 375.0f * bounds.size.width;
    }else {
        return (value) / 320.0f * bounds.size.width;
    }
}

+ (instancetype)gestureUnlockWithFrame:(CGRect)frame {

    return [[self alloc] initWithFrame:frame];
}

@end
