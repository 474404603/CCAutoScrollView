//
//  CCViewCollectionCell.m
//  CCAutoScrollView
//
//  Created by Mr Cai on 16/3/29.
//  Copyright © 2016年 Mr Cai. All rights reserved.
//

#import "CCViewCollectionCell.h"

@implementation CCViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *view = [[UIView alloc] initWithFrame:frame];
    
        [self addSubview:view];
        _cellView = view;

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _cellView.frame = self.bounds;
}

@end
