//
//  ViewController.m
//  KCComponent
//
//  Created by Erica on 2018/8/4.
//  Copyright © 2018年 erica. All rights reserved.
//

#import "ViewController.h"
#import "KCComponent.h"

@interface ViewController ()
@property (nonatomic,strong) KCProgressView  *pv;
@property (nonatomic,strong) KCToastView  *tv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sheet:(id)sender {
    
    KCAlertAction *cancel = [KCAlertAction actionWithTitle:@"取消" style:KCAlertActionStyleCancel handler:^(KCAlertAction *action) {
        
    }];
    KCAlertAction *item0 = [KCAlertAction actionWithTitle:@"item0" style:KCAlertActionStyleDefault handler:^(KCAlertAction *action) {
        
    }];
    KCAlertAction *item1 = [KCAlertAction actionWithTitle:@"item1" style:KCAlertActionStyleDestructive handler:^(KCAlertAction *action) {
        
    }];
    
    KCAlertView *alert = [KCAlertView alertViewWithStyle:KCAlertViewStyleActionSheet title:nil detail:@"23131" actions:@[item0, cancel, item1]];
    alert.backgroundDismiss = YES;
    [alert showInView:self.view];
    
}

- (IBAction)alert:(id)sender {
    
    KCProgressView *p = [[KCProgressView alloc] init];
//    p.style = KCProgressViewStyleCircle;
    p.frame = CGRectMake(100,100, 100, 100);
//    p.backgroundColor = [UIColor redColor];
    [self.view addSubview:p];
    self.pv = p;
    
    KCToastView *toastView = [[KCToastView alloc] init];
    toastView.style = KCToastViewStyleProgress;
//    toastView.layoutDirection = KCToastViewLayoutDirectionVertical;
    toastView.text = @"正在上传...";
    toastView.duration = 0;
//    toastView.progressView.style = KCProgressViewStyleLine;
//    toastView.progressView.progressTextFont = [UIFont systemFontOfSize:12];
//    toastView.progressSize = CGSizeMake(100, 30);
    [toastView showInView:self.view];
    self.tv = toastView;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSInteger count = arc4random_uniform(100);
    
    self.pv.progress = count / 100.0;
    
    self.tv.progress = self.pv.progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
