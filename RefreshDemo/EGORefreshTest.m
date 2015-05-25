//
//  EGORefreshTest.m
//  RefreshDemo
//
//  Created by zjsruxxxy3 on 15/5/25.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "EGORefreshTest.h"
#import <EGOTableViewPullRefreshAndLoadMore/EGORefreshTableHeaderView.h>
#import <EGOTableViewPullRefreshAndLoadMore/LoadMoreTableFooterView.h>


@interface EGORefreshTest ()<EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>
{
    EGORefreshTableHeaderView *_headerView;
    
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *_footerView;
    
    
}

@property(nonatomic,strong)NSMutableArray *dateArray;

@end

@implementation EGORefreshTest

-(NSMutableArray *)dateArray{
    
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray arrayWithObjects:@1,@2,@3,@5,@6,@7,@8,@9,@10, nil];
        
    }
    
    return _dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    _headerView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) arrowImageName:nil textColor:[UIColor greenColor]];
    
    isRefreshing = NO;
    
    _headerView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _headerView.delegate = self;
    
    [self.tableView addSubview:_headerView];
    
    _footerView = [[LoadMoreTableFooterView alloc]initWithFrame:CGRectMake(0.f, self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    _footerView.delegate = self;
    
    [self.tableView addSubview:_footerView];
    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [_headerView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
//        
//    });
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
    
    [_footerView loadMoreScrollViewDidScroll:scrollView];
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    
    [_footerView loadMoreScrollViewDidEndDragging:scrollView];
    
}

-(void)pullToRefresh:(UIRefreshControl *)sender{
    
    int counts = (int) self.dateArray.count+1;
    
    for (int a = 0; a<20; a++)
    {
        [self.dateArray addObject:[NSNumber numberWithInt:a+counts+1]];
        
    }
    
    [self.tableView reloadData];

    
}

-(void)reloadData {
    
    
    [self pullToRefresh:nil];
    
    _footerView.frame = CGRectMake(0, self.tableView.contentSize.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dateArray[indexPath.row]];
    
    return cell;
}


#pragma mark EGODelegate

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    
//    NSLog(@"%s",__func__);
    
    return isRefreshing;
    
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
 
    return  [NSDate date];
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    
//    NSLog(@"%s",__func__);

    isRefreshing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        sleep(1);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            isRefreshing = NO;

            [self reloadData];
            
            [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
//            self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
            
        });
        
        
        
    });
    
}


- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
    
    return isRefreshing;
    
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view {
    
    isRefreshing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
        sleep(2);

        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            isRefreshing = NO;

            [self reloadData];
            
            [_footerView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
        

        
    });
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
