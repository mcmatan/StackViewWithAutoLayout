//
//  ViewController.m
//  StackViewAutoLayout
//
//  Created by Matan Cohen on 9/2/15.
//  Copyright (c) 2015 Matan Cohen. All rights reserved.
//

#import "ViewController.h"
#import "StackViewAutoLayout.h"
#import <Masonry/Masonry.h>
@interface ViewController ()

@property StackViewAutoLayout *stackView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@property (nonatomic, strong) UIView *view5;
@property (nonatomic, strong) UIView *view6;
@property (nonatomic, strong) UIView *view7;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupStackViewWithStickyHeader];
//    [self setupBasicStackView];
    [self removeAndInsertViews];
}

-(void) setupStackViewWithStickyHeader {
    self.stackView = [[StackViewAutoLayout alloc] init];
    [self.stackView addSubviewWithLayout:self.view1];
    [self.stackView addStickySubviewWithLayout:self.view2];
    [self.stackView addSubviewWithLayout:self.view3];
    [self.stackView addSubviewWithLayout:self.view4];
    [self.stackView addSubviewWithLayout:self.view5];
    [self.stackView addSubviewWithLayout:self.view6];
    [self.stackView addSubviewWithLayout:self.view7];
    [self.view addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void) setupBasicStackView {
    self.stackView = [[StackViewAutoLayout alloc] initWithLayoutSubviews:
                      @[self.view1, self.view2, self.view3, self.view4, self.view5, self.view6, self.view7]];
    [self.view addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


-(void) setupViews {
    CGRect frame = CGRectMake(0, 0, 320, 130);
    self.view1 = [[UIView alloc] initWithFrame:frame];
    self.view1.backgroundColor = [UIColor blueColor];
    
    self.view2 = [[UIView alloc] initWithFrame:frame];
    self.view2.backgroundColor = [UIColor greenColor];
    
    self.view3 = [[UIView alloc] initWithFrame:frame];
    self.view3.backgroundColor = [UIColor purpleColor];
    
    self.view4 = [[UIView alloc] initWithFrame:frame];
    self.view4.backgroundColor = [UIColor orangeColor];
    
    self.view5 = [[UIView alloc] initWithFrame:frame];
    self.view5.backgroundColor = [UIColor redColor];
    
    self.view6 = [[UIView alloc] initWithFrame:frame];
    self.view6.backgroundColor = [UIColor blackColor];
    
    self.view7 = [[UIView alloc] initWithFrame:frame];
    self.view7.backgroundColor = [UIColor yellowColor];;
    
}

-(void) removeAndInsertViews {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.stackView removeViewWithLayout:self.view3 withAnimation:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.stackView removeViewWithLayout:self.view6 withAnimation:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.stackView inserViewWithLayoutViewToInsert:self.view6 bottomView:self.view4 withAnimation:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.stackView inserViewWithLayoutViewToInsert:self.view3 topView:self.view1 withAnimation:YES];
    });
    
}

@end
