//
//  GlobalVariable.m
//  Hinter
//
//  Created by igenius on 2016/11/22.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "GlobalVariable.h"

static NSArray *hinterArray = nil;


@implementation GlobalVariable

+ (void)setHinterArray:(NSMutableArray *)tempArray
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"hintsCollect.plist"];


    hinterArray = tempArray;
    [hinterArray writeToFile:filePath atomically:YES];
}



+ (NSArray *)getHinterArray
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"hintsCollect.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        hinterArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return hinterArray;
}

@end
