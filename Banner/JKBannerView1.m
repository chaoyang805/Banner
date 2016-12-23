//
//  JKBannerView1.m
//  Banner
//
//  Created by chaoyang805 on 2016/12/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

#import "JKBannerView1.h"

static const NSTimeInterval kDefaultTimeInterval = 2;
static const NSTimeInterval kMinimumScrollTimeInterval = 1;
static const CGFloat kDefaultPageControlHeight = 50;
@interface JKBannerView1 ()

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, readonly, assign) CGFloat bannerWidth;
@property (nonatomic, readwrite, assign) NSUInteger currentPage;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer *recognizer;

@end

@implementation JKBannerView1

- (instancetype)initWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _autoScrollEnabled = YES;
        _autoScrollTimeInterval = kDefaultTimeInterval;
        _currentPage = 0;
        _pageControlEnabled = YES;
        
        NSMutableArray<UIImage *> *cycleImage = [images mutableCopy];
        [cycleImage insertObject:images[images.count - 1] atIndex:0];
        [cycleImage addObject:images[0]];
        
        _images = [cycleImage copy];
    }
    
    return self;
}

- (instancetype)initWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame {
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (NSString *imageName in names) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [images addObject:image];
        }
    }
    return [[JKBannerView1 alloc] initWithImages:images frame:frame];
}

//- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)urls frame:(CGRect)frame {
//    
//}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self setupViews];
}

- (void)setupViews {
    
    [self addGestureRecognizer:self.recognizer];
    // 1. loadScrollView
    [self loadScrollView];
    // 2. PageControl
    [self loadPageControl];
    // 3. Timer
    if (self.autoScrollEnabled) {
        [self startTimer];
    }
    
}

#pragma mark getter setter 

- (NSUInteger)pageCount {
    return self.images.count;
}

- (CGFloat)bannerWidth {
    return self.bounds.size.width;
}

- (void)setImages:(NSArray *)images {
    NSMutableArray<UIImage *> *cycleImage = [images mutableCopy];
    [cycleImage insertObject:images[images.count - 1] atIndex:0];
    [cycleImage addObject:images[0]];
    
    _images = [cycleImage copy];

    [self setupViews];
}

#pragma mark UITapRecognizer

- (UITapGestureRecognizer *)recognizer {
    if (!_recognizer) {
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    }
    return _recognizer;
}

- (void)handleGesture:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:tappedAtIndex:)]) {
        [self.delegate bannerView:self tappedAtIndex:self.currentPage];
    }
}

#pragma mark ScrollView

- (void)loadScrollView {
    if (self.scrollView.superview) {
        [self.scrollView removeFromSuperview];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    CGFloat contentWidth = self.pageCount * self.bannerWidth;
    self.scrollView.contentSize = CGSizeMake(contentWidth ,self.bounds.size.height);
    
    for (NSUInteger i = 0; i < self.pageCount; i++) {
        UIImage *image = self.images[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat width = self.bannerWidth;
        CGFloat height = self.bounds.size.height;
        CGFloat x = i * width;
        CGFloat y = 0;
        imageView.frame = CGRectMake(x, y, width, height);
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(self.bannerWidth, 0);
    [self addSubview:self.scrollView];
}

#pragma mark PageControl

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
                                   self.bannerWidth,
                                   pageControlHeight)
                        ];
    self.pageControl.numberOfPages = self.pageCount - 2;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:self.pageControl];
}

#pragma mark Timer

- (void)startTimer {
    if (!self.autoScrollEnabled) {
        return;
    }
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)resetTimer {
    [self stopTimer];
    [self startTimer];
}

- (void)scrollToNextPage {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    CGPoint nextOffset = CGPointMake(self.bannerWidth + currentOffsetX, 0);
    [self.scrollView setContentOffset:nextOffset animated:YES];
    NSUInteger currentPage = (self.currentPage + 1) % (self.pageCount - 2);
    self.currentPage = currentPage;
    if (self.pageControlEnabled) {
        self.pageControl.currentPage = currentPage;
    }
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    if (autoScrollTimeInterval < kMinimumScrollTimeInterval) {
        _autoScrollTimeInterval = kMinimumScrollTimeInterval;
    } else {
        _autoScrollTimeInterval = autoScrollTimeInterval;
    }
    
    [self resetTimer];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        CGPoint offset = CGPointMake(self.bannerWidth * (self.pageCount - 2), 0);
        [scrollView setContentOffset:offset];
    } else if (offsetX == (self.pageCount - 1) * self.bannerWidth) {
        CGPoint offset = CGPointMake(self.bannerWidth, 0);
        [scrollView setContentOffset:offset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger currentPage = (NSUInteger)(offsetX / self.bounds.size.width - 1);
    if (self.pageControlEnabled) {
        self.pageControl.currentPage = currentPage;
    }
    self.currentPage = currentPage;
}

@end
