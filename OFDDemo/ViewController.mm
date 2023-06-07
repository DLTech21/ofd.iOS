//
//  ViewController.m
//  OFDDemo
//
//  Created by Donal on 2023/6/1.
//

#import "ViewController.h"
#import "OFDParserSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"999" ofType:@"ofd"];
    void *ofd = [OFDParserSDK readOfd:path];
    long counts = [OFDParserSDK getPageCount:ofd];
    NSLog(@"counts: %ld", counts);
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSMutableArray *fonts = [NSMutableArray new];
    NSString *simsun = [[NSBundle mainBundle] pathForResource:@"simsun" ofType:@"ttf"];
    [fonts addObject:@{@"simsun":simsun}];
    [fonts addObject:@{@"SimSong":simsun}];
    [fonts addObject:@{@"宋体":simsun}];
    NSString *kai = [[NSBundle mainBundle] pathForResource:@"simkai" ofType:@"ttf"];
    [fonts addObject:@{@"楷体":kai}];
    [fonts addObject:@{@"kaiti":kai}];
    [fonts addObject:@{@"kaiti_gb2312":kai}];
    NSString *couriernew = [[NSBundle mainBundle] pathForResource:@"cour" ofType:@"ttf"];
    [fonts addObject:@{@"courier new":couriernew}];
    NSString *simfang = [[NSBundle mainBundle] pathForResource:@"SIMFANG" ofType:@"TTF"];
    [fonts addObject:@{@"仿宋":simfang}];
    [fonts addObject:@{@"仿宋_gb2312":simfang}];
    NSString *xiaosong = [[NSBundle mainBundle] pathForResource:@"方正小标宋简体" ofType:@"ttf"];
    [fonts addObject:@{@"小标宋体":xiaosong}];
    [fonts addObject:@{@"方正小标宋简体":xiaosong}];
    NSString *result = [OFDParserSDK drawPage:docsdir pageIndex:0 ofd:ofd fontMap:fonts];
    NSLog(@"result: %@", result);
    
    imageView.image = [UIImage imageWithContentsOfFile:result];
}


@end
