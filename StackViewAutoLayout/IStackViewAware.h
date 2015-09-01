//
//  IStackViewAware.h
//  Stox
//
//  Created by Matan Cohen on 5/18/15.

//

#import <Foundation/Foundation.h>

@protocol IStackViewAware <NSObject>

@optional

-(void) willDisplayView;
-(void) willRemoveFromDisplay;
@end
