//
//  IndexViewController.m
//  Test淘宝首页
//
//  Created by SunSet on 14-8-18.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "IndexViewController.h"
#import "PullingRefreshTableView/PullingRefreshTableView.h"

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL _loading;
    PullingRefreshTableView *_currentRefreshView; //刷新视图
}

@property(nonatomic,weak) UIScrollView *scrollView; //当前表格
@end

@implementation IndexViewController

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
    
    [self initScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView = scrollView;
    scrollView.tag = 1;
    scrollView.delegate = self;
//    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(320, 600+80);
    [self.view addSubview:scrollView];
    scrollView.delaysContentTouches = NO;
    
    //第一部分
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    view.backgroundColor = [UIColor blueColor] ;
    [scrollView addSubview:view];
    
    //第二部分
    PullingRefreshTableView *tab = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 600, 320, self.view.bounds.size.height) pullingDelegate:self];
    tab.dataSource = self;
    tab.delegate = self;
    tab.rowHeight = 70;
//    tab.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    [scrollView addSubview:tab];
    _currentRefreshView = tab;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellider = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
        
    }
    cell.textLabel.text = @"淘宝商品";
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@" scrollView 的偏移量 %@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.tag == 1) {
        return;
    }
    
    //    [(PullingRefreshTableView *)scrollView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == 1) {
        if (scrollView.contentOffset.y >=150) {
            NSLog(@"偏移了");
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//            [scrollView setContentSize:CGSizeMake(320, 600+scrollView.frame.size.height)];
//
        }
        return;
    }
//    [(PullingRefreshTableView *)scrollView tableViewDidEndDragging:scrollView];
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView.tag == 1) {
//        NSLog(@"偏移了");
//        [scrollView setContentOffset:CGPointMake(0, 600) animated:YES];
//    }
//}


- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [tableView tableViewDidFinishedLoading];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [tableView tableViewDidFinishedLoading];
//    [self performSelector:@selector(changeData:) withObject:@NO afterDelay:2];
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@" gestureRecognizerShouldBegin %@ ",gestureRecognizer.view);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@" gestureRecognizer %@ ",gestureRecognizer.view);
    return YES;
}

@end







