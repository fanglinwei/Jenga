//
//  UITableView+InsetGrouped.m
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/8.
//

#import "UITableView+InsetGrouped.h"
#import "CCRuntime.h"
#import "NSObject+InsetGrouped.h"
#import "CALayer+CornerRadius.h"

@implementation UITableView (InsetGrouped)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        

        OverrideImplementation([UITableView class], NSSelectorFromString(@"_configureCellForDisplay:forIndexPath:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableView *selfObject, UITableViewCell *cell, NSIndexPath *indexPath) {
                
                // call super，-[UITableViewDelegate tableView:willDisplayCell:forRowAtIndexPath:] 比这个还晚，所以不用担心触发 delegate
                void (*originSelectorIMP)(id, SEL, UITableViewCell *, NSIndexPath *);
                originSelectorIMP = (void (*)(id, SEL, UITableViewCell *, NSIndexPath *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, cell, indexPath);
                
                cell.cc_tableView = selfObject;
                
                // UITableViewCell(QMUI) 内会根据 cellPosition 调整 separator 的布局，所以先在这里赋值以供那边使用
                if (@available(iOS 13.0, *)) return;

                if (selfObject.cc_isInsetGrouped) {
                    CCTableViewCellPosition position = [selfObject cc_positionForRowAtIndexPath:indexPath];
                    
                    if (cell.cc_cellPosition != position) {
                        cell.cc_cellPosition = position;

                        CGFloat cornerRadius = selfObject.cc_cornerRadius;
                        
                        CCUICornerMask mask = CCUILayerAllCorner;
                        switch (position) {
                            case CCTableViewCellPosition_Top:
                                mask = CCUILayerMinXMinYCorner|CCUILayerMaxXMinYCorner;
                                break;
                            case CCTableViewCellPosition_Tail:
                                mask = CCUILayerMinXMaxYCorner|CCUILayerMaxXMaxYCorner;
                                break;
                            case CCTableViewCellPosition_Middle:
                            case CCTableViewCellPosition_unknown:
                                cornerRadius = 0;
                                break;
                            default:
                                break;
                        }
                
                        cell.layer.cc_maskedCorners = mask;
                        cell.layer.masksToBounds = YES;
                        
                        cell.layer.cornerRadius = cornerRadius;

                    }

                }
            };
        });
        
        
        if (@available(iOS 13.0, *)) {
            OverrideImplementation([UITableView class], @selector(layoutMargins), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UIEdgeInsets(UITableView *selfObject) {
                    // call super
                    UIEdgeInsets (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (UIEdgeInsets (*)(id, SEL))originalIMPProvider();
                    UIEdgeInsets result = originSelectorIMP(selfObject, originCMD);
                    
                    if (selfObject.cc_isInsetGrouped) {
                        result.left = selfObject.cc_safeAreaInsets.left + selfObject.cc_insetGroupedHorizontalInset;
                        result.right = selfObject.cc_safeAreaInsets.right + selfObject.cc_insetGroupedHorizontalInset;
                    }
                    
                    return result;
                };
            });
        }
       
    });
}

- (CCTableViewCellPosition)cc_positionForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger num = [self numberOfRowsInSection:indexPath.section];
    if (num == 1) {
        return CCTableViewCellPosition_Single;
    }
    
    if (indexPath.row == 0) {
        return CCTableViewCellPosition_Top;
    } else if (indexPath.row == num-1) {
        return CCTableViewCellPosition_Tail;
    }
    
    return CCTableViewCellPosition_Middle;
    
}

- (CGFloat)cc_validContentWidth {
    CGRect indexFrame = self.cc_indexFrame;
    CGFloat rightInset = MAX(self.cc_safeAreaInsets.right + (self.cc_isInsetGrouped? self.cc_insetGroupedHorizontalInset : 0), CGRectGetWidth(indexFrame));
    CGFloat leftInset = self.cc_safeAreaInsets.left + (self.cc_isInsetGrouped? self.cc_insetGroupedHorizontalInset : 0);
    CGFloat width = CGRectGetWidth(self.bounds) - leftInset - rightInset;
    return width;
}

- (UIEdgeInsets)cc_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (CGRect)cc_indexFrame {
    CGRect indexFrame = CGRectZero;
    [self cc_performSelector:NSSelectorFromString(@"indexFrame") withPrimitiveReturnValue:&indexFrame];
    return indexFrame;
}


#pragma mark - set&get
static char kAssociatedObjectKey_cc_isInsetGrouped;
- (void)setCc_isInsetGrouped:(BOOL)cc_isInsetGrouped {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_isInsetGrouped, @(cc_isInsetGrouped), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.cc_isInsetGrouped && self.indexPathsForVisibleRows.count) {
        [self reloadData];
    }
}

- (BOOL)cc_isInsetGrouped {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_isInsetGrouped);
    if (!associatedValue) {
        return false;
    }
    
    return [associatedValue boolValue];
}


static char kAssociatedObjectKey_cc_cornerRadius;
- (void)setCc_cornerRadius:(CGFloat)cc_cornerRadius {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_cornerRadius, @(cc_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.cc_isInsetGrouped && self.indexPathsForVisibleRows.count) {
        [self reloadData];
    }
}

- (CGFloat)cc_cornerRadius {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_cornerRadius);
    if (!associatedValue) {
        return 8.0;
    }
    
    return [associatedValue floatValue];
}

static char kAssociatedObjectKey_cc_insetGroupedHorizontalInset;
- (void)setCc_insetGroupedHorizontalInset:(CGFloat)cc_insetGroupedHorizontalInset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_insetGroupedHorizontalInset, @(cc_insetGroupedHorizontalInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.cc_isInsetGrouped && self.indexPathsForVisibleRows.count) {
        [self reloadData];
    }
}

- (CGFloat)cc_insetGroupedHorizontalInset {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_insetGroupedHorizontalInset);
    if (!associatedValue) {
        return 8.0;
    }
    
    return [associatedValue floatValue];
}





@end
