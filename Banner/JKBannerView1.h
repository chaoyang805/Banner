//
//  JKBannerView1.h
//  Banner
//
//  Created by chaoyang805 on 2016/12/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKBannerView1;

@protocol JKBannerView1Delegate <NSObject>
- (void)bannerView:(JKBannerView1 *)bannerView tappedAtIndex:(NSUInteger)index;
@end

@interface JKBannerView1 : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<JKBannerView1Delegate> delegate;

// 只读
@property (nonatomic, readonly, assign) NSUInteger pageCount;
@property (nonatomic, readonly, assign) NSUInteger currentPage;
// 读写
@property (nonatomic, readwrite, copy) NSArray *images;
@property (nonatomic, readwrite, assign) BOOL pageControlEnabled;
@property (nonatomic, readwrite, assign) NSTimeInterval autoScrollTimeInterval;
@property (nonatomic, readwrite, assign) BOOL autoScrollEnabled;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images frame:(CGRect)frame;
- (instancetype)initWithImagesNamed:(NSArray<NSString *> *)names frame:(CGRect)frame;
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)urls frame:(CGRect)frame;

@end
