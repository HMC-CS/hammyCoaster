//
//  MainMenuLayer.m
//  Team1Game
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "MainMenuLayer.h"
#import "InstructionsLayer.h"
#import "AppController.h"
#import "LevelSelectorLayer.h"

#import "SoundManager.h"

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// Add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}

-(id) init
{
	if( (self=[super init])) {

        CGSize size = [[CCDirector sharedDirector] winSize];
		
		self.isTouchEnabled = YES;
        
		// put picture as background
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"MainMenu.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:-2];
        
		// Create menu buttons
		[self createMenu];
        
        // Display game title
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Hamster Coaster!" fontName:@"Marker Felt" fontSize:72];
        titleLabel.position = CGPointMake(size.width/2, 3*size.height/4);
        [self addChild:titleLabel];
        
        // Sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }
	return self;
}


/* ////////////////////////////// Private Functions ////////////////////////////// */

/* createMenu
 * Helper function to create the menu for the scene.
 */
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
