//
//  ViewController.m
//  THDatePickerView
//
//  Created by Apple on 2016/11/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "THDatePickerView.h"

@interface ViewController () <THDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property (weak, nonatomic) THDatePickerView *dateView;
@property (strong, nonatomic) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.hidden = YES;
    self.btn.alpha = 0.3;
    [self.view addSubview:self.btn];
    
    
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    dateView.delegate = self;
    dateView.title = @"请选择时间";
    [self.view addSubview:dateView];
    self.dateView = dateView;
}

// 显示
- (IBAction)timerBrnClick:(id)sender {
    self.btn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.dateView show];
    }];
}

#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    self.timerLbl.text = timer;
    
    self.btn.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    self.btn.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

@end
