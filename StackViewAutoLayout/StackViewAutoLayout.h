//
//  StackViewAutoLayout.h
//  Stox
//
//  Created by Matan Cohen on 3/26/15.

//

#import <UIKit/UIKit.h>

@protocol StackViewDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView ;
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView ;
-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView ;
@end

@interface StackViewAutoLayout : UITableView < UITableViewDelegate , UITableViewDataSource >
@property (nonatomic, weak) id <StackViewDelegate> delegateStack;
@property (nonatomic, assign) BOOL isStickyViewStackOnTop;

-(instancetype) initWithLayoutSubviews:(NSArray *) layoutSubviews;
-(instancetype) initWithPadding: (NSNumber *) padding;

-(void) setBottomPadding:(float) bottomBottom
           withAnimation: (BOOL) animation;
-(void) removeBottomPaddingWithAnimation: (BOOL) animation;

-(void) addStickySubviewWithLayout:(UIView *) stickyView;
-(void)addSubviewWithLayout:(UIView *)view;
-(void) inserViewWithLayoutViewToInsert: (UIView *) viewToInsert
                                topView: (UIView *) topView
                          withAnimation:(BOOL) animation;
-(void) inserViewWithLayoutViewToInsert: (UIView *) viewToInsert
                             bottomView: (UIView *) bottomView
                          withAnimation:(BOOL) animation;
-(void) removeViewWithLayout: (UIView *) viewToRemove
                          withAnimation:(BOOL) animation;

-(BOOL) isViewOnStack:(UIView *) view ;
-(void) centerContent:(BOOL) center;
-(CGRect) rectInScrollView:(UIView *) view;

@end
