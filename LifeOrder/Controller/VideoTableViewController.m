//
//  VideoTableViewController.m
//  LifeOrder
//
//  Created by 1000653 on 2014. 10. 8..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "VideoTableViewController.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>

@interface VideoTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UITableView *captionTableView;
@property(nonatomic, strong) NSArray *data;
@end

@implementation VideoTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Custom initialization
    if(self.data == nil) {
        self.data = @[@"1", @"2", @"3", @"caption", @"caption2", @"caption3", @"caoption4"];
    }

    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController =
        [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"vN4U5FqrOdQ"];
    [videoPlayerViewController presentInView:self.videoView];
    [videoPlayerViewController.moviePlayer play];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //[self loadRequestFromString:@"http://www.google.com"];
}
- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   // [self.videoView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
  
//        cell = [tableView dequeueReusableCellWithIdentifier:@"videoPlay" forIndexPath:indexPath];
//        
//        // Configure the cell...
//       // cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
//      //   cell.textLabel.text = @"Video cell";
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,200,100)];
//        [webView loadHTMLString:@"web <b>View</b><br><br>my View<br>" baseURL:nil];
//        webView.userInteractionEnabled = YES;
//        [cell.contentView addSubview:webView];
//         [webView.scrollView setBounces:NO];

    cell = [tableView dequeueReusableCellWithIdentifier:@"caption" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];

    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
