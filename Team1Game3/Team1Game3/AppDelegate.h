//
//  AppDelegate.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "OverallWinLayer.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
    
    int _numLevelSets;
    int _numLevelIndices;
    
    int _numLevelsCompleted;
    NSMutableArray* _levelCompletionStatuses;
}

//default
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

//ours
@property (readonly) int numLevelSets;
@property (readonly) int numLevelIndices;

-(bool) isCompletedLevelWithLevelSet: (int) set AndIndex: (int) index;
-(void) completedLevelWithLevelSet:(int)set AndIndex:(int)index;

@end
