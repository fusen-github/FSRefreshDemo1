//
//  FSRefreshFooter.m
//  SDRefreshView
//
//  Created by 四维图新 on 16/3/15.
//  Copyright (c) 2016年 GSD. All rights reserved.
//

#import "FSRefreshFooter.h"

@interface FSRefreshFooter ()

@property (nonatomic, assign) BOOL hasNavBar;

@property (nonatomic, assign) CGFloat scrollViewOriginContentHeight;

@end

@implementation FSRefreshFooter

- (instancetype)initWithScrollView:(UIScrollView *)scrollView navigationBarIsExist:(BOOL)isExist
{
    if (self = [super initWithScrollView:scrollView navigationBarIsExist:isExist])
    {
        self.hasNavBar = isExist;
        
        self.normalInfoText = @"上拉可以加载更多";
        
        self.willRefreshInfoText = @"松开立即加载";
        
        self.isRefreshingInfoText = @"正在加载...";
        
        self.arrowNormalRadian = M_PI;
        
        self.arrowWillRefreshRadian = 0;
        
        self.refreshViewType = FSRefreshViewTypeFooder;
        
        self.refreshState = FSRefreshStateNormal;
        
        self.scrollViewOriginContentHeight = scrollView.contentSize.height;
        
//        self.hidden = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.addContentInset = UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0);
}

- (void)beginRefreshWithTarget:(id)target refreshAction:(SEL)action
{
    [super beginRefreshWithTarget:target refreshAction:action];
}


- (void)endRefreshing
{
    [super endRefreshing];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:kObserveKey] || self.refreshState == FSRefreshStateIsRefreshing)
    {
        return;
    }
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    
    CGFloat criticalY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height + self.scrollView.contentInset.bottom;
    
    if (self.scrollView.contentSize.height != self.scrollViewOriginContentHeight)
    {
        [self layoutSubviews];
    }
    
    if (!self.hasNavBar)
    {
        if (y <= 0 || self.scrollView.bounds.size.height == 0)
        {
            return;
        }
    }
    else
    {
        if (y <= -64 || self.scrollView.bounds.size.height == 0) {
            return;
        }
    }
    
    
    if (y > criticalY && self.refreshState == FSRefreshStateNormal) // && !self.hidden
    {
        [self setRefreshState:FSRefreshStateWillRefresh];
        
//        NSLog(@"will");
        
        return;
    }
    
    // y <= criticalY &&
    if (self.refreshState == FSRefreshStateWillRefresh &&
        !self.scrollView.isDragging)
    {
//        NSLog(@"isRefreshing");
        
        [self setRefreshState:FSRefreshStateIsRefreshing];
        
        return;
    }
    
    
    // y <= criticalY &&
    if (!self.scrollView.isDragging &&
        self.refreshState != FSRefreshStateNormal)
    {
//        NSLog(@"normal");
        
        [self setRefreshState:FSRefreshStateNormal];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5 + self.scrollView.contentSize.height);
    
    if (self.hasNavBar)
    {
//        self.hidden = self.scrollView.bounds.size.height - 64 > self.frame.origin.y;
    }
    else
    {
//        self.hidden = self.scrollView.bounds.size.height > self.frame.origin.y;
    }
    
}


@end
