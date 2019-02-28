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
//    self.title = @"1234";
    
    CAAnimation
    
    KCNavigationView *navView = [KCNavigationView navigationView];
    navView.backgroundColor = [UIColor blackColor];
    navView.title = @"45455";
    [self.view addSubview:navView];
    
    navView.leftButtonItem = [KSNavigationButtonItem itemWithTitle:@"123" handle:^(KSNavigationButtonItem *item) {
        
    }];
    navView.rightButtonItem = [KSNavigationButtonItem itemWithTitle:@"456" handle:^(KSNavigationButtonItem *item) {
        
    }];
    
    navView.titleColor = [UIColor whiteColor];
    
    navView.frame = CGRectMake(0, 44, self.view.bounds.size.width, 64);
    
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
