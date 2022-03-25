//
//  UITableViewCell+InsetGrouped.m
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/9.
//

#import "UITableViewCell+InsetGrouped.h"
#import "UITableView+InsetGrouped.h"
#import "CCRuntime.h"


@implementation UITableViewCell (InsetGrouped)

+ (void)load {
    // 下方的功能，iOS 13 都交给系统的 InsetGrouped 处理
    if (@available(iOS 13.0, *)) return;
    
    OverrideImplementation([UITableViewCell class], @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^(UITableViewCell *selfObject, CGRect firstArgv) {
            
            UITableView *tableView = selfObject.cc_tableView;
            if (tableView && tableView.cc_isInsetGrouped ) {
                // 以下的宽度不基于 firstArgv 来改，而是直接获取 tableView 的内容宽度，是因为 iOS 12 及以下的系统，在 cell 拖拽排序时，frame 会基于上一个 frame 计算，导致宽度不断减小，所以这里每次都用 tableView 的内容宽度来算
                // https://github.com/Tencent/QMUI_iOS/issues/1216
                firstArgv = CGRectMake(tableView.cc_safeAreaInsets.left + tableView.cc_insetGroupedHorizontalInset, CGRectGetMinY(firstArgv), tableView.cc_validContentWidth, CGRectGetHeight(firstArgv));
            }
            
            // call super
            void (*originSelectorIMP)(id, SEL, CGRect);
            originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD, firstArgv);
        };
    });
}



#pragma mark - set&get
static char kAssociatedObjectKey_cc_tableView;
- (void)setCc_tableView:(UITableView *)cc_tableView {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_tableView, cc_tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)cc_tableView {
    UITableView *associatedValue = (UITableView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_tableView);
    if (!associatedValue) {
        return nil;
    }
    
    return associatedValue;
}


static char kAssociatedObjectKey_cc_isInsetGrouped;
- (void)setCc_isInsetGrouped:(BOOL)cc_isInsetGrouped {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_isInsetGrouped, @(cc_isInsetGrouped), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cc_isInsetGrouped {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_isInsetGrouped);
    if (!associatedValue) {
        return false;
    }
    
    return [associatedValue boolValue];
}

static char kAssociatedObjectKey_cc_cellPosition;
- (void)setCc_cellPosition:(CCTableViewCellPosition)cc_cellPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_cellPosition, @(cc_cellPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CCTableViewCellPosition)cc_cellPosition {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_cellPosition);
    if (!associatedValue) {
        return 0;
    }
    
    return [associatedValue integerValue];
}


- (UIRectCorner)cc_maskedCorners {
    if (self.cc_isInsetGrouped) {
        return 0;
    }
    UIRectCorner corners = UIRectCornerAllCorners;
    switch (self.cc_cellPosition) {
        case CCTableViewCellPosition_Single:
            corners = UIRectCornerAllCorners;
            break;
        case CCTableViewCellPosition_Top:
            corners = UIRectCornerTopLeft|UIRectCornerTopRight;
            break;
        case CCTableViewCellPosition_Tail:
            corners = UIRectCornerBottomLeft|UIRectCornerBottomRight;
            break;
        case CCTableViewCellPosition_Middle:
        case CCTableViewCellPosition_unknown:
            corners = 0;
            break;
        default:
            break;
    }
    return corners;
}



@end
