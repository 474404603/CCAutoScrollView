//
//  CCAutoScrollView.h
//  CCAutoScrollView
//
//  Created by Mr Cai on 15/11/9.
//  Copyright © 2015年 Mr Cai. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 风格 */
typedef enum : NSInteger {
    
    ViewSylteType,   //一个view的类型
    
    ImageSylteType     //图片类型
    
} CellSylteType;

/** PageControl的位置 */
typedef enum : NSInteger {
    LeftPageControl,
    RightPageControl,
    CenterPageControl
    
} PageControlPosition;


@class CCAutoScrollView;
@protocol AutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(CCAutoScrollView *)collectionView didSelectItemAtIndex:(NSInteger)index;

//滑动到那个下标
- (void)autoScrollView:(CCAutoScrollView *)collectionView didScrollIndex:(NSInteger)index;

@end


@interface CCAutoScrollView : UIView

@property (nonatomic,assign) CellSylteType cellSylteType;
@property (nonatomic,assign) PageControlPosition pageControlPosition;

/**
 *  滚动的UICollectionView
 */
@property(nonatomic,strong) UICollectionView *mainCollectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,strong) UIPageControl *pageControl;


/**
 *  存放图片数组
 */
@property(nonatomic,strong) NSMutableArray *imagesGroup;

/**
 *  网络图片url数组
 */
@property(nonatomic,strong) NSMutableArray *urlImageGroup;


/**
 *  是否要循环滚动
 */
@property(nonatomic,assign) BOOL isCycleRoll;


@property(nonatomic,assign) id <AutoScrollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withSylteType:(CellSylteType)type;


@end
