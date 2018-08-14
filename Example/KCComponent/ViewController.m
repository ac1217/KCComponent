//
//  ViewController.m
//  KCComponent
//
//  Created by Erica on 2018/8/4.
//  Copyright © 2018年 erica. All rights reserved.
//

#import "ViewController.h"
#import "KCComponent.h"

//#import "SDWebImage.h"
#import "UIImageView+WebCache.h";

@interface ViewController ()<UIScrollViewDelegate, KCBannerViewDelegate, KCBannerViewDataSource>
@property (nonatomic,strong) KCProgressView  *pv;
@property (nonatomic,strong) KCToastView  *tv;
@property (nonatomic, strong) UIScrollView *sv;

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) KCBannerView *bannerView;
@end

@implementation ViewController

- (UIScrollView *)sv
{
    if (!_sv) {
        _sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _sv.alwaysBounceVertical = YES;
        _sv.delegate = self;
    }
    return _sv;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.banners = @[
                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534057732269&di=7dad5b92158df046617c30de11225799&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F21%2F15%2F97F58PICUtf_1024.jpg",
                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534057732266&di=9ec5c1aff7565d6ef9b08e9ac2d5b1ec&imgtype=0&src=http%3A%2F%2Fpic33.nipic.com%2F20130928%2F9431976_001749830375_2.jpg",
                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534057732266&di=bc1867a5e6207b2a4e1aaffe62d953e6&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c38858a7c3caa801219c773abd37.png",
                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534057732263&di=ddc80ab0aa61ab3e49d5eb8888064df5&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01dca8598d703ba801215603377870.png"
                     ];
    // 创建
    KCBannerView *bannerView = [[KCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
//    bannerView.pageControlPosition = KCBannerViewPageControlPositionRight;
    // 设置代理
    bannerView.delegate = self;
    // 数据源
    bannerView.dataSource = self;
    
    //    bannerView.pageControlPosition = KCBannerViewPageControlPositionRight;
//    bannerView.backgroundColor = [UIColor redColor];
    // 添加
    [self.view addSubview:bannerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [bannerView reloadData];
    });

    self.bannerView = bannerView;
//    [self.view addSubview:self.sv];
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
    p.frame = CGRectMake(100,100, 50, 50);
    p.layer.cornerRadius = 10;
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
    self.pv.style = KCProgressViewStyleRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.bannerView.contentOffset = scrollView.contentOffset;
}

- (void)bannerView:(KCBannerView *)bannerView loadItemWith:(UIImageView *)imageView forIndex:(NSInteger)index
{
    
    NSString *url = self.banners[index];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
}

- (NSInteger)numberOfItemsInBannerView:(KCBannerView *)bannerView
{
    return self.banners.count;
}

@end
