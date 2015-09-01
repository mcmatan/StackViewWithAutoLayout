//
//  ResizingScrollView.m
//  Stox
//
//  Created by Matan Cohen on 9/7/14.

//

#import "ResizingScrollView.h"

@implementation ResizingScrollView

-(void) addSubview:(UIView *)view {
    
    CGSize sizeSelf = self.contentSize;
    sizeSelf.height += view.frame.size.height;
    self.contentSize = sizeSelf;
    
    
    float hightTotalViews = 0.0;
    for (UIView *views in self.subviews) {
        hightTotalViews += views.frame.size.height;
    }
    
    [super addSubview:view];
    
    [view setCenter:CGPointMake(320/2, hightTotalViews + view.frame.size.height / 2)];
    
}


@end
