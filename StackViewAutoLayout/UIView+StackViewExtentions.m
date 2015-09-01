//
//  UIView+StackViewExtentions.m
//  StackView
//
//  Created by Matan Cohen on 9/1/15.
//  Copyright (c) 2015 Matan Cohen. All rights reserved.
//

#import "UIView+StackViewExtentions.h"
#import <objc/runtime.h>
@import Foundation;
@implementation UIView (StackViewExtentions)

-(void) setRow:(NSUInteger)row {
    NSNumber *num = @(row);
    objc_setAssociatedObject(self, (__bridge const void*)(@"row"), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSUInteger) row {
    NSNumber *val = objc_getAssociatedObject(self, (__bridge const void*)@"row");
    return val.integerValue;
}

-(void) setIsSticky:(BOOL)isSticky {
    NSNumber *num = @(isSticky);
    objc_setAssociatedObject(self, (__bridge const void*)(@"isSticky"), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) isSticky {
    NSNumber *val = objc_getAssociatedObject(self, (__bridge const void*)@"isSticky");
    return val.boolValue;
}

-(void) setContainerCell:(UITableViewCell *)containerCell {
    objc_setAssociatedObject(self, (__bridge const void*)(@"containerCell"), containerCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITableViewCell*) containerCell {
   return (UITableViewCell *)objc_getAssociatedObject(self, (__bridge const void*)@"containerCell");
}

-(void) setIsDisplayOnCell:(BOOL)isDisplayOnCell {
    NSNumber *num = @(isDisplayOnCell);
    objc_setAssociatedObject(self, (__bridge const void*)(@"isDisplayOnCell"), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) isDisplayOnCell {
    NSNumber *val = objc_getAssociatedObject(self, (__bridge const void*)@"isDisplayOnCell");
    return val.boolValue;
}


-(void) setDidSet:(BOOL)didSet {
    NSNumber *num = @(didSet);
    objc_setAssociatedObject(self, (__bridge const void*)(@"didSet"), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) didSet {
    NSNumber *val = objc_getAssociatedObject(self, (__bridge const void*)@"didSet");
    return val.boolValue;
}
@end
