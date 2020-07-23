//
//  ViewController.m
//  UITimer
//
//  Created by 贾金达 on 2020/7/17.
//  Copyright © 2020 jiajinda. All rights reserved.
//

#import "ViewController.h"
#import "Toast.h"
@interface ViewController ()
@property UILabel *labelTime;
@property NSTimer *timer;
@property NSDate *startDate;
@property NSDate *nowDate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelTime = [[UILabel alloc] init];
    self.labelTime.text = @"00 : 00 : 00";
    self.labelTime.font = [UIFont systemFontOfSize:60];
    self.labelTime.frame = CGRectMake((self.view.frame.size.width-305)/2, 50, 310, 200);
    self.labelTime.textColor = [UIColor blackColor];
    [self.view addSubview:self.labelTime];
    [self createLabelAndButton];
    
}
- (void)createLabelAndButton{
    UIButton *buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame = CGRectMake(self.view.frame.size.width/2+30, 400, 100, 40);
    [buttonStart setTitle:@"开始" forState:UIControlStateNormal];
    [buttonStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonStart.backgroundColor = [UIColor whiteColor];
    [buttonStart addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];

    UIButton *buttonClick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonClick.frame = CGRectMake(self.view.frame.size.width/2-30-100, 400, 100, 40);
    
    
    [buttonClick setTitle:@"停止" forState:UIControlStateNormal];
    [buttonClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonClick.backgroundColor = [UIColor whiteColor];
    [buttonClick addTarget:self action:@selector(touchButtonStop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonClick];
}
- (void)createTimer{
    if(self.timer)
       [self.timer invalidate];
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1/120 target:self selector:@selector(timeRefresh) userInfo:nil repeats:YES];
    
    self.startDate = [NSDate date];
}
- (void)startTimer{
    NSLog(@"START");
    
    [self createTimer];
    NSLog(@"%p",self.timer);
}
- (void)touchButtonStop{
    if([self.timer isValid]){
        [self.view makeToast:@"两秒后停止" duration:1 position:CSToastPositionCenter];
        //将sleepForTimeInterval添加到非主线程，此时UI会正常刷新
        dispatch_queue_global_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"STOP");
            [self stopTimer];
        });
        //以下方法是将sleep添加到了主线程，此时UI界面不会正常刷新
//                    [NSThread sleepForTimeInterval:2];
//                    NSLog(@"STOP");
//                    [self stopTimer];
    
    }
    else{
        self.labelTime.text = @"00 : 00 : 00";
    }
    //self.timer = nil;
    //self.labelTime.text = @"1:0:0";
}
- (void)stopTimer{
        [self.timer invalidate];
        NSLog(@"%p",self.timer);
    
}
- (void)timeRefresh{
    //NSInteger *mid = self.timer.
    double intervals = [[NSDate date] timeIntervalSinceDate:self.startDate];
    int interval_int = (int)intervals;
    NSInteger seconds = (int)intervals%60;
    NSInteger miseconds = (intervals-interval_int)*60;
//    NSLog(@"%ld",miseconds);
//    NSLog(@"%ld",(long)seconds);
    NSInteger mid = (int)intervals/60%60;
    
    NSString *stringText = [NSString stringWithFormat:@"%02ld : %02ld : %02ld",mid,seconds,miseconds];
    self.labelTime.text = stringText;
//    NSString *seconds = [NSString stringWithFormat:@"%02.0f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    
}
@end
