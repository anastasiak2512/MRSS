//
//  RSSTitlesController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSTitlesController.h"
#import "RSSDetailViewController.h"
#import "TitleTableCell.h"
#import "RSSService.h"

@interface RSSTitlesController () {
    NSMutableArray *feeds;
    RSSService *rss;
}

@end

@implementation RSSTitlesController
@synthesize detailItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Title", @"Title");
        rss = [[RSSService alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)reload {
    feeds = [[NSMutableArray alloc] init];
    [rss newsURL:self.detailItem News:feeds];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TitleTableCell";
    static NSString *CellNib = @"TitleTableCell";

    TitleTableCell *cell = (TitleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (TitleTableCell *) nib[0];
    }

    cell.title.text =  [[feeds objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"title"];
    cell.title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.title.numberOfLines = 0;

    //TODO: put date extraction to a separate method
    [self extrDate:indexPath cell:cell];

    cell.date.lineBreakMode = NSLineBreakByWordWrapping;
    cell.date.numberOfLines = 0;

    return cell;
}

- (void)extrDate:(NSIndexPath *)indexPath cell:(TitleTableCell *)cell {
    NSArray *formats = @[@"dd MMM yyyy HH:mm:ss Z", @"EEE, dd MMM yyyy HH:mm:ss Z"];
    NSString *strDate = [[feeds objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"pubDate"];
    strDate = [strDate componentsSeparatedByString:@"\n"][0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = nil;
    for (NSString *f in formats) {
        [formatter setDateFormat:f];
        date = [formatter dateFromString:strDate];
        if (date) break;
    }
    if (date) {
        [formatter setDateFormat:@"HH:mm dd.MM.yyyy "];
        cell.date.text = [formatter stringFromDate:date];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rssDetailController) {
        self.rssDetailController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetailViewController"
                                                                             bundle:nil];
    }
    NSDictionary *object =
            [feeds objectAtIndex:(NSUInteger) indexPath.row];
    self.rssDetailController.item = [object copy];
    [self.navigationController pushViewController:self.rssDetailController animated:YES];
}
@end
