//
//  THDatePickerView.m
//  rongyp-company
//
//  Created by Apple on 2016/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "THDatePickerView.h"

@interface THDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIView *dataView; // 容器view
@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间


@property (strong, nonatomic) NSMutableArray *yearArr; // 年数组
@property (strong, nonatomic) NSMutableArray *monthArr; // 月数组
@property (strong, nonatomic) NSMutableArray *dayArr; // 日数组
@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSArray *timeArr; // 当前时间数组

@property (copy, nonatomic) NSString *year; // 选中年
@property (copy, nonatomic) NSString *month; //选中月
@property (copy, nonatomic) NSString *day; //选中日
@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分

@end

@implementation THDatePickerView

#pragma mark - init


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.yearArr];
        [self.dataArray addObject:self.monthArr];
        [self.dataArray addObject:self.dayArr];
        [self.dataArray addObject:self.hourArr];
        [self.dataArray addObject:self.minuteArr];
        
        [self configDataView];
        [self configToolView];
        [self configPickerView];
    }
    return self;
}
#pragma mark - 配置界面

- (void)configDataView {
    self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    self.dataView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dataView];
}

/// 配置工具条
- (void)configToolView {
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.toolView.backgroundColor = [UIColor lightGrayColor];
    [self.dataView addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = [UIColor colorWithRed:34 green:34 blue:34 alpha:1];
    [self.toolView addSubview:self.titleLbl];
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.dataView.frame.size.height - 44)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.dataView addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.year = self.timeArr[0];
        self.month = self.timeArr[1];
        self.day = self.timeArr[2];
        self.hour = self.timeArr[3];
        self.minute = self.minuteArr[self.minuteArr.count / 2];
        
        CGRect frame = self.dataView.frame;
        frame.origin.y = self.frame.size.height - 300;
        self.dataView.frame = frame;
        
        self.hidden = NO;
    } completion:^(BOOL finished) {
        
        [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
        /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
        [self.pickerView selectRow:[self.monthArr indexOfObject:[NSString stringWithFormat:@"%ld月", [self.month integerValue]]] inComponent:1 animated:YES];
        [self.pickerView selectRow:[self.dayArr indexOfObject:[NSString stringWithFormat:@"%ld日", [self.day integerValue]]] inComponent:2 animated:YES];
        [self.pickerView selectRow:[self.hourArr indexOfObject:[NSString stringWithFormat:@"%ld时", [self.hour integerValue]]] inComponent:3 animated:YES];
        [self.pickerView selectRow:self.minuteArr.count / 2 inComponent:4 animated:YES];
    }];
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.dataView.frame;
        frame.origin.y = self.frame.size.height;
        self.dataView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        NSInteger index = [self compareDate:[self.timeArr componentsJoinedByString:@","] withDate:[NSString stringWithFormat:@"%@,%@,%@,%@,%@", self.year, self.month, self.day, self.hour, self.minute]];
        switch (index) {
            case -1: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"面试时间小于当前时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } break;
            case 0:
            case 1: {
                if (self.minute.length == 2) {
                    self.selectStr = [NSString stringWithFormat:@"%ld-%ld-%ld  %ld : 0%ld", [self.year integerValue], [self.month integerValue], [self.day integerValue], [self.hour integerValue], [self.minute integerValue]];
                } else {
                    self.selectStr = [NSString stringWithFormat:@"%ld-%ld-%ld  %ld : %ld", [self.year integerValue], [self.month integerValue], [self.day integerValue], [self.hour integerValue], [self.minute integerValue]];
                }
                if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
                    [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr];
                }
            } break;
            default: break;
        }
    }];
    
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.dataView.frame;
        frame.origin.y = self.frame.size.height;
        self.dataView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
            [self.delegate datePickerViewCancelBtnClickDelegate];
        }
    }];
}
/// 点击背景消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelBtnClick];
}


#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  16384;
}

/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self pickerViewLoaded:component row:[self.dataArray[component] count]];
    
//    switch (component) {
//        case 0: { // 年
//            
//            if ([self.yearArr[row] integerValue] < [self.timeArr[component] integerValue]) {
//                
//                
////                [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.dataArray[component] count]+base10 inComponent:component animated:false];
//                
//                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
//            } else {
//                self.year = self.yearArr[row];
//                [self.pickerView selectRow:[self.monthArr indexOfObject:self.timeArr[1]] inComponent:1 animated:YES];
//                [self.pickerView selectRow:[self.dayArr indexOfObject:self.timeArr[2]] inComponent:2 animated:YES];
//                [self.pickerView selectRow:[self.hourArr indexOfObject:self.timeArr[3]] inComponent:3 animated:YES];
//            }
//        } break;
//        case 1: { // 月
//            // 如果选择年大于当前年 就直接赋值月
//            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
//                self.month = self.monthArr[row];
//            // 如果选择的年等于当前年，就判断月份
//            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
//                // 如果选择的月份小于当前月份 就刷新到当前月份
//                if ([self.monthArr[row] integerValue] < [self.timeArr[component] integerValue]) {
//                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
//                // 如果选择的月份大于当前月份，就直接赋值月份
//                } else {
//                    self.month = self.monthArr[row];
//                }
//            }
//        } break;
//        case 2: { // 日
//            // 如果选择年大于当前年 就直接赋值日
//            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
//                self.day = self.dayArr[row];
//                // 如果选择的年等于当前年，就判断月份
//            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
//                // 如果选择的月份大于当前月份 就直接复制
//                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
//                    self.day = self.dayArr[row];
//                // 如果选择的月份等于当前月份，就判断日
//                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
//                    // 如果选择的日小于当前日，就刷新到当前日
//                    if ([self.dayArr[row] integerValue] < [self.timeArr[component] integerValue]) {
//                        [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
//                    // 如果选择的日大于当前日，就复制日
//                    } else {
//                        self.day = self.dayArr[row];
//                    }
//                }
//            }
//        } break;
//        case 3: { // 时
//            // 如果选择年大于当前年 就直接赋值时
//            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
//                self.hour = self.hourArr[row];
//                // 如果选择的年等于当前年，就判断月份
//            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
//                // 如果选择的月份大于当前月份 就直接复制时
//                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
//                    self.hour = self.hourArr[row];
//                    // 如果选择的月份等于当前月份，就判断日
//                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
//                    // 如果选择的日大于当前日，就直接复制时
//                    if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
//                        self.hour = self.hourArr[row];
//                    // 如果选择的日等于当前日，就判断时
//                    } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
//                        // 如果选择的时小于当前时，就刷新到当前时
//                        if ([self.hourArr[row] integerValue] < [self.timeArr[3] integerValue]) {
//                            [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
//                        // 如果选择的时大于当前时，就直接赋值
//                        } else {
//                            self.hour = self.hourArr[row];
//                        }
//                    }
//                }
//            }
//        } break;
//        case 4: { // 分
            // 如果选择年大于当前年 就直接赋值时
//            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
//                self.minute = self.minuteArr[row];
//                // 如果选择的年等于当前年，就判断月份
//            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
//                // 如果选择的月份大于当前月份 就直接复制时
//                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
//                    self.minute = self.minuteArr[row];
//                    // 如果选择的月份等于当前月份，就判断日
//                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
//                    // 如果选择的日大于当前日，就直接复制时
//                    if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
//                        self.minute = self.minuteArr[row];
//                        // 如果选择的日等于当前日，就判断时
//                    } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
//                        // 如果选择的时大于当前时，就直接赋值
//                        if ([self.hour integerValue] > [self.timeArr[3] integerValue]) {
//                            self.minute = self.minuteArr[row];
//                        // 如果选择的时等于当前时,就判断分
//                        } else if ([self.hour integerValue] == [self.timeArr[3] integerValue]) {
//                            // 如果选择的分小于当前分，就刷新分
//                            if ([self.minuteArr[row] integerValue] < [self.timeArr[4] integerValue]) {
//                                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
//                            // 如果选择分大于当前分，就直接赋值
//                            } else {
//                                self.minute = self.minuteArr[row];
//                            }
//                        }
//                    }
//                }
//            }
//        } break;
//        default: break;
//    }
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    myView.font = [UIFont systemFontOfSize:15];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    return myView;
}

- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}


/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int i = 1970; i < 2099; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    }
    return _yearArr;
}

/// 获取月份
- (NSMutableArray *)monthArr {
//    NSDate *today = [NSDate date];
//    NSCalendar *c = [NSCalendar currentCalendar];
//    NSRange days = [c rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:today];
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        NSDate *today = [NSDate date];
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
        for (int i = 1; i <= days.length; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
        }
    }
    return _dayArr;
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 1; i <= 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i <= 55; i ++) {
            if (i % 5 == 0) {
                [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
                continue;
            }
        }
    }
    return _minuteArr;
}

// 获取当前的年月日时
- (NSArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年,MM月,dd日,HH时,mm分"];
        NSDate *date = [NSDate date];
        NSString *time = [formatter stringFromDate:date];
        _timeArr = [time componentsSeparatedByString:@","];
    }
    return _timeArr;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年,MM月,dd日,HH时,mm分"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


@end
