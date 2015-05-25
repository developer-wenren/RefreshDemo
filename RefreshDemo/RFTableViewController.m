//
//  RFTableViewController.m
//  RefreshDemo
//
//  Created by zjsruxxxy3 on 15/5/25.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "RFTableViewController.h"
#import <MJRefresh.h>


@interface RFTableViewController ()

-(IBAction)pullToRefresh:(UIRefreshControl *)sender;

@property(nonatomic,strong)NSMutableArray *dateArray;

@property(nonatomic,weak) MJRefreshHeader *header;
@property(nonatomic,weak) MJRefreshFooter *footer;


@end

@implementation RFTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl.tintColor = [UIColor grayColor];
    
    
//    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    __weak typeof(self) weak_self = self;
    
    MJRefreshLegendHeader *refresh = [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weak_self pullToRefresh:nil];
        

    } dateKey:nil];
    
    self.header = refresh;

    MJRefreshLegendFooter *footer = [self.tableView addLegendFooterWithRefreshingBlock:^{
    
//            NSLog(@"-----");
    
            [weak_self pullToRefresh:nil];
    
        }];
    
    [footer setTitle:@"wrcj" forState:MJRefreshFooterStateIdle];
    
    self.footer = footer;
    
    self.footer.automaticallyRefresh = NO;
    
}

-(void)pullToRefresh:(UIRefreshControl *)sender{
   
    int counts = (int) self.dateArray.count+1;
    
    for (int a = 0; a<20; a++)
    {
        [self.dateArray addObject:[NSNumber numberWithInt:a+counts+1]];
        
    }
    
    [self.tableView reloadData];
    
//    [self.refreshControl endRefreshing];
    
    [self.header endRefreshing];
    
    [self.footer endRefreshing];
    [self.footer noticeNoMoreData];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dateArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.refreshControl  endRefreshing];

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
