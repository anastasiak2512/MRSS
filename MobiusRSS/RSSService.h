//
// Created by Alexey Ushakov on 3/5/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSSService : NSObject <NSXMLParserDelegate> {
}

-(BOOL)feedInfoURL:(NSString *)url Info:(NSMutableDictionary *)dictionary;
-(BOOL)newsURL:(NSString *)url News:(NSMutableArray *)dictionary;

@end