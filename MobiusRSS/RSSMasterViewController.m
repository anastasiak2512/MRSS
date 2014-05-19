//
//  RSSMasterViewController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSMasterViewController.h"

#import "RSSTitlesController.h"
#import "Config.h"
#import "Chrome.h"

@interface RSSMasterViewController ()
@end

@implementation RSSMasterViewController {
    UIActivityIndicatorView *_activityIndicatorView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"MobileRSS", @"Mobile RSS Reader");
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
            target:self
            action:@selector(insertNewObject:)];

    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)removeFeed:(NSUInteger)num {
    Config *cfg = [Config instance];
    [cfg.items removeObjectAtIndex:num];
    [cfg write];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
    [Chrome alertViewTitle:@"RSS Feed" message:@"Input rss feed" delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)text {
    _activityIndicatorView = [Chrome activityIndicatorForView:self.view.superview];

    if (![[Config instance] addFeed:[[alertView textFieldAtIndex:0] text]]) {
        [Chrome alertViewTitle:@"RSS Feed" message:@"Cannot add rss feed" delegate:nil];
        [_activityIndicatorView removeFromSuperview];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [_activityIndicatorView removeFromSuperview];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Config instance].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [[Config instance].items[(NSUInteger) indexPath.row] valueForKey:@"title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFeed:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rssTitlesController) {
        self.rssTitlesController = [[RSSTitlesController alloc] initWithNibName:@"RSSTitlesController" bundle:nil];
    }
    self.rssTitlesController.detailItem = [[Config instance].items[(NSUInteger) indexPath.row] valueForKey:@"url"];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [Chrome activityIndicatorForView:nil];

    dispatch_queue_t loadQueue = dispatch_queue_create("Load Queue",NULL);

    dispatch_async(loadQueue, ^{
        [self.rssTitlesController reload];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:self.rssTitlesController animated:YES];
            cell.accessoryView = nil;
        });
    });
}

@end


