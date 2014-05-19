//
// Created by Alexey Ushakov on 3/12/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chrome : NSObject
+(UIActivityIndicatorView *) activityIndicatorForView:(UIView *)view;
+(UIAlertView *) alertViewTitle:(NSString *)title message:(NSString *)msg delegate:(id<UIAlertViewDelegate>)dlg;
@end