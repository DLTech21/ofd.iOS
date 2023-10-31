//
//  OFDParser.h
//  OFDParser
//
//  Created by Donal on 2022/3/25.
//

#import <Foundation/Foundation.h>


@interface OFDParserSDK : NSObject

+(void *)readOfd:(NSString *)path;

+(long)getPageCount:(void *)ofd;

+(NSString *)drawPage:(NSString *)dir pageIndex:(int)Index ofd:(void *)ofd fontMap:(NSMutableArray*)map;

+(void)freeOFD:(void *)ofd;

@end
