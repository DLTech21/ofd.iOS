//
//  ViewController.m
//  OFDDemo
//
//  Created by Donal on 2023/6/1.
//

#import "ViewController.h"
#import <ofdparser_framework/ofdparser_framework.h>

@interface ViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imageVCs;

@property (nonatomic, strong) NSMutableArray *fonts;

@property (nonatomic, strong) NSValue *ofdVaule;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *path = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"ofd"];
    void *ofd = [OFDParserSDK readOfd:path];
    long counts = [OFDParserSDK getPageCount:ofd];
    self.ofdVaule = [NSValue valueWithPointer:ofd];
    NSLog(@"ofd file page counts: %ld", counts);

    _fonts = [NSMutableArray new];
    NSString *simsun = [[NSBundle mainBundle] pathForResource:@"simsun" ofType:@"ttf"];
    [_fonts addObject:@{@"simsun":simsun}];
    [_fonts addObject:@{@"SimSong":simsun}];
    [_fonts addObject:@{@"宋体":simsun}];
    NSString *kai = [[NSBundle mainBundle] pathForResource:@"simkai" ofType:@"ttf"];
    [_fonts addObject:@{@"楷体":kai}];
    [_fonts addObject:@{@"kaiti":kai}];
    [_fonts addObject:@{@"kaiti_gb2312":kai}];
    NSString *couriernew = [[NSBundle mainBundle] pathForResource:@"cour" ofType:@"ttf"];
    [_fonts addObject:@{@"courier new":couriernew}];
    NSString *simfang = [[NSBundle mainBundle] pathForResource:@"SIMFANG" ofType:@"TTF"];
    [_fonts addObject:@{@"仿宋":simfang}];
    [_fonts addObject:@{@"仿宋_gb2312":simfang}];
    NSString *xiaosong = [[NSBundle mainBundle] pathForResource:@"方正小标宋简体" ofType:@"ttf"];
    [_fonts addObject:@{@"小标宋体":xiaosong}];
    [_fonts addObject:@{@"方正小标宋简体":xiaosong}];
        
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"click" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(userClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.imageVCs = [NSMutableArray array];
//    UIImage *image = [self ofdImageWithIndex:0];
//    UIViewController *vc = [self newPageViewControllerWithImage:image];
//    [self.imageVCs addObject:vc];
    for (int i = 0; i < counts; i++){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage *image = [self ofdImageWithIndex:i];
            UIViewController *vc = [self newPageViewControllerWithImage:image];
            [self.imageVCs addObject:vc];
        });
    }
}

- (void)userClickBtn {
    UIPageViewController *pageVc = [UIPageViewController new];
    pageVc.view.backgroundColor = [UIColor blackColor];
    pageVc.dataSource = self;
    pageVc.delegate = self;
    [pageVc setViewControllers:@[self.imageVCs.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    [self presentViewController:pageVc animated:YES completion:nil];
}

- (nullable UIImage*)ofdImageWithIndex:(int)index {
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    void *ofd = [self.ofdVaule pointerValue];
    NSString *result = [OFDParserSDK drawPage:docsdir pageIndex:index ofd:ofd fontMap:self.fonts];
    NSLog(@"result: %@   ---   page index:%d", result, index);
    return [UIImage imageWithContentsOfFile:result];
}

- (nullable UIViewController *)newPageViewControllerWithImage:(UIImage *)image {
    UIViewController *vc = [UIViewController new];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = image;
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [vc.view addSubview:imageView];
    
    return vc;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSInteger currentIndex = [self.imageVCs indexOfObject:viewController];

    NSInteger nextIndex = currentIndex + 1;
    
    if (nextIndex >= self.imageVCs.count) {
        return nil;
    }
    
    UIViewController *nextViewController = self.imageVCs[nextIndex];

    return nextViewController;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    NSInteger currentIndex = [self.imageVCs indexOfObject:viewController];
    
    NSInteger previousIndex = currentIndex - 1;

    if (previousIndex < 0) {
        return nil;
    }

    UIViewController *previousViewController = self.imageVCs[previousIndex];

    return previousViewController;
}


@end
