//
//  CCCollectionCell.m
//  CCAutoScrollView
//
//  Created by Mr Cai on 15/11/9.
//  Copyright © 2015年 Mr Cai. All rights reserved.
//

#import "CCImageCollectionCell.h"

@implementation CCImageCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {        
        
        UIImageView *image = [[UIImageView alloc] init];
        [self addSubview:image];
        _cellImageView = image;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _cellImageView.frame = self.bounds;
}

@end
