//
//  CCAutoScrollView.m
//  CCAutoScrollView
//
//  Created by Mr Cai on 15/11/9.
//  Copyright © 2015年 Mr Cai. All rights reserved.
//

#import "CCAutoScrollView.h"
#import "CCImageCollectionCell.h"
#import "CCViewCollectionCell.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

NSString * const CellImageID = @"CCCollectionCell";
NSString * const CellViewID = @"CCViewCollectionCell";


@interface CCAutoScrollView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    //页数
    NSInteger totalItemsCount;
    //一个定时器
    NSTimer *timer;
}
@property (nonatomic, strong) CCViewCollectionCell *prototypeCell;
@end


@implementation CCAutoScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self initParameter];
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withSylteType:(CellSylteType)type
{
    if (self == [super initWithFrame:frame]) {
        _cellSylteType = type;
        self.isCycleRoll = NO;
        self.pageControlPosition = CenterPageControl;
        [self initView];
    }
    return self;
}


/**
 *  初始化参数
 */
- (void)initParameter
{
    _cellSylteType = ImageSylteType;
    self.isCycleRoll = NO;
    self.pageControlPosition = CenterPageControl;
}


- (void)initView
{
    
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.pageControl];
}



#pragma mark - getters and setters


- (void)setPageControlPosition:(PageControlPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    //PageControl的位置
    CGSize size = CGSizeZero;
    size = CGSizeMake(self.imagesGroup.count * 10 * 1.2, 10);
    
    CGFloat x = 0;
    CGFloat y = self.bounds.size.height - size.height - 5;
    
    
    if (pageControlPosition == CenterPageControl) {
        x = (self.bounds.size.width - size.width) * 0.5;  //居中
        
    }
    if (pageControlPosition == LeftPageControl) {
        x = 10;    //居左
    }
    
    if (pageControlPosition == RightPageControl) {
        x = self.bounds.size.width - size.width - 10;    //居右
    }
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
}

- (void)setIsCycleRoll:(BOOL)isCycleRoll
{
    _isCycleRoll = isCycleRoll;
    if (_isCycleRoll) {
        [self addTimer];
    }else {
        [self removeTimer];
    }
    
}

- (void)setImagesGroup:(NSMutableArray *)imagesGroup
{
    
    _imagesGroup = imagesGroup;
    
    //计算页数
    totalItemsCount = self.isCycleRoll ? self.imagesGroup.count * 100 : self.imagesGroup.count;
    [self.mainCollectionView reloadData];
    if ([self.imagesGroup count] > 1) {
        self.pageControl.numberOfPages = [self.imagesGroup count];
        self.pageControlPosition = _pageControlPosition;
    }
    
}


- (void)setUrlImageGroup:(NSMutableArray *)imageUrlGroup
{
    _urlImageGroup = imageUrlGroup;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [imageUrlGroup enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        UIImage *image = [[UIImage alloc] init];
        [images addObject:image];
    }];
    self.imagesGroup = images;
    [self loadImageWithImageURLsGroup:imageUrlGroup];
}

- (UICollectionView*)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.frame.size;
        
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        
        
        if (_cellSylteType == ViewSylteType) {
            [_mainCollectionView registerClass:[CCViewCollectionCell class] forCellWithReuseIdentifier:CellViewID];
        } else {
            [_mainCollectionView registerClass:[CCImageCollectionCell class] forCellWithReuseIdentifier:CellImageID];
        }
        
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
    }
    return _mainCollectionView;
}

- (UIPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = [self.imagesGroup count];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return totalItemsCount;
    
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (_cellSylteType == ViewSylteType) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellViewID forIndexPath:indexPath];
        
        long itemIndex = indexPath.item % self.imagesGroup.count;
        
        UIView *collectionview = [_imagesGroup objectAtIndex:itemIndex];
        for(UIView *view in [((CCViewCollectionCell*)cell).cellView subviews]){
            [view removeFromSuperview];
        }
        [((CCViewCollectionCell*)cell).cellView addSubview:collectionview];
        
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellImageID forIndexPath:indexPath];
        
        long itemIndex = indexPath.item % self.imagesGroup.count;
        
        UIImage *image = [_imagesGroup objectAtIndex:itemIndex];
        
        [((CCImageCollectionCell*)cell).cellImageView setImage:image];
    }
    
    return cell;
    
}

#pragma mark - AutoScrollViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item % self.imagesGroup.count;
    if (_delegate == nil) {
        NSLog(@"Important!! AutoScrollViewDelegate Not Set!");
        
    }
    if ([_delegate respondsToSelector:@selector(autoScrollView:didSelectItemAtIndex:)]) {
        [_delegate autoScrollView:self didSelectItemAtIndex:index];
    }
    
}



#pragma mark - 网络图片的相关操作

- (void)loadImageWithImageURLsGroup:(NSArray *)imageURLsGroup
{
    [imageURLsGroup enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        [self loadImageAtIndex:idx];
    }];
}

/**
 *  缓存图片
 *
 *  @param index url
 */
- (void)loadImageAtIndex:(NSInteger)index
{
    NSString *urlStr = self.urlImageGroup[index];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (image) {
        [self.imagesGroup setObject:image atIndexedSubscript:index];
    } else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image) {
                if (index < self.urlImageGroup.count && [self.urlImageGroup[index] isEqualToString:urlStr]) {
                    [self.imagesGroup replaceObjectAtIndex:index withObject:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainCollectionView reloadData];
                    });
                }
            }
        }];
    }
}

#pragma mark - 自动轮播

- (void)addTimer
{
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    timer = time;
    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)automaticScroll
{
    if (0 == totalItemsCount) return;
    int currentIndex = _mainCollectionView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == totalItemsCount) {
        if (self.isCycleRoll) {
            targetIndex = totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    int page = currentIndex%4;
    
    _pageControl.currentPage = page;
}


#pragma mark - UIScrollViewDelegate

//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}

//开始滑动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

//结束滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_isCycleRoll) {
        [self addTimer];
    }
    int itemIndex = (scrollView.contentOffset.x + self.mainCollectionView.bounds.size.width * 0.5) / self.mainCollectionView.bounds.size.width;
    if (!self.imagesGroup.count) return;
    int indexOnPageControl = itemIndex % self.imagesGroup.count;
    
    _pageControl.currentPage = indexOnPageControl;
    
    if ([self.delegate respondsToSelector:@selector(autoScrollView:didScrollIndex:)]) {
        [self.delegate autoScrollView:self didScrollIndex:indexOnPageControl];
    }
}



//释放
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dealloc
{
    _mainCollectionView.delegate = nil;
    _mainCollectionView.dataSource = nil;
    _delegate = nil;
    
}
@end
