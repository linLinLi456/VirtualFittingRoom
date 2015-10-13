//
//  WWScrollView.m
//  5_
//
//  Created by qianfeng007 on 15-9-6.
//  Copyright (c) 2015年 王威. All rights reserved.
//

#import "WWScrollView.h"
#import "DetailViewController.h"

@interface WWScrollView() <UIScrollViewDelegate>

@property (nonatomic) UIImageView *leftImageView;
@property (nonatomic) UIImageView *centerImageView;
@property (nonatomic) UIImageView *rightImageView;
@property (nonatomic) NSInteger centerPage;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIPageControl *pageControl;

//点击事件
@end

@implementation WWScrollView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.userInteractionEnabled = YES;
    [self setUp];
    [self startTimer];
}

//自动滑动
- (void)startTimer {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerAction:(NSTimer *)timer {
    // 代码让scrollView滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
    // 这个方法会触发代理方法：- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
}

- (void)setUp {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;//
    _scrollView.pagingEnabled = 1;
    [self.scrollView setContentSize:CGSizeMake(3*self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.scrollView];
    
    CGRect frame = self.bounds;
    self.leftImageView = [[UIImageView alloc] initWithFrame:frame];
    
    frame.origin.x += self.frame.size.width;
    self.centerImageView = [[UIImageView alloc] initWithFrame:frame];
    
    frame.origin.x  += self.frame.size.width;
    self.rightImageView = [[UIImageView alloc] initWithFrame:frame];
    
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_centerImageView];
    [_scrollView addSubview:_rightImageView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    self.pageControl.numberOfPages = self.imageArray.count;
    [self addSubview:_pageControl];
    
    self.centerPage = 0;
    
}

- (void)setCenterPage:(NSInteger)centerPage {
    _centerPage = centerPage;
    if (_centerPage < 0) {
        _centerPage = self.imageArray.count - 1;
    }
    if (_centerPage >self.imageArray.count - 1) {
        _centerPage = 0;
    }
    NSInteger leftPage = _centerPage - 1 < 0 ? self.imageArray.count-1 : _centerPage - 1;
    NSInteger rightPage = _centerPage + 1 > self.imageArray.count - 1 ? 0 : _centerPage + 1 ;
    self.leftImageView.image = self.imageArray[leftPage];
    self.centerImageView.image = self.imageArray[_centerPage];
    self.rightImageView.image = self.imageArray[rightPage];
    
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    
    // 设置pageControl的页码
    self.pageControl.currentPage = _centerPage;
    
}
#pragma make - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > scrollView.frame.size.width) {
        self.centerPage++;
    } else if (scrollView.contentOffset.x < scrollView.frame.size.width){
        self.centerPage--;
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.centerPage++;
}

@end
