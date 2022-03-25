//
//  UITableView+InsetGrouped.h
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/8.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+InsetGrouped.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (InsetGrouped)

//是否insetGrouped类型
@property (nonatomic, assign) BOOL cc_isInsetGrouped;
//圆角大小 默认10
@property (nonatomic, assign) CGFloat cc_cornerRadius;
//margin 默认10
@property (nonatomic, assign) CGFloat cc_insetGroupedHorizontalInset;

@property (nonatomic, assign, readonly) UIEdgeInsets cc_safeAreaInsets;

@property (nonatomic, assign, readonly) CGFloat cc_validContentWidth;


@end

NS_ASSUME_NONNULL_END
