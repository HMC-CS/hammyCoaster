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
        
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"LevelSelectorLayer.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:-2];
        
        NSMutableArray* _instructionLayers = [[NSMutableArray alloc] init];
        
        CCSprite* instructions1 = [CCSprite spriteWithFile:@"instructions1.png"];
         instructions1.position = ccp(size.width/2, size.height/1.9);
        CCSprite* instructions2 = [CCSprite spriteWithFile:@"instructions2.png"];
           instructions2.position = ccp(size.width/2, size.height/1.9);
        CCSprite* instructions3 = [CCSprite spriteWithFile:@"instructions3.png"];
           instructions3.position = ccp(size.width/2, size.height/1.9);
        

        NSArray* instructionLabels = [NSArray arrayWithObjects:instructions1, instructions2, instructions3, nil];
        
        for (int i = 0; i < [instructionLabels count]; i++) {
            
            // Make a new layer for each instruction
            CCLayer* instructionLayer = [[CCLayer alloc] init];
            
            CCSprite* instructionLabel = instructionLabels[i];
            
            
            // Add instructions to it
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
