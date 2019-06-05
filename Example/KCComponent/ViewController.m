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
//#import "UIImageView+WebCache.h";

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    KCNavigationView *navView = [KCNavigationView navigationView];

    navView.frame = CGRectMake(0, 44, self.view.bounds.size.width, 44);
    navView.backgroundColor = [UIColor blackColor];
//    navView.title = @"标题第三方esfd第三方水电费水电费第三方试过是的";
    [self.view addSubview:navView];
    
    KSNavigationButtonItem *titleItem1 = [KSNavigationButtonItem itemWithTitle:@"223" handle:^(KSNavigationButtonItem *item) {
        
    }];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    view.backgroundColor = [UIColor redColor];

    KSNavigationButtonItem *viewItem = [KSNavigationButtonItem itemWithCustomView:view];

    navView.leftButtonItems = @[titleItem1, viewItem];

    KSNavigationButtonItem *stItem = [KSNavigationButtonItem itemWithCustomView:[UISwitch new]];
    KSNavigationButtonItem *titleItem  = [KSNavigationButtonItem itemWithTitle:@"aa" handle:^(KSNavigationButtonItem *item) {

    }];

    navView.rightButtonItems = @[stItem, titleItem];

    navView.titleColor = [UIColor whiteColor];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 500, 35)];
    textField.backgroundColor = [UIColor redColor];

    navView.titleView = textField;

//    UISwitch *st = [UISwitch new];
//
//    navView.titleView = st;
    
//    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
//self.navigationController.navigationBar.prefersLargeTitles = YES;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"123" style:0 target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"456" style:0 target:nil action:nil];
    
//    UISearchController *searchC = [[UISearchController alloc]initWithSearchResultsController:nil];
//    [searchC setActive:YES];
//    searchC.searchBar.placeholder = @"Search music/author name.";
    
    
//    self.navigationItem.searchController = searchC;
    
    
}

@end
