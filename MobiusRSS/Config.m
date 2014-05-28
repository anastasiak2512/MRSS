//
// Created by Alexey Ushakov on 3/9/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "Config.h"
#import "RSSService.h"
#import "PListService.h"


@implementation Config {
    NSString *_configPath;
    NSMutableDictionary *_values;

    RSSService *_rssService;
}

+ (Config *)instance {
    static Config *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithConfigPath:@"Config"];
        }
    }

    return _instance;
}

- (instancetype)initWithConfigPath:(NSString *)configPath {
    self = [super init];
    if (self) {
        _configPath = configPath;
        _rssService = [[RSSService alloc] init];
        [self load];
    }

    return self;
}

- (NSMutableArray *)items {
    return [_values valueForKey:@"items"];
}

- (void)write {
    NSString *path = [[NSBundle mainBundle] pathForResource:_configPath ofType:@"plist"];

    [PListService writePlist:_values fileName:path];
}

- (void)load {
    NSString *path = [[NSBundle mainBundle] pathForResource:_configPath ofType:@"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        _values = [PListService readPlist:path];
        if (_values) return;
    }
    _values = [NSMutableDictionary dictionary];
    [_values setObject:[NSMutableArray new] forKey:@"items"];
}

- (BOOL)addFeed:(NSString *)url {
    NSMutableArray *items = self.items;
    NSMutableDictionary *elem = [NSMutableDictionary new];
    [elem setObject:url forKey:@"url"];
    NSMutableDictionary *info = [NSMutableDictionary new];
    BOOL res = [_rssService feedInfoURL:url Info:info];
    if (!res) {
        return NO;
    }
    elem[@"title"] = [info valueForKey:@"title"];
    [items insertObject:elem atIndex:0];
    [self write];
    return YES;
}

@end
