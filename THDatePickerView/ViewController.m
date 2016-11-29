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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:self.view.bounds];
    dateView.delegate = self;
    dateView.title = @"请选择时间";
    [self.view addSubview:dateView];
    
    self.dateView = dateView;
}

- (IBAction)timerBrnClick:(id)sender {
    [self.dateView show];
}


/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    
    NSLog(@"保存点击");
    self.timerLbl.text = timer;
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
}

@end
