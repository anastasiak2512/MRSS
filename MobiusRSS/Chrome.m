//
// Created by Alexey Ushakov on 3/12/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "Chrome.h"


@implementation Chrome

+ (UIActivityIndicatorView *)activityIndicatorForView:(UIView *)view {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    [activityIndicatorView startAnimating];
    if (view) {
        CGSize size = view.frame.size;
        activityIndicatorView.center = CGPointMake(size.width/2.0, size.height/2.0);
        [view addSubview:activityIndicatorView];
    }

    return activityIndicatorView;
}

+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)msg delegate:(id <UIAlertViewDelegate>)dlg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:dlg
                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = (dlg) ? UIAlertViewStylePlainTextInput : UIAlertViewStyleDefault;
    [alert show];
    return alert;
}

@end
