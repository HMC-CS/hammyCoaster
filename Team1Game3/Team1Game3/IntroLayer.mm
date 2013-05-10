//
//  IntroLayer.m
//  Team1Game2
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MainMenuLayer.h"

#import "SoundManager.h"


#pragma mark - IntroLayer

// IntroLaye implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the IntroLaye as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Displays intro image, then fades to next layer
-(void) onEnter
{
	[super onEnter];
    
    [[SoundManager sharedSoundManager] toggleBackgroundMusic]; //play background music
    
	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"IntroLayer1.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"IntroLayer1.png"];
	}
	background.position = ccp(size.width/2, size.height/2);
    
	// add the label as a child to this Layer
	[self addChild: background];
    	
	// In half second, transition to the new scene(which takes half a second)
	[self scheduleOnce:@selector(makeTransition:) delay:2];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}
@end
