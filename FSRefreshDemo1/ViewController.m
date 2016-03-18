//
//  ViewController.m
//  FSRefreshDemo1
//
//  Created by 四维图新 on 16/3/15.
//  Copyright (c) 2016年 四维图新. All rights reserved.
//

#import "ViewController.h"
#import "FSRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView ;

@property (nonatomic, weak) FSRefreshHeader *header;

@property (nonatomic, weak) FSRefreshFooter *footer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [NSMutableArray array];
    
    [self setupTableView];
    
    [self setupHeaderRefreshView];
    
    [self setupFooterRefreshView];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.frame = self.view.bounds;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor redColor];
    
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
}

- (void)setupHeaderRefreshView
{
//    FSRefreshHeader *header = nil;
    
    FSRefreshHeader *header = [[FSRefreshHeader alloc] initWithScrollView:self.tableView];
    
    self.header = header;
    
    [header beginRefreshWithTarget:self refreshAction:@selector(headerRefresh)];
    
//    [header beginRefreshWhenViewWillAppear];
}


- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 1; i++)
        {
            [self.dataArray insertObject:@"付森" atIndex:0];
        }
        
        [self.tableView reloadData];
        
        [self.header endRefreshing];
    });
}


- (void)setupFooterRefreshView
{
    FSRefreshFooter *footer = [[FSRefreshFooter alloc] initWithScrollView:self.tableView];
    
    self.footer = footer;
    
    [footer beginRefreshWithTarget:self refreshAction:@selector(footerRefresh)];
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 5; i++)
        {
            [self.dataArray addObject:@"fusen"];
        }
        
        [self.tableView reloadData];
        
        [self.footer endRefreshing];
        
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
        
//        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行 一共%ld行",indexPath.row + 1,self.dataArray.count + 10];
    
    return cell;
}



@end
