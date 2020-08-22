//
//  ViewController.m
//  LoopContainer
//
//  Created by Chai,Dongpeng on 2020/8/22.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "ViewController.h"

#import "CDPLoopContainer.h" //引入.h文件

@interface ViewController () <CDPLoopContainerDelegate> //代理

@property (nonatomic, strong) CDPLoopContainer *oneContainer;

@property (nonatomic, strong) CDPLoopContainer *twoContainer;

@property (nonatomic, strong) CDPLoopContainer *threeContainer;

@property (nonatomic, strong) CDPLoopContainer *fourContainer;

@property (nonatomic, strong) CDPLoopContainer *fiveContainer;

@property (nonatomic, strong) CDPLoopContainer *sixContainer;

@property (nonatomic, strong) CDPLoopContainer *sevenContainer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.oneContainer];
    [self.oneContainer start];
    
    [self.view addSubview:self.twoContainer];
    [self.twoContainer start];
    
    [self.view addSubview:self.threeContainer];
    [self.threeContainer start];
    
    [self.view addSubview:self.fourContainer];
    [self.fourContainer start];
    
    [self.view addSubview:self.fiveContainer];
    [self.fiveContainer start];
    
    [self.view addSubview:self.sixContainer];
    [self.sixContainer start];
    
    [self.view addSubview:self.sevenContainer];
    [self.sevenContainer start];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 480, 300, 200)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0;
    label.text = @"CDPLoopContainer无限循环滚动容器，可设置内边距，可设置滚动方向，可修改时长，可设置不同 view (包括自定义 view)滚动，以上是个别示例，具体看.h";
    [self.view addSubview:label];
}
#pragma mark - CDPLoopContainerDelegate 容器代理
- (void)loopContainerWillShowView:(UIView *)view index:(NSInteger)index container:(CDPLoopContainer *)container {
    //判断是哪个容器
    if (container == self.oneContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"第1容器,当前index ：%ld", (long)index];
    } else if (container == self.twoContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor yellowColor];
        label.text = [NSString stringWithFormat:@"第2容器,上下左右各设了内边距 ：%ld", (long)index];
    } else if (container == self.threeContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"第3容器,改成向下滚动(上下左右都行) ：%ld", (long)index];
    } else if (container == self.fourContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"第4容器,改成向左滚动(上下左右都行) ：%ld", (long)index];
    } else if (container == self.fiveContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor cyanColor];
        label.text = [NSString stringWithFormat:@"第5容器,左内边距,index ：%ld", (long)index];
    } else if (container == self.sixContainer) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"第6容器,改变动画和停留时长,当前index ：%ld", (long)index];
    } else if (container == self.sevenContainer) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font = [UIFont systemFontOfSize:15];
            label.text = [NSString stringWithFormat:@"第7容器,不同view循环,这是label,%ld", (long)index];
        } else {
            UIButton *bt = (UIButton *)view;
            bt.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bt setTitle:[NSString stringWithFormat:@"第7容器,不同view循环,这是button,%ld", (long)index] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - getter
- (CDPLoopContainer *)oneContainer {
    if (_oneContainer == nil) {
        _oneContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:5];
        _oneContainer.frame = CGRectMake(20, 60, 300, 50);
        _oneContainer.backgroundColor = [UIColor redColor];
        _oneContainer.delegate = self;
    }
    return _oneContainer;
}
- (CDPLoopContainer *)twoContainer {
    if (_twoContainer == nil) {
        _twoContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:3];
        _twoContainer.frame = CGRectMake(20, 120, 300, 50);
        _twoContainer.backgroundColor = [UIColor redColor];
        _twoContainer.delegate = self;
        
        //设置内边距
        _twoContainer.paddingInsets = UIEdgeInsetsMake(10, 5, 3, 20);
    }
    return _twoContainer;
}
- (CDPLoopContainer *)threeContainer {
    if (_threeContainer == nil) {
        _threeContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:4];
        _threeContainer.frame = CGRectMake(20, 180, 300, 50);
        _threeContainer.backgroundColor = [UIColor redColor];
        _threeContainer.delegate = self;
        
        //改变滚动方向
        _threeContainer.direction = CDPLoopContainerDirectionDown;
    }
    return _threeContainer;
}
- (CDPLoopContainer *)fourContainer {
    if (_fourContainer == nil) {
        _fourContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:6];
        _fourContainer.frame = CGRectMake(20, 240, 300, 50);
        _fourContainer.backgroundColor = [UIColor redColor];
        _fourContainer.delegate = self;
        
        //改变滚动方向
        _fourContainer.direction = CDPLoopContainerDirectionLeft;
    }
    return _fourContainer;
}
- (CDPLoopContainer *)fiveContainer {
    if (_fiveContainer == nil) {
        _fiveContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:6];
        _fiveContainer.frame = CGRectMake(20, 300, 300, 50);
        _fiveContainer.backgroundColor = [UIColor redColor];
        _fiveContainer.delegate = self;
        
        //设置内边距
        _fiveContainer.paddingInsets = UIEdgeInsetsMake(0, 100, 0, 0);
        
        //在左内边距范围内加上不滚动的title
        //(也可以设置 上下左右不同内边距 添加其他 view，或者直接在 container 外面添加 view 也行，本 demo 只是一个实现思路)
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 30)];
        label.backgroundColor = [UIColor yellowColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"不滚动控件";
        [_fiveContainer addSubview:label];
    }
    return _fiveContainer;
}
- (CDPLoopContainer *)sixContainer {
    if (_sixContainer == nil) {
        _sixContainer = [[CDPLoopContainer alloc] initWithViewClass:[UILabel class] count:5];
        _sixContainer.frame = CGRectMake(20, 360, 300, 50);
        _sixContainer.backgroundColor = [UIColor redColor];
        _sixContainer.delegate = self;
        
        //改变动画时间和停留时间
        _sixContainer.showDuration = 1;
        _sixContainer.animatedDuration = 2;
    }
    return _sixContainer;
}
- (CDPLoopContainer *)sevenContainer {
    if (_sevenContainer == nil) {
        _sevenContainer = [[CDPLoopContainer alloc] initWithViewClassArr:@[[UILabel class], [UIButton class]] count:5];
        _sevenContainer.frame = CGRectMake(20, 420, 300, 50);
        _sevenContainer.backgroundColor = [UIColor redColor];
        _sevenContainer.delegate = self;
    }
    return _sevenContainer;
}

@end
