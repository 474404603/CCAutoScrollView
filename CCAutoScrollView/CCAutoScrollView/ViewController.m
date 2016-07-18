//
//  ViewController.m
//  CCAutoScrollView
//
//  Created by Mr Cai on 16/5/16.
//  Copyright © 2016年 Mr Cai. All rights reserved.
//

#import "ViewController.h"
#import "CCAutoScrollView.h"
#import "LexiconHeadView.h"

@interface ViewController ()<AutoScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //本地图片
    CCAutoScrollView *scrollView = [[CCAutoScrollView alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 150)];
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"image1"],[UIImage imageNamed:@"image2.jpg"],[UIImage imageNamed:@"image3.jpg"],[UIImage imageNamed:@"image4.jpg"], nil];
    
    scrollView.isCycleRoll = YES;
    scrollView.pageControlPosition = LeftPageControl;
    [scrollView setImagesGroup:images];
    [self.view addSubview:scrollView];
    
    
    //网络图片
    CCAutoScrollView *urlscrollView = [[CCAutoScrollView alloc] initWithFrame:CGRectMake(10, 250, self.view.bounds.size.width-20, 150)];
    
    NSMutableArray *urlImages = [[NSMutableArray alloc] initWithObjects:@"http://img.pconline.com.cn/images/upload/upc/tx/itbbs/1402/27/c4/31612517_1393474458218_mthumb.jpg",@"http://rescdn.qqmail.com/dyimg/20140516/7E079BD74EF3.jpg",@"http://v1.qzone.cc/pic/201510/31/11/17/563432b7977c7764.jpeg%21600x600.jpg",@"http://img1.3lian.com/img13/c3/10/d/34.jpg", nil];
    
    urlscrollView.isCycleRoll = YES;
    [urlscrollView setUrlImageGroup:urlImages];
    [self.view addSubview:urlscrollView];
    
    
    //VIEW类型
    CCAutoScrollView *viewScrollView = [[CCAutoScrollView alloc] initWithFrame:CGRectMake(10, 450, self.view.bounds.size.width-20, 150) withSylteType:ViewSylteType];
    viewScrollView.delegate = self;
    
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        LexiconHeadView *view = [[LexiconHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 150)];
        [viewArray addObject:view];
    }
    
    viewScrollView.isCycleRoll = YES;
    viewScrollView.pageControlPosition = RightPageControl;
    [viewScrollView setImagesGroup:viewArray];
    [self.view addSubview:viewScrollView];
}


- (void)autoScrollView:(CCAutoScrollView *)collectionView didSelectItemAtIndex:(NSInteger)index
{

   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
