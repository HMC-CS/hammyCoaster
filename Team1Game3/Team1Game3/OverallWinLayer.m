//
//  OverallWinLayer.m
//  Team1Game3
//
//  Created by jarthur on 4/11/13.
//
//

#import "OverallWinLayer.h"

#import "MainMenuLayer.h"
#import "LevelSelectorLayer.h"
#import "SoundManager.h"

@implementation OverallWinLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];	// 'scene' is an autorelease object.
    
    OverallWinLayer* overallWinLayer = [[OverallWinLayer alloc] init];
    
    [scene addChild:overallWinLayer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        /////////////
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        CCLabelTTF* _winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"YOU WIN!"] fontName:@"Marker Felt" fontSize:24];
        _winLabel.position = CGPointMake(size.width/2, 2*size.height/3);
        [self addChild:_winLabel];
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:30];
        
        // Reset Button
        CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
        }];
        CCMenuItemLabel *levelMenu = [CCMenuItemFont itemWithString:@"Level Selector" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:mainMenu, levelMenu, nil];
        
        [menu alignItemsVerticallyWithPadding:30.0f];
        
        [menu setPosition:ccp( size.width/2, size.height/2)];
        
        [self addChild: menu z:-1];
        
        // add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        soundMenu.position=ccp([[CCDirector sharedDirector] winSize].width - 100, 50);
        [self addChild:soundMenu z:1];
    }
    
    return self;
}


@end
