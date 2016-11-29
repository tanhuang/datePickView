# datePickView
年月日时分时间选择器


支持选择年月日时分的日期选择器，分的间隔是5分，


![Alt text](https://raw.githubusercontent.com/tanhuang/datePickView/master/image1.png)
![Alt text](https://raw.githubusercontent.com/tanhuang/datePickView/master/image2.png)


#### Installation 安装
手动导入：将THDatePickerView文件夹拽入项目中，导入头文件：#import "THDatePickerView.h"

#### Example 例子  
// 创建  

  ` THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:self.view.bounds];`  
  
  ` dateView.delegate = self;`  
  
  ` dateView.title = @"请选择时间";`  
  
  `[self.view addSubview:dateView];`  
  
    
// 显示  

`- (IBAction)timerBrnClick:(id)sender {`  

   `[self.dateView show];`  
   
`}`

/**  

保存按钮代理方法  

 
 @param timer 选择的数据  
 
 */  
 
`- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {`  

    
   ` NSLog(@"保存点击");`  
   
   ` self.timerLbl.text = timer;`  
   
`}`

/**
 取消按钮代理方法  
 
 */
`- (void)datePickerViewCancelBtnClickDelegate {`  

   ` NSLog(@"取消点击");`  
   
`}`

使用简单
