//
// Created by Alexey Ushakov on 3/10/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PListService : NSObject
+ (NSMutableDictionary *)readPlist:(NSString *)fileName;
+ (void)writePlist:(NSObject *)plist fileName:(NSString *)fileName;
@end