//
//  JKBannerView.m
//  Banner
//
//  Created by chaoyang805 on 2016/12/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

#import "JKBannerView.h"

static const NSTimeInterval kDefaultTimeInterval = 2;
static const CGFloat kDefaultPageControlHeight = 50;
static const NSTimeInterval kMinimumTimeInterval = 1;
@interface JKBannerView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, readwrite, assign) NSUInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation JKBannerView

- (instancetype)initWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame {
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (NSString *imageName in names) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [images addObject:image];
        }
    }
    return [[JKBannerView alloc] initWithImages:images frame:frame];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame {
    self = [super init];
    if (self) {
        _autoScrollTimeInterval = kDefaultTimeInterval;
        _autoScrollEnabled = YES;
        _pageControlEnabled = YES;
        _currentPage = 0;
        self.frame = frame;
        
        NSMutableArray<UIImage *> *cycleImages = [images mutableCopy];
        [cycleImages insertObject:images[images.count - 1] atIndex:0];
        [cycleImages addObject:images[0]];
        _images = [cycleImages copy];
    }
    return self;
}


+ (instancetype)bannerWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame {
    return [[JKBannerView alloc] initWithImagesNamed:names frame:frame];
}

+ (instancetype)bannerWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame {
    return [[JKBannerView alloc] initWithImages:images frame:frame];
}

#pragma mark setter getter

- (void)setImages:(NSArray<UIImage *> *)images {
    NSMutableArray<UIImage *> *cycleImages = [images mutableCopy];
    [cycleImages insertObject:images[images.count - 1] atIndex:0];
    [cycleImages addObject:images[0]];
    _images = [cycleImages copy];
    [self setup];
}

- (NSUInteger)count {
    return self.images.count;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self setup];
}

- (void)setup {
    
    [self addGestureRecognizer:self.gestureRecognizer];
    
    [self loadScrollView];
    // pageControl
    [self loadPageControl];
    // timer
    if (self.autoScrollEnabled) {
        [self startTimer];
    }
}

#pragma mark TapGestureRecognizer

- (UITapGestureRecognizer *)gestureRecognizer {
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return _gestureRecognizer;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:tappedAtIndex:)]) {
        [self.delegate bannerView:self tappedAtIndex:self.currentPage];
    }
}

#pragma mark UIScrollView

- (void)loadScrollView {
    if (self.scrollView.superview) {
        [self.scrollView removeFromSuperview];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    CGFloat contentWidth = self.count * self.bounds.size.width;
    self.scrollView.contentSize = CGSizeMake(contentWidth ,self.bounds.size.height);
    
    for (NSUInteger i = 0; i < self.count; i++) {
        UIImage *image = self.images[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat x = i * width;
        CGFloat y = 0;
        imageView.frame = CGRectMake(x, y, width, height);
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self addSubview:self.scrollView];
}


#pragma mark pageControl

- (void)loadPageControl {
    
    if (self.pageControl && self.pageControl.superview) {
        [self.pageControl removeFromSuperview];
    }
    
    if (!self.pageControlEnabled) {
        return;
    }
    
    CGFloat pageControlHeight = kDefaultPageControlHeight;
    self.pageControl = [[UIPageControl alloc] initWithFrame:
                        CGRectMake(
                                   0,
                                   self.bounds.size.height - pageControlHeight,
                                   self.bounds.size.width,
                                   pageControlHeight
                                   )];
    self.pageControl.numberOfPages = self.count - 2;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:self.pageControl];
}

#pragma mark Timer

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    if (autoScrollTimeInterval < kMinimumTimeInterval) {
        _autoScrollTimeInterval = kMinimumTimeInterval;
    } else {
        _autoScrollTimeInterval = autoScrollTimeInterval;
    }
    [self resetTimer];
}

- (void)resetTimer {
    [self stopTimer];
    [self startTimer];
}

- (void)startTimer {
    if (!self.autoScrollEnabled) {
        return;
    }
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    }
    
}

- (void)stopTimer {
    if (!self.autoScrollEnabled) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollToNextPage {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    CGPoint nextOffset = CGPointMake(currentOffsetX + self.bounds.size.width, 0);
    [self.scrollView setContentOffset:nextOffset animated:YES];

    CGFloat currentPage = (self.currentPage + 1) % (self.count - 2);
    self.currentPage = (NSUInteger)currentPage;
    
    if (self.pageControlEnabled) {
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        [scrollView setContentOffset:CGPointMake((self.count - 2) * self.bounds.size.width, 0)];
    } else if (offsetX == (self.count - 1) * self.bounds.size.width) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentPage = scrollView.contentOffset.x / self.bounds.size.width - 1;
    
    self.currentPage = currentPage;
    if (self.pageControlEnabled) {
        self.pageControl.currentPage = (NSUInteger)currentPage;
    }
}


@end
