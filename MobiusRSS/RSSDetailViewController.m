//
//  RSSDetailViewController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()

@property(nonatomic) IBOutlet UIWebView *webView;
@end

@implementation RSSDetailViewController
@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Details", @"Details");
    }
    return self;
}

- (void)reload {
    NSString *html = [NSString stringWithFormat:@"<html><body>%@<body></html>", [item valueForKey:@"description"]];
    [self.webView loadHTMLString:html baseURL:nil];
}
@end
