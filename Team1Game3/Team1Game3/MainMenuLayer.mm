//
//  MainMenuLayer.m
//  Team1Game
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "InstructionsLayer.h"
#import "AppDelegate.h"
#import "LevelSelectorLayer.h"

#import "SoundManager.h"

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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
		
		self.isTouchEnabled = YES;
		
		// create menu button
		[self createMenu];
        
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Hamster Coaster!" fontName:@"Marker Felt" fontSize:72];
        titleLabel.position = CGPointMake(size.width/2, 3*size.height/4);
        [self addChild:titleLabel];
        
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }
	return self;
}


-(void) createMenu
{
	[CCMenuItemFont setFontSize:35];
	
	// Play Game Button
	CCMenuItemLabel *newGame = [CCMenuItemFont itemWithString:@"Play Game" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
	}];
    
    // Instructions Button
    CCMenuItemLabel *instructions = [CCMenuItemFont itemWithString:@"Instructions" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [InstructionsLayer scene]];
	}];
	
    CCMenu *menu = [CCMenu menuWithItems:newGame, instructions, nil];
	
	[menu alignItemsVerticallyWithPadding:40.0f];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	[self addChild: menu z:-1];
}

@end
