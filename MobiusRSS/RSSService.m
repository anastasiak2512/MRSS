//
// Created by Alexey Ushakov on 3/5/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSService.h"


@implementation RSSService  {

    NSMutableString *description;
    NSMutableString *link;
    NSMutableArray *feeds;
    NSMutableString *date;
    NSString *element;
    NSMutableDictionary *item;
    NSMutableString *title;
    BOOL parseComplete;
    BOOL parseFailed;
    NSMutableDictionary *info;
}




- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!parseComplete) {
        if ([element isEqualToString:@"title"]) {
            [title appendString:string];
        } else if ([element isEqualToString:@"link"]) {
            [link appendString:string];
        } else if ([element isEqualToString:@"description"]) {
            [description appendString:string];
        } else if ([element isEqualToString:@"pubDate"]) {
            [date appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;

    if (feeds) {
        if ([element isEqualToString:@"item"]) {
            item = [[NSMutableDictionary alloc] init];
            title = [[NSMutableString alloc] init];
            link = [[NSMutableString alloc] init];
            description = [[NSMutableString alloc] init];
            date = [[NSMutableString alloc] init];
        }
    } else if (info) {
        if ([element isEqualToString:@"channel"]) {
            title = [[NSMutableString alloc] init];
            description = [[NSMutableString alloc] init];
            link = [[NSMutableString alloc] init];
        }
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    parseComplete = YES;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //TODO: Report error to the engine above
    parseFailed = YES;
}

- (void)urlInfoParser:(NSMutableDictionary *)dictionary parser:(NSXMLParser *)parser {
    [parser setDelegate:self];
    //TODO: May be dictionary should be checked here
    info = dictionary;
    feeds = nil;
    parseComplete = NO;
    parseFailed = NO;
    [parser parse];
    while (!parseComplete && !parseFailed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
}

- (void)urlNewsParser:(NSMutableArray *)dictionary nsUrl:(NSURL *)nsUrl {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:nsUrl];
    [parser setDelegate:self];
    info = nil;
    feeds = dictionary;
    parseComplete = NO;
    parseFailed = NO;
    [parser performSelectorInBackground:@selector(parse) withObject:nil];
    while (!parseComplete && !parseFailed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                beforeDate:[NSDate distantFuture]];
    }
}

- (BOOL)feedInfoURL:(NSString *)url Info:(NSMutableDictionary *)dictionary {
    NSError *error = nil;
    NSMutableURLRequest *requestXML =
            [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    NSData *data =
            [NSURLConnection sendSynchronousRequest:requestXML returningResponse:nil error:&error];
    if (data == nil) {
        return NO;
    }
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];

    [self urlInfoParser:dictionary parser:parser];
    return parseComplete;
}

- (BOOL)newsURL:(NSString *)url News:(NSMutableArray *)dictionary {
    NSError *error = nil;
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *requestXML =
            [[NSMutableURLRequest alloc] initWithURL:nsUrl];
    NSData *data =
            [NSURLConnection sendSynchronousRequest:requestXML returningResponse:nil error:&error];
    if (data == nil) {
        return NO;
    }
    [self urlNewsParser:dictionary nsUrl:nsUrl];
   return parseComplete;
}

@end
