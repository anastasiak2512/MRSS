//
// Created by Alexey Ushakov on 3/9/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject
- (instancetype)initWithConfigPath:(NSString *)configPath;

+ (Config *)instance;

-(NSMutableArray *)items;
-(void)write;
-(void)load;

- (BOOL)addFeed:(NSString *)url;
@end