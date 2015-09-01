//
//  StackViewAutoLayout.m
//  Stox
//
//  Created by Matan Cohen on 3/26/15.

//

#import "StackViewAutoLayout.h"
#import "IStackViewAware.h"
#import <Masonry/Masonry.h>
#import "UIView_Extensions.h"
#import "UIView+StackViewExtentions.h"

@interface WeakSubview : NSObject
@property (nonatomic, weak) UIView *subview;
@property (nonatomic, assign) CGRect frameInScroll;
@end
@implementation WeakSubview
@end


@interface StackViewAutoLayout () {
    NSMutableOrderedSet *_weakSubviews;
    NSMutableOrderedSet *_weakStickySubviews;
    BOOL _conterConent;
}
@end

@implementation StackViewAutoLayout {
    double contentHight;
    NSNumber *_padding;

}

-(instancetype) initWithLayoutSubviews:(NSArray *) layoutSubviews {
    self = [super init];
    if (self) {
        [self initSetup];
        for (UIView *view in layoutSubviews) {
            view.userInteractionEnabled = YES;
            [self addSubviewToList:view];
        }
        [self reloadData];
    }
    return self;
}

-(instancetype) initWithPadding: (NSNumber *) padding {
    self = [super init];
    if (self) {
        _padding = padding;
        [self initSetup];
    }
    return self;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

-(void) initSetup {
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(void) setupContentView {
    contentHight = 0;
    
    [self setDelaysContentTouches:NO];
    self.canCancelContentTouches = NO;
}

#pragma mark - same with tableView

-(void) centerContent:(BOOL) center  {
    _conterConent = center;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (_conterConent == YES) {
        self.contentOffset = CGPointMake(self.contentOffset.x, -((self.height - self.contentSize.height) /2 ));
    }
}

-(void) setBottomPadding:(float) bottomBottom
           withAnimation: (BOOL) animation {
    
    UIView *bottomFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, bottomBottom)];
    if (animation) {
        [UIView beginAnimations:nil context:NULL];
        self.tableFooterView = bottomFooter;
        [UIView commitAnimations];
    } else {
        self.tableFooterView = bottomFooter;
    }
}

-(void) removeBottomPaddingWithAnimation: (BOOL) animation {
    if (animation) {
        [UIView beginAnimations:nil context:NULL];
        self.tableFooterView = nil;
        [UIView commitAnimations];
    } else {
         self.tableFooterView = nil;
    }
}


- (void)addSubviewWithLayout:(UIView *)view {
    if (!view) {
        @throw [NSException exceptionWithName:@"View is Nil!" reason:@"View is Nil!" userInfo:nil];
    }
    view.userInteractionEnabled = YES;
    [self addSubviewToList:view];
    [self reloadData];    
}

-(void) addStickySubviewWithLayout:(UIView *) stickyView {
    if (!stickyView) {
        @throw [NSException exceptionWithName:@"View is Nil!" reason:@"View is Nil!" userInfo:nil];
    }
    if (!_weakStickySubviews) {
        _weakStickySubviews = [NSMutableOrderedSet orderedSet];
    } else {
        @throw [NSException exceptionWithName:@"Only one sticky view allowed!" reason:@"Only one sticky view allowed!" userInfo:nil];
    }
    stickyView.isSticky = YES;
    
    WeakSubview *weakStickySubview = [[WeakSubview alloc] init];
    weakStickySubview.subview = stickyView;
    [_weakStickySubviews addObject:weakStickySubview];
    
    [self addSubviewWithLayout:stickyView];
}


-(void) inserViewWithLayoutViewToInsert: (UIView *) viewToInsert
                                topView: (UIView *) topView
                          withAnimation:(BOOL) animation {
    

    
    [self inserViewWithLayoutViewToInsert:viewToInsert BetweenTopView:topView withBottomView:nil  withAnimation:animation];
    
}

-(void) inserViewWithLayoutViewToInsert: (UIView *) viewToInsert
                             bottomView: (UIView *) bottomView
                          withAnimation:(BOOL) animation {
    

    [self inserViewWithLayoutViewToInsert:viewToInsert BetweenTopView:nil withBottomView:bottomView  withAnimation:animation];
}

-(void) inserViewWithLayoutViewToInsert: (UIView *) viewToInsert
                         BetweenTopView: (UIView *) topView
                         withBottomView: (UIView *) bottomView
                          withAnimation:(BOOL) animation {
    
    if (!viewToInsert || ((!topView) && (!bottomView))) {
        @throw [NSException exceptionWithName:@"View is Nil!" reason:@"View is Nil!" userInfo:nil];
    }
    
    if ([self isViewOnStack:viewToInsert]) {
        return;
    }
    
    viewToInsert.userInteractionEnabled = YES;
    
    NSIndexPath *indexPath;
    if (topView) {

            [self insertSubviewToList:viewToInsert topView:topView];
                indexPath = [NSIndexPath indexPathForRow:viewToInsert.row-1 inSection:0];
    } else {

        [self insertSubviewToList:viewToInsert bottomView:bottomView];
                indexPath = [NSIndexPath indexPathForRow:viewToInsert.row-1 inSection:0];
    }

    
    if (animation) {
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self endUpdates];
    } else {
        [self reloadData];
    }
}

-(void) removeViewWithLayout: (UIView *) viewToRemove
               withAnimation:(BOOL) animation {

    if (![self isViewOnStack:viewToRemove]) {
        return;
    }
    
    
    [self removeViewFromDictionary:viewToRemove];
    
    if (animation) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewToRemove.row-1 inSection:0];
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self endUpdates];
    } else {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewToRemove.row-1 inSection:0];
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];

    }
    
    //This must me here so viewtoRemove still has tag
    viewToRemove.row = 0;

}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self countWeakSubviews];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *currentView = [self weakSubviewAtIndex:indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"%lu",(unsigned long)currentView.hash];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    } else {
        if (!currentView.isSticky) {
            return cell;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    //now remove any subview a reused cell might have:
    [cell.contentView removeAllSubviews];
    //and in part of the method, you'll need to create the subview if the cell is in the top row.
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    currentView.containerCell = cell;
    
    //After the first time cell in layed out, the sticky view will change location on scrollViewdidScroll.
    if (currentView.isSticky && currentView.didSet) {
        return cell;
    }
    
    if (!cell.containerCell) {
        [cell.contentView addSubview:currentView];
        [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    currentView.isDisplayOnCell = YES;
    currentView.didSet = YES;
    return cell;
}

-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {

    UIView *currentView = [self weakSubviewAtIndex:indexPath.row];
    return currentView.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [_padding floatValue];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
     UIView *currentView = [self weakSubviewAtIndex:indexPath.row];

    if ([currentView conformsToProtocol:@protocol(IStackViewAware)]) {
        UIView <IStackViewAware> *viewModelAware = (UIView <IStackViewAware> *) currentView;
        
        if ([viewModelAware respondsToSelector:@selector(willDisplayView)]) {
            [viewModelAware willDisplayView];
        }
        
    }
}

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *currentView = [self weakSubviewAtIndex:indexPath.row];
    
    if ([currentView conformsToProtocol:@protocol(IStackViewAware)]) {
        UIView <IStackViewAware> *viewModelAware = (UIView <IStackViewAware> *) currentView;
        
        if ([viewModelAware respondsToSelector:@selector(willRemoveFromDisplay)]) {
            [viewModelAware willRemoveFromDisplay];
        }
        
    }

        if (currentView.containerCell) {
            currentView.containerCell = nil;
        }
}

#pragma mark - getters

-(CGRect) rectInScrollView:(UIView *) view {

    WeakSubview *weakSubview =  _weakSubviews[view.row-1];
    return weakSubview.frameInScroll;
}

#pragma mark dic new


-(BOOL) isViewOnStack:(UIView *) view {
    if (view.row && view.row > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Subviews for Index number

-(void) addSubviewToList:(UIView *) view {
    
    [self addViewToWeakSubview:view];
    
    view.row = [self countWeakSubviews];
    
}

-(void) insertSubviewToList:(UIView *) view
                          topView:(UIView *) topView {
    
    int topViewTag = (int)topView.row;
    int currentViewTag = topViewTag;

    view.row = currentViewTag;
    
    [self insertViewToWeakSubviewsAtIndex:view index:currentViewTag];
    [self reTag];
}

-(void) insertSubviewToList:(UIView *) view
                    bottomView:(UIView *) bottomView {

    int bottomViewTag = (int)bottomView.row;
    int currentViewTag = bottomViewTag -1;

    view.row = currentViewTag;
    
    [self insertViewToWeakSubviewsAtIndex:view index:currentViewTag];
    [self reTag];
}

-(void) removeViewFromDictionary:(UIView *) view {
    
    int viewTag = (int)view.row;

    [self removeViewAtIndexFromWeakSubviews:viewTag-1];
    [self reTag];
}

-(void) reTag {
    
    for (WeakSubview *weakSubview in _weakSubviews) {
        UIView *curView = weakSubview.subview;
        curView.row = [_weakSubviews indexOfObject:weakSubview]+1;
    }

}

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
if ([self.delegateStack respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegateStack scrollViewDidScroll:scrollView];
    }
    
#pragma clang diagnostic pop

    if (_weakStickySubviews) {
        [self configureStickyViewOnScroll:scrollView];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.delegateStack respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegateStack scrollViewDidEndDecelerating:scrollView];
    }

    
#pragma clang diagnostic pop

}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.delegateStack respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegateStack scrollViewWillBeginDecelerating:scrollView];
    }
    
    
#pragma clang diagnostic pop
}




#pragma mark - WeakSubviews manipulation

-(void) addViewToWeakSubview:(UIView *) view {
    if (!_weakSubviews) {
        _weakSubviews = [NSMutableOrderedSet orderedSet];
    }
    WeakSubview *subview = [WeakSubview new];
    subview.subview = view;
    subview.frameInScroll = CGRectMake(0, [self yPointOfView:view], view.width, view.height);
    [_weakSubviews addObject:subview];
}

-(void) removeViewAtIndexFromWeakSubviews:(NSUInteger) index {
    [_weakSubviews removeObjectAtIndex:index];
}

-(void) insertViewToWeakSubviewsAtIndex:(UIView *) view
                                  index:(NSUInteger) index {
    WeakSubview *subview = [WeakSubview new];
    subview.subview = view;
    subview.frameInScroll = CGRectMake(0, [self yPointOfView:view], view.width, view.height);
    [_weakSubviews insertObject:subview atIndex:index];
    
}

-(UIView *) weakSubviewAtIndex:(NSUInteger) index {
    WeakSubview *weakSubview = _weakSubviews[index];
    return weakSubview.subview;
}

-(NSUInteger) countWeakSubviews {
    return _weakSubviews.count;
}

-(float) yPointOfView:(UIView *) view {
    
    NSUInteger seposedTag = 0;
    if (view.row) {
        seposedTag = view.row;
    } else {
        seposedTag = [self countWeakSubviews];
    }
    
    float totalHeight = 0;
    for (WeakSubview *subview in _weakSubviews) {
        if (subview.subview.row < seposedTag) {
            totalHeight += subview.subview.frame.size.height;
        }
    }
    return totalHeight;
}

#pragma mark - StickyView

-(void) configureStickyViewOnScroll:(UIScrollView *) scorllView {
    if (scorllView.contentOffset.y < 0) {
        return;
    }
    
    for (WeakSubview *stickyWeakSubview in _weakStickySubviews) {
        
        float distanceBetweenSelfAndSuper = self.frame.origin.y;
        UITableViewCell *currentCell = stickyWeakSubview.subview.containerCell;
        float yPoint = [self convertPoint:CGPointMake(currentCell.centerX, currentCell.top) toView:self.superview].y - distanceBetweenSelfAndSuper;
        UIView *currentView = stickyWeakSubview.subview;
        
        if ((int)yPoint <= 0) {
            if (!currentView.isDisplayOnCell) {
                return;
            }
            
            [self.superview addSubview:stickyWeakSubview.subview];
            currentView.isDisplayOnCell = NO;
            __weak StackViewAutoLayout *weakSelf = self;
            
            [stickyWeakSubview.subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_top);
                make.centerX.equalTo(weakSelf.superview.mas_centerX);
                make.width.equalTo(@(currentCell.width));
                make.height.equalTo(@(currentCell.height));
            }];
            
            self.isStickyViewStackOnTop = YES;
        } else {
            if (currentView.isDisplayOnCell) {
                return;
            }
            
            currentView.isDisplayOnCell = YES;
            [currentCell.contentView addSubview:currentView];
            
            [currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(currentCell.contentView);
            }];
            self.isStickyViewStackOnTop = NO;
            
        }
    }
}

@end
