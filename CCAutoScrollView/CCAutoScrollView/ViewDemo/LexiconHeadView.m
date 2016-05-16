//
//  LexiconHeadView.m
//  ReciteWordsIOS
//
//  Created by 蔡康武 on 16/3/29.
//  Copyright © 2016年 广州市好酷计算机科技有限公司. All rights reserved.
//

#import "LexiconHeadView.h"

@implementation LexiconHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    self = [[[NSBundle mainBundle] loadNibNamed:@"LexiconHeadView" owner:self options:nil] lastObject];
    if (self) {

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"LexiconHeadView" owner:self options:nil] lastObject];
    if (self){
        [self setFrame:frame];
       
    }
    return self;
}


@end
