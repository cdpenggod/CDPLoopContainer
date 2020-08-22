//
//  CDPLoopContainer.m
//  LoopContainer
//
//  Created by Chai,Dongpeng on 2020/8/22.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "CDPLoopContainer.h"

#define DefaultAnimatedDuration 0.8f //默认动画时长
#define DefaultShowDuration 3 //默认显示时间

typedef enum {
    CDPLoopContainerViewFrameShow        = 0, //正在展示
    CDPLoopContainerViewFrameWillShow    = 1, //即将出现
    CDPLoopContainerViewFrameEndShow     = 2  //展示结束
} CDPLoopContainerViewFrame; //循环 view 的 frame 类别

@interface CDPLoopContainer ()

@property (nonatomic, strong) NSArray *viewArr; //显示的 view 集合

@property (nonatomic, assign) NSInteger showViewIndex; //记录当前显示的 view 在集合中 index

@property (nonatomic, assign) BOOL haveStart; //判断是否已开始循环

@end

@implementation CDPLoopContainer
//初始化-单一类型 view
- (instancetype)initWithViewClass:(Class)viewClass count:(NSInteger)count {
    return [self initWithViewClassArr:(viewClass)? @[viewClass] : nil count:count];
}
//初始化-多种类型 view
- (instancetype)initWithViewClassArr:(NSArray *)viewClassArr count:(NSInteger)count {
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        
        [self reset];
        
        self.count = count;
        
        //循环所需view
        if (viewClassArr &&
            [viewClassArr isKindOfClass:[NSArray class]] &&
            viewClassArr.count > 0) {
            
            //获取所有传入view
            NSMutableArray *arr = [NSMutableArray new];
            for (Class theClass in viewClassArr) {
                if ([theClass isSubclassOfClass:[UIView class]]) {
                    [arr addObject:[[theClass alloc] init]];
                }
            }
            
            if (arr.count == 0) {
                //传入class都不对
                self.viewArr = @[[[UIView alloc] init], [[UIView alloc] init]];
            } else {
                if (arr.count == 1) {
                    //只有一种view
                    UIView *theView = arr[0];
                    [arr addObject:[[theView.class alloc] init]];
                }
                
                self.viewArr = [arr copy];
            }
            
        } else {
            self.viewArr = @[[[UIView alloc] init], [[UIView alloc] init]];
        }
    }
    return self;
}
- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
#pragma mark - 交互
//开始循环
- (void)start {
    //判断是否已开始
    if (!self.haveStart) {
        [self doLoop];
    }
}
//停止循环
- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.haveStart = NO;
}
//重置为初始化状态
- (void)reset {
    self.paddingInsets = UIEdgeInsetsZero;
    self.direction = CDPLoopContainerDirectionUp;
    self.stopWhenOneCount = YES;
    
    //时长
    self.animatedDuration = DefaultAnimatedDuration;
    self.showDuration = DefaultShowDuration;
    
    //循环数量及index
    self.count = 1;
    self.currentIndex = 0;
    
    //初始未循环过,用 -1 方便后续判断
    self.showViewIndex = -1;
}
#pragma mark - 循环
- (void)doLoop {
    if (self.viewArr && self.viewArr.count > 0) {
        
        //是否第一次循环
        BOOL isFrist = (self.showViewIndex == -1)? YES : NO;
        
        //判断 count 数量为 1 自动停止
        if (self.count == 1 && self.stopWhenOneCount) {
            [self stop];
            
            if (!isFrist) {
                UIView *currentView = self.viewArr[self.showViewIndex];
                [currentView removeFromSuperview];
            }
            //记录 index
            self.currentIndex = 0;
            self.showViewIndex = 0;
            
            UIView *view = self.viewArr[0];
            view.frame = [self getViewFrameWithType:CDPLoopContainerViewFrameShow];
            if (view.superview == nil) {
                [self addSubview:view];
            }
            
            //回调渲染view
            if ([self.delegate respondsToSelector:@selector(loopContainerWillShowView:index:container:)]) {
                [self.delegate loopContainerWillShowView:view index:0  container:self];
            }
            return;
        }
        
        //记录开始循环
        self.haveStart = YES;
        
        //即将出现的viewIndex
        NSInteger nextViewIndex = (isFrist || self.showViewIndex >= self.viewArr.count - 1)? 0 : self.showViewIndex + 1;
        //总循环index
        NSInteger nextIndex = (isFrist || self.currentIndex >= self.count - 1)? 0 : self.currentIndex + 1;
        
        //获取即将出现 view
        UIView *nextView = self.viewArr[nextViewIndex];
        nextView.frame = [self getViewFrameWithType:(isFrist)? CDPLoopContainerViewFrameShow : CDPLoopContainerViewFrameWillShow];
        if (nextView.superview == nil) {
            [self addSubview:nextView];
        }
        
        //即将出现 view 进行回调
        if ([self.delegate respondsToSelector:@selector(loopContainerWillShowView:index:container:)]) {
            [self.delegate loopContainerWillShowView:nextView index:nextIndex  container:self];
        }
        
        //设置下次循环开始时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(doLoop)
                   withObject:nil
                   afterDelay:self.showDuration + self.animatedDuration];
        
        //循环动画
        if (!isFrist) {
            UIView *currentView = self.viewArr[self.showViewIndex];
            [UIView animateWithDuration:self.animatedDuration animations:^{
                currentView.frame = [self getViewFrameWithType:CDPLoopContainerViewFrameEndShow];
                nextView.frame = [self getViewFrameWithType:CDPLoopContainerViewFrameShow];
            } completion:^(BOOL finished) {
                [currentView removeFromSuperview];
            }];
        }
        
        //记录当前viewIndex
        self.showViewIndex = nextViewIndex;
        //记录当前循环index
        self.currentIndex = nextIndex;
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}
#pragma mark - 其他方法
//获取 view 的 frame
- (CGRect)getViewFrameWithType:(CDPLoopContainerViewFrame)type {
    CGFloat left = fabs(self.paddingInsets.left);
    CGFloat right = fabs(self.paddingInsets.right);
    CGFloat top = fabs(self.paddingInsets.top);
    CGFloat bottom = fabs(self.paddingInsets.bottom);
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat viewWidth = MAX(width - left - right, 0);
    CGFloat viewHeight = MAX(height - top - bottom, 0);
    
    CGRect frame = CGRectMake(left, top, viewWidth, viewHeight);
    
    if (type == CDPLoopContainerViewFrameShow) {
        //正在展示的 frame
        return frame;
    }
    
    //出现前/展示结束 frame
    switch (self.direction) {
        case CDPLoopContainerDirectionUp:
            //向上滚动
            frame.origin.y = (type == CDPLoopContainerViewFrameWillShow)? top + height : top - height;
            break;
        case CDPLoopContainerDirectionDown:
            //向下滚动
            frame.origin.y = (type == CDPLoopContainerViewFrameWillShow)? top - height : top + height;
            break;
        case CDPLoopContainerDirectionLeft:
            //向左滚动
            frame.origin.x = (type == CDPLoopContainerViewFrameWillShow)? left + width: left - width;
            break;
        case CDPLoopContainerDirectionRight:
            //向右滚动
            frame.origin.x = (type == CDPLoopContainerViewFrameWillShow)? left - width: left + width;
        break;
    }
    return frame;
}
#pragma mark - setter
- (void)setAnimatedDuration:(CGFloat)animatedDuration {
    _animatedDuration = (animatedDuration > 0)? animatedDuration : DefaultAnimatedDuration;
}
- (void)setShowDuration:(CGFloat)showDuration {
    _showDuration = (showDuration > 0)? showDuration : DefaultShowDuration;
}
- (void)setCount:(NSInteger)count {
    _count = (count <= 1)? 1 : count;
    
    if (_currentIndex >= _count) {
        _currentIndex = _count - 1;
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = (currentIndex < 0)? 0 : currentIndex;
    
    if (_currentIndex >= _count) {
        _currentIndex = _count - 1;
    }
}

@end
