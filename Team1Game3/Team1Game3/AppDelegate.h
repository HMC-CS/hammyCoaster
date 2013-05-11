//
//  AppDelegate.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//  Copyright CS121:Team 1 Physics 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "GameManager.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
}

//default
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

// Game Manager - holds game data
@property (nonatomic, retain) GameManager* gameManager;

@end
