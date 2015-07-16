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

- (void)initBaseURL:(NSMutableArray *)dictionary {
    info = nil;
    feeds = dictionary;
    parseComplete = NO;
    parseFailed = NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;

    item = [[NSMutableDictionary alloc] init];
    title = [[NSMutableString alloc] init];
    link = [[NSMutableString alloc] init];
    description = [[NSMutableString alloc] init];
    date = [[NSMutableString alloc] init];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    parseComplete = YES;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    parseFailed = YES;
}

- (void)urlInfoParser:(NSMutableDictionary *)dictionary parser:(NSXMLParser *)parser {
    [parser setDelegate:self];
    [self initBaseURL:dictionary];
    [parser parse];
    [self parseAll];
}

- (void)urlNewsParser:(NSMutableArray *)dictionary nsUrl:(NSURL *)nsUrl {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:nsUrl];
    [parser setDelegate:self];
    [self initBaseURL:dictionary];
    [parser performSelectorInBackground:@selector(parse) withObject:nil];
    [self parseAll];
}

- (void)parseAll {
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
