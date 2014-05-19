//
// Created by Alexey Ushakov on 3/10/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "PListService.h"


@implementation PListService {

}

+ (NSMutableDictionary *)readPlist:(NSString *)fileName {
    NSData *plistData;
    NSError *error;
    NSPropertyListFormat format;
    id plist;
    plistData = [NSData dataWithContentsOfFile:fileName];

    plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainersAndLeaves
                                               format:&format error:&error];
    if (!plist) {
        NSLog(@"Error reading plist from file '%@', error = '%@'", fileName, error);
    }
    else if (![plist isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Unsupported plist format");
        return nil;
    }

    return plist;
}

+ (void)writePlist:(id)plist fileName:(NSString *)fileName {
    NSData *xmlData;
    NSError *error;

    xmlData = [NSPropertyListSerialization dataWithPropertyList:plist
                                                         format:NSPropertyListBinaryFormat_v1_0
                                                        options:NSPropertyListMutableContainersAndLeaves error:&error];
    if (xmlData) {
        [xmlData writeToFile:fileName atomically:YES];
    } else {
        NSLog(@"Error writing plist to file '%@', error = '%@'", fileName, error);
    }
}
@end