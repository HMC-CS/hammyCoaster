//
//  InstructionsLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley on 4/15/13.
//
//

#import "InstructionsLayer.h"

#import "MainMenuLayer.h"

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
        CCLabelTTF* instructionLabel = [CCLabelTTF labelWithString:@"The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog." dimensions:CGSizeMake(self.contentSize.width, self.contentSize.height) hAlignment:kCCTextAlignmentCenter fontName:@"Marker Felt" fontSize:24];
        CGSize textSize = [instructionLabel.string sizeWithFont:[UIFont fontWithName:@"Marker Felt" size:24]];
        //instructionLabel.position = CGPointMake(self.boundingBox.origin.x, self.boundingBox.origin.y);
        instructionLabel.anchorPoint = CGPointZero;
        instructionLabel.position = ccp((instructionLabel.boundingBox.size.width  -textSize.width)/2.0f, textSize.height/2.0);
        [self addChild:instructionLabel];

        CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: mainMenu, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/15 )];
		
		// Add the menu to the layer
		[self addChild:menu];
		
	}
	return self;
}

@end
