//
//  UIView+CornerRadius.h
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/9.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger, CCUICornerMask) {
    CCUILayerMinXMinYCorner = 1U << 0,
    CCUILayerMaxXMinYCorner = 1U << 1,
    CCUILayerMinXMaxYCorner = 1U << 2,
    CCUILayerMaxXMaxYCorner = 1U << 3,
    CCUILayerAllCorner = CCUILayerMinXMinYCorner|CCUILayerMaxXMinYCorner|CCUILayerMinXMaxYCorner|CCUILayerMaxXMaxYCorner,
};

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (CornerRadius)

//圆角大小 默认10
@property (nonatomic, assign) CGFloat cc_originCornerRadius;

@property (nonatomic, assign) CCUICornerMask cc_maskedCorners;

@end





NS_ASSUME_NONNULL_END
