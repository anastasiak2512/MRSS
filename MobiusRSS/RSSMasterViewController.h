//
//  RSSMasterViewController.h
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSDetailViewController;
@class RSSTitlesController;

@interface RSSMasterViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) RSSTitlesController *rssTitlesController;

@end