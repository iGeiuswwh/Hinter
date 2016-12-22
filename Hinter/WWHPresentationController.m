//
//  WWHPresentationController.m
//  Hinter
//
//  Created by igenius on 2016/11/17.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "WWHPresentationController.h"

@interface WWHPresentationController ()
@property (nonatomic ,strong) UIView *coverView;
@end


@implementation WWHPresentationController

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
    }
    return _coverView;
}


- (void)containerViewWillLayoutSubviews{
    [super containerViewWillLayoutSubviews];
    CGRect tempFrame = self.presentedView.frame;
    tempFrame = CGRectMake(46, 50, self.containerView.frame.size.width - 92, self.containerView.frame.size.height -180);
    self.presentedView.frame = tempFrame;
        
    [self loadCoverView];
}

- (void)loadCoverView{
    [self.containerView insertSubview:self.coverView atIndex:0];
    self.coverView.frame = self.containerView.bounds;
    self.coverView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    
    UITapGestureRecognizer *coverViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapped)];
    [self.coverView addGestureRecognizer:coverViewTap];
}

- (void)coverViewTapped{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
