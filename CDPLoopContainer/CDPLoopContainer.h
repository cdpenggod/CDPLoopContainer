//
//  CDPLoopContainer.h
//  LoopContainer
//
//  Created by Chai,Dongpeng on 2020/8/22.
//  Copyright © 2020 CDP. All rights reserved.
//  无限循环滚动容器

#import <UIKit/UIKit.h>

typedef enum {
    CDPLoopContainerDirectionUp    = 0, //向上滚动
    CDPLoopContainerDirectionDown  = 1, //向下滚动
    CDPLoopContainerDirectionLeft  = 3, //向左滚动
    CDPLoopContainerDirectionRight = 4  //向右滚动
} CDPLoopContainerDirection; //滚动方向

@class CDPLoopContainer;

@protocol CDPLoopContainerDelegate <NSObject>

/// 即将开始循环动画前回调 (可对 view 进行 UI更新)
/// @param view 即将循环出现的 view
/// @param index 对应的 index 位置 (从 0 开始, 最大值为传入的 count - 1)
/// @param container view 所在 循环容器 (此方法中无法修改 currentIndex)
- (void)loopContainerWillShowView:(UIView *)view index:(NSInteger)index container:(CDPLoopContainer *)container;

@end


@interface CDPLoopContainer : UIView

/// 代理
@property (nonatomic, weak) id <CDPLoopContainerDelegate> delegate;

/// 当前展示的 index
/// 范围 0 <= currentIndex < count, 第一次 start 固定从 0 开始
/// 外部修改后不改变当前展示 view，会修改后续新出的循环 view
@property (nonatomic, assign) NSInteger currentIndex;

/// 循环展示的总数量
/// 如果传参小于 1，则自动改为 1
@property (nonatomic, assign) NSInteger count;

/// 每次循环动画时长 (默认 0.8)
@property (nonatomic, assign) CGFloat animatedDuration;

/// 每次循环后 view 显示时长 (默认 3)
@property (nonatomic, assign) CGFloat showDuration;

/// 循环 view 相对于 container 容器的内边距 (默认 UIEdgeInsetsZero, 不要负值, 内部会取绝对值)
/// 循环 view 相互间距 ：上下滚动 top + bottom  左右滚动 left + right
@property (nonatomic, assign) UIEdgeInsets paddingInsets;

/// 滚动方向 (默认 CDPLoopContainerDirectionUp)
@property (nonatomic, assign) CDPLoopContainerDirection direction;

/// 当 count 数量为 1 时，是否显示 view 后停止循环 (默认 YES)
@property (nonatomic, assign) BOOL stopWhenOneCount;

/// 初始化-单一类型 view
/// @param viewClass 循环的 view 类，内部会通过 init 初始化创建，并通过 delegate 回调
/// @param count 循环展示的总数量 (推荐根据 数据量 传入, 回调时可根据 index 判断对应数据进行渲染)
- (instancetype)initWithViewClass:(Class)viewClass count:(NSInteger)count;

/// 初始化-多种类型 view
/// @param viewClassArr 循环的 view 类数组，内部会逐个通过 init 初始化创建，并通过 delegate 回调
/// @param count 循环展示的总数量 (推荐根据 数据量 传入, 回调时可根据 index 判断对应数据进行渲染)
- (instancetype)initWithViewClassArr:(NSArray *)viewClassArr count:(NSInteger)count;

/// 开始循环
- (void)start;

/// 停止循环
- (void)stop;

/// 重置为初始化状态 (最好在 停止循环时 使用)
/// 仅重置各参数为 默认值, 如 count 为 1, currentIndex 为 0 等等, 初始化已创建的循环 view 不会重新创建
- (void)reset;

@end



