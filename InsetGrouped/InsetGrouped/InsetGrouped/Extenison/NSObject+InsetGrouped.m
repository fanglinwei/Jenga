//
//  NSObject+InsetGrouped.m
//  TableViewDemo
//
//  Created by Jarhom Chen on 2021/10/9.
//

#import "NSObject+InsetGrouped.h"

@implementation NSObject (InsetGrouped)

- (void)cc_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self cc_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)cc_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSAssert(methodSignature, @"NSObject (InsetGrouped)- [%@ cc_performSelector:@selector(%@)] 失败，方法不存在。", NSStringFromClass(self.class), NSStringFromSelector(selector));
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

@end
