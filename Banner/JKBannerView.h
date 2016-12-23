//
//  JKBannerView.h
//  Banner
//
//  Created by chaoyang805 on 2016/12/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKBannerView;

@protocol JKBannerViewDelegate <NSObject>

- (void)bannerView:(JKBannerView *)bannerView tappedAtIndex:(NSUInteger)index;

@end

@interface JKBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, readwrite, copy) NSArray<UIImage *> *images;
@property (nonatomic, readonly, assign) NSUInteger count;
@property (nonatomic, readonly, assign) NSUInteger currentPage;
@property (nonatomic, readwrite, assign) BOOL pageControlEnabled;
@property (nonatomic, readwrite, assign) BOOL autoScrollEnabled;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
@property (nonatomic, weak) id<JKBannerViewDelegate> delegate;

- (instancetype)initWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame;
- (instancetype)initWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame;

+ (instancetype)bannerWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame;
+ (instancetype)bannerWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame;

@end
