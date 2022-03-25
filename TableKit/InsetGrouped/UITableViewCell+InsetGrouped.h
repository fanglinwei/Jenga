//
//  UITableViewCell+InsetGrouped.h
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/9.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCTableViewCellPosition) {
    CCTableViewCellPosition_unknown = 0,
    CCTableViewCellPosition_Single = 1,
    CCTableViewCellPosition_Top,
    CCTableViewCellPosition_Middle,
    CCTableViewCellPosition_Tail
};

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (InsetGrouped)

@property (nonatomic, weak) UITableView *cc_tableView;

//是否insetGrouped类型
@property (nonatomic, assign) BOOL cc_isInsetGrouped;
//cell再section中的位置
@property (nonatomic, assign) CCTableViewCellPosition cc_cellPosition;

@end

NS_ASSUME_NONNULL_END
