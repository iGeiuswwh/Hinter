//
//  StoryButton.m
//  Hinter
//
//  Created by igenius on 2016/11/17.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "StoryButton.h"

@implementation StoryButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//使用storyboard或者xib创建按钮的时候会调用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupProperties];
        
    }
    return self;
}


- (void)setupProperties{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
}


- (void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end



