//
//  AppDelegate.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
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

// gameManager - holds game data, notifies when game is won.
@property (nonatomic, retain) GameManager* gameManager;

@end
