//
//  RSSTitlesController.h
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//



@class RSSDetailViewController;

@interface RSSTitlesController : UITableViewController <NSXMLParserDelegate>

@property NSString *detailItem;
@property(nonatomic, strong) RSSDetailViewController *rssDetailController;

- (void)reload;

@end
