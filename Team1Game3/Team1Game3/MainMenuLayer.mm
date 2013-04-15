//
//  MainMenuLayer.m
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "InstructionsLayer.h"
#import "AppDelegate.h"
#import "LevelSelectorLayer.h"


@implementation MainMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		
		// create menu button
		[self createMenu];
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Play Game Button
	CCMenuItemLabel *newGame = [CCMenuItemFont itemWithString:@"Play Game" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
	}];
    
    // Instructions Button
    CCMenuItemLabel *instructions = [CCMenuItemFont itemWithString:@"Instructions" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [InstructionsLayer scene]];
	}];
	
    CCMenu *menu = [CCMenu menuWithItems:newGame, instructions, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	[self addChild: menu z:-1];
}

@end
