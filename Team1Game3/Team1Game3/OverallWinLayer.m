//
//  OverallWinLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/11/13.
//
//

#import "OverallWinLayer.h"

#import "MainMenuLayer.h"
#import "LevelSelectorLayer.h"
#import "SoundManager.h"

@implementation OverallWinLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    OverallWinLayer* overallWinLayer = [[OverallWinLayer alloc] init];
    
    // Add the layer to the scene
    [scene addChild:overallWinLayer];
	
	return scene;
}


-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        // Label declaring "YOU WIN!"
        [CCMenuItemFont setFontSize:22];
        CCLabelTTF* _winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"YOU WIN!"] fontName:@"Marker Felt" fontSize:24];
        _winLabel.position = CGPointMake(size.width/2, 2*size.height/3);
        [self addChild:_winLabel];
        
        
        
        // Main menu and level selector menu buttons
        [CCMenuItemFont setFontSize:30];
        CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
        }];
        CCMenuItemLabel *levelMenu = [CCMenuItemFont itemWithString:@"Level Selector" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
        }];
        
        // Format main menu/level selector menu and add it to the layer
        CCMenu *menu = [CCMenu menuWithItems:mainMenu, levelMenu, nil];
        [menu alignItemsVerticallyWithPadding:30.0f];
        [menu setPosition:ccp( size.width/2, size.height/2)];
        [self addChild: menu z:-1];
        
        
        
        // Add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }
    
    return self;
}


@end
