

//
//  ViewController.m
//  Test淘宝首页
//
//  Created by SunSet on 14-8-18.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "ViewController.h"
#import "PullingRefreshTableView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL _loading;//是否正在刷新
    __weak UITableView *_currentTableView;//表格
    
    int _currentIndex;
}
@property(nonatomic,strong) NSArray *sourceArry;//数据源
@end

@implementation ViewController

-(void)dealloc
{
    self.sourceArry = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentIndex = 1;
    [self initView];
    

    self.sourceArry = @[@"asdfasdf",@"2323wqf",@"asdf23",@"23ssdfsd",@"aaaaa",@"ddddd",@"wwwww",@"qqqqq",@"asd",@"asdasd"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 视图初始化
-(void)initView
{
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    scrollView.tag = 1;
//    self.scrollView = scrollView;
//    scrollView.showsVerticalScrollIndicator = NO;
//    
//    scrollView.contentSize = CGSizeMake(320, 2*self.view.bounds.size.height);
//    [self.view addSubview:scrollView];
    
    PullingRefreshTableView *tab = [[PullingRefreshTableView alloc]initWithFrame:self.view.bounds pullingDelegate:self];
    _currentTableView = tab;
    tab.tag = _currentIndex;
    tab.delegate = self;
    tab.dataSource = self;
    tab.rowHeight = 60;
    [self.view addSubview:tab];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellider = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    
    cell.textLabel.text = _sourceArry[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.tag == 1) {
//        return;
//    }
    
    [(PullingRefreshTableView *)scrollView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == 1) {
        return;
    }
    
    [(PullingRefreshTableView *)scrollView tableViewDidEndDragging:scrollView];
}


- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //第一个表格的时候 没有上拉加载更多
    if (tableView.tag == 1) {
        [tableView tableViewDidFinishedLoading];
        return;
    }
    
    [self performSelector:@selector(changeData:) withObject:@YES afterDelay:2];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(changeData:) withObject:@NO afterDelay:2];
}


// 参数:刷新还是上拉加载
-(void)changeData:(NSNumber *)refresh
{
    //上一个表格
    PullingRefreshTableView *tab1 = (PullingRefreshTableView *)[self.view viewWithTag:_currentIndex];
    
    refresh.boolValue ? (_currentIndex--):_currentIndex++;
    PullingRefreshTableView *tab2 = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height * (refresh.boolValue?-1:1), 320, self.view.bounds.size.height) pullingDelegate:self];
    _currentTableView = tab2;
    tab2.tag = _currentIndex;
    tab2.delegate = self;
    tab2.dataSource = self;
    tab2.rowHeight = 60;
    [self.view addSubview:tab2];
    self.sourceArry = @[@"asd",@"cccccc",@"22222",@"aaaaa",@"dddddd",@"2322323",@"zzzz",@"3333",@"asdasdfas",@"23",@"s",@"asd",@"23a",@"aa"];
    
    [UIView animateWithDuration:0.5 animations:^{
        tab1.frame = CGRectMake(0, self.view.bounds.size.height * (refresh.boolValue?1:-1), 320, self.view.bounds.size.height);
        tab2.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [tab1 tableViewDidFinishedLoading];
        [tab1 removeFromSuperview];
    }];
    
//    [self.scrollView setContentOffset:CGPointMake(0, tableView.frame.size.height) animated:YES];
//    [tableView tableViewDidFinishedLoading];
    
}


@end










