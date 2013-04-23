//
//  InstructionsLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley on 4/15/13.
//
//

#import "InstructionsLayer.h"

#import "MainMenuLayer.h"
#import "SoundManager.h"

@implementation InstructionsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InstructionsLayer *layer = [InstructionsLayer node];
	
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
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        // Instruction
        CCLabelTTF* instructionLabel = [CCLabelTTF labelWithString:@"Welcome to Hamster Coaster!\n Introduction:\n Your hamster is lost and needs to make it home, but the only way to do this is through a wild ride on the Hamster Coaster! Help him find his way through each level to make it home, but don't forget to collect stars along the way. Your hamster is very hungry and stars are is favorite snack. \n Goal: \n The goal of the game is to get the hamster from the red portal to the blue portal, while collecting as many stars as possible along the way. \n How to Play: \n You must use the objects given to you on each level that appear in the inventory box to make it possible for your hamster to roll from one portal to another. You can place the objects on the game play board and drag them by pressing and dragging with your finger. You can also delete objects by selecting the delete object button and then tapping on the object you want to delete. It will then be added back to your inventory. Once you are done placing objects you can get your hamster moving by pressing the get the ball rolling button. Be careful though because once you press this button you will no longer be able to add more objects or move the objects you have already placed. \nRules: \n * You are alloted only a certain number of objects for each level as indicated by the number over the object. \n * When you choose to delete an object it will be added back to your inventory so you can use it again. \n * Objects can only be placed within the bounds of the game play space (i.e. not overlapping in the inventory layer or outside of the screen). \n * Reset Ball returns your hamster to the starting red portal with the same objects, and reset returns to the original level screen. \n Scoring: \n * Your score is received based on how many stars you are able to collect during a completed level" dimensions:CGSizeMake(self.contentSize.width, self.contentSize.height) hAlignment:kCCTextAlignmentCenter fontName:@"Marker Felt" fontSize:24];
        CGSize textSize = [instructionLabel.string sizeWithFont:[UIFont fontWithName:@"Marker Felt" size:24]];
        //instructionLabel.position = CGPointMake(self.boundingBox.origin.x, self.boundingBox.origin.y);
        [instructionLabel setAnchorPoint: ccp(0.5f, 0.05f)];
        //instructionLabel.anchorPoint = ccp(0.0f,0.25f); //CGPointZero;
        instructionLabel.position = ccp((instructionLabel.boundingBox.size.width)/2, textSize.height/2.0);
        [self addChild:instructionLabel];

        CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: mainMenu, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/15 )];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        // add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
		
	}
	return self;
}

@end
