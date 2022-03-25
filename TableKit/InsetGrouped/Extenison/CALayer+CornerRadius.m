//
//  UIView+CornerRadius.m
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/9.
//

#import "CALayer+CornerRadius.h"
#import "CCRuntime.h"

@implementation CALayer (CornerRadius)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 由于其他方法需要通过调用 CCUILayer_setCornerRadius: 来执行 swizzle 前的实现，所以这里暂时用 ExchangeImplementations
        ExchangeImplementations([CALayer class], @selector(setCornerRadius:), @selector(ccuilayer_setCornerRadius:));

        
    });
}


- (void)ccuilayer_setCornerRadius:(CGFloat)cornerRadius {
    BOOL cornerRadiusChanged = flat(self.cc_originCornerRadius) != flat(cornerRadius);// flat 处理，避免浮点精度问题
    self.cc_originCornerRadius = cornerRadius;
    if (@available(iOS 11, *)) {
        [self ccuilayer_setCornerRadius:cornerRadius];
    } else {
        if (self.cc_maskedCorners && ![self hasFourCornerRadius]) {
            [self ccuilayer_setCornerRadius:0];
        } else {
            [self ccuilayer_setCornerRadius:cornerRadius];
        }
        if (cornerRadiusChanged) {
            // 需要刷新mask
            if ([NSThread isMainThread]) {
                [self setNeedsLayout];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsLayout];
                });
            }
        }
    }
 
}



- (BOOL)hasFourCornerRadius {
    return (self.cc_maskedCorners & CCUILayerMinXMinYCorner) == CCUILayerMinXMinYCorner &&
           (self.cc_maskedCorners & CCUILayerMaxXMinYCorner) == CCUILayerMaxXMinYCorner &&
           (self.cc_maskedCorners & CCUILayerMinXMaxYCorner) == CCUILayerMinXMaxYCorner &&
           (self.cc_maskedCorners & CCUILayerMaxXMaxYCorner) == CCUILayerMaxXMaxYCorner;
}

static char kAssociatedObjectKey_cc_originCornerRadius;
- (void)setCc_originCornerRadius:(CGFloat)cc_originCornerRadius {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_originCornerRadius, @(cc_originCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)cc_originCornerRadius {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_originCornerRadius);
    if (!associatedValue) {
        return 0.0;
    }
    
    return [associatedValue floatValue];
}


static char kAssociatedObjectKey_cc_maskedCorners;
- (void)setCc_maskedCorners:(CCUICornerMask)cc_maskedCorners {
    
    BOOL maskedCornersChanged = cc_maskedCorners != self.cc_maskedCorners;

    objc_setAssociatedObject(self, &kAssociatedObjectKey_cc_maskedCorners, @(cc_maskedCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (@available(iOS 11, *)) {
        self.maskedCorners = (CACornerMask)cc_maskedCorners;
    } else {
        if (cc_maskedCorners && ![self hasFourCornerRadius]) {
            [self ccuilayer_setCornerRadius:0];
        }
        if (maskedCornersChanged) {
            // 需要刷新mask
            if ([NSThread isMainThread]) {
                [self setNeedsLayout];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsLayout];
                });
            }
        }
    }
   
}

- (CCUICornerMask)cc_maskedCorners {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cc_maskedCorners);
    if (!associatedValue) {
        return 0;
    }
    
    return [associatedValue integerValue];
}

@end



@implementation UIView (CornerRadius)

static NSString *kMaskName = @"CC_CornerRadius_Mask";

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments([CALayer class], @selector(layoutSublayers), ^(CALayer *selfObject) {
            if (@available(iOS 11, *)) {
            } else {
                if (selfObject.mask && ![selfObject.mask.name isEqualToString:kMaskName]) {
                    return;
                }
                if (selfObject.cc_maskedCorners) {
                    if (selfObject.cc_originCornerRadius <= 0 || [selfObject hasFourCornerRadius]) {

                        if (selfObject.mask) {
                            selfObject.mask = nil;
                        }
                    } else {
                        CAShapeLayer *cornerMaskLayer = [CAShapeLayer layer];
                        cornerMaskLayer.name = kMaskName;
                        UIRectCorner rectCorner = 0;
                        if ((selfObject.cc_maskedCorners & CCUILayerMinXMinYCorner) == CCUILayerMinXMinYCorner) {
                            rectCorner |= UIRectCornerTopLeft;
                        }
                        if ((selfObject.cc_maskedCorners & CCUILayerMaxXMinYCorner) == CCUILayerMaxXMinYCorner) {
                            rectCorner |= UIRectCornerTopRight;
                        }
                        if ((selfObject.cc_maskedCorners & CCUILayerMinXMaxYCorner) == CCUILayerMinXMaxYCorner) {
                            rectCorner |= UIRectCornerBottomLeft;
                        }
                        if ((selfObject.cc_maskedCorners & CCUILayerMaxXMaxYCorner) == CCUILayerMaxXMaxYCorner) {
                            rectCorner |= UIRectCornerBottomRight;
                        }
                        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:selfObject.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(selfObject.cc_originCornerRadius, selfObject.cc_originCornerRadius)];
                        cornerMaskLayer.frame = CGRectMake(0, 0, selfObject.bounds.size.width, selfObject.bounds.size.height);
                        cornerMaskLayer.path = path.CGPath;
                        selfObject.mask = cornerMaskLayer;
                    }
                }
            }
        });
    });
}
                

//- (void)setCc_cornerRadius:(CGFloat)cc_cornerRadius {
//    self.layer.cc_cornerRadius = cc_cornerRadius;
//}
//- (CGFloat)cc_cornerRadius {
//    return self.layer.cc_cornerRadius;
//}
//
//- (void)setCc_maskedCorners:(CCUICornerMask)cc_maskedCorners {
//    self.layer.cc_maskedCorners = cc_maskedCorners;
//}
//- (CCUICornerMask)cc_maskedCorners {
//    return self.layer.cc_maskedCorners;
//}



@end
