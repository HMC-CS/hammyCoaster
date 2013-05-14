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
	CCScene *scene = [CCScene node];
	InstructionsLayer *layer = [InstructionsLayer node];
	
	// Add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}

-(id) init
{
	if (self = [super init]) {
		
		self.isTouchEnabled = YES;
        CGSize size = [CCDirector sharedDirector].winSize;
        
        NSMutableArray* _instructionLayers = [[NSMutableArray alloc] init];
        
        // Instructions
        CCLabelTTF* instructionLabel0 = [CCLabelTTF labelWithString:@"Welcome to Hamster Coaster!\n Introduction:\n Your hamster is lost and needs to make it home, but the only way to do this is by following a trail of cupcakes down a wild ride on the Hamster Coaster! \nHelp him find his way through each level to make it home, but don't forget to collect stars along the way. Your hamster is very hungry and stars are his favorite snack! \n\n Goal: \n The goal of the game is to get the hamster from the red pipe to the blue cupcake, collecting as many stars as possible along the way." dimensions:CGSizeMake(self.contentSize.width, self.contentSize.height) hAlignment:kCCTextAlignmentCenter fontName:@"Marker Felt" fontSize:24];
        
        CCLabelTTF* instructionLabel1 = [CCLabelTTF labelWithString:@"How to Play: \n You must use the objects given to you on each level that make it possible for your hamster to roll from one portal to another. You can place the objects on the game play board and drag them by pressing and dragging them from the inventory box with your finger. You can delete objects by dragging them back into the inventory. Once you are done placing objects you can get your hamster moving by pressing the get the Start! button. Be careful though because once you press this button you will no longer be able to add more objects or move the objects you have already placed." dimensions:CGSizeMake(self.contentSize.width, self.contentSize.height) hAlignment:kCCTextAlignmentCenter fontName:@"Marker Felt" fontSize:24];
        
        CCLabelTTF* instructionLabel2 = [CCLabelTTF labelWithString:@"Rules: \n * You are alloted only a certain number of objects for each level as indicated by the number over the object. \n * When you choose to delete an object it will be added back to your inventory so you can use it again. \n * Objects can only be placed within the bounds of the game play space (i.e. not overlapping in the inventory layer or outside of the screen). \n * Reset Ball returns your hamster to the starting red portal with the same objects, and reset returns to the original level screen. \n Scoring: \n * Your score is received based on how many stars you are able to collect during a completed level" dimensions:CGSizeMake(self.contentSize.width, self.contentSize.height) hAlignment:kCCTextAlignmentCenter fontName:@"Marker Felt" fontSize:24];
        
        NSArray* instructionLabels = [NSArray arrayWithObjects:instructionLabel0, instructionLabel1, instructionLabel2, nil];
        
        for (int i = 0; i < [instructionLabels count]; i++) {
            
            // Make a new layer for each instruction
            CCLayer* instructionLayer = [[CCLayer alloc] init];
            
            // Add instructions to it
            CCLabelTTF* instructionLabel = instructionLabels[i];
            CGSize textSize = [instructionLabel.string sizeWithFont:[UIFont fontWithName:@"Marker Felt" size:24]];
            [instructionLabel setAnchorPoint: ccp(0.5f, 0.05f)];
            instructionLabel.position = ccp((instructionLabel.boundingBox.size.width)/2, textSize.height/2.0);
            [instructionLayer addChild:instructionLabel];

            // Make menu on layer to go back to main menu
            CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
                [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
            }];
            CCMenu *menu = [CCMenu menuWithItems: mainMenu, nil];
            [menu alignItemsHorizontallyWithPadding:20];
            [menu setPosition:ccp( size.width/2, size.height/15 )];
            // Add the menu to the layer
            [self addChild:menu];
            
            
            // Add sound buttons
            CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
            [self addChild:soundMenu z:1];
            
            // Add this layer to the set of layers
            [_instructionLayers addObject:instructionLayer];
        }
        
        // Add all layers to the scroller
        _scroller = [CCScrollLayer nodeWithLayers:_instructionLayers widthOffset:0];
        [self addChild:_scroller];
	}
    
	return self;
}

@end
