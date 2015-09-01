//
//  UIView+StackViewExtentions.h
//  StackView
//
//  Created by Matan Cohen on 9/1/15.
//  Copyright (c) 2015 Matan Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StackViewExtentions)
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) BOOL isSticky;
@property (nonatomic, weak) UITableViewCell *containerCell;
@property (nonatomic, assign) BOOL isDisplayOnCell;
@property (nonatomic, assign) BOOL didSet;
@end
 