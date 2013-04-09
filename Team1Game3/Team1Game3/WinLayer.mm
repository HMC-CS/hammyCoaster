//
//  WinLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/30/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WinLayer.h"

#import "LevelLayer.h"

#import "MainMenuLayer.h"
#import "LevelSelectorLayer.h"


@implementation WinLayer

+(CCScene *) sceneWithLevel: (int)level AndStarCount: (int) stars
{
    CCScene *scene = [CCScene node];	// 'scene' is an autorelease object.
    
    WinLayer* winLayer = [[WinLayer alloc] initWithLevel:level AndStarCount:stars];
    
    [scene addChild:winLayer];
	
	// return the scene
	return scene;
}

-(id) initWithLevel:(int)level AndStarCount:(int)stars
{
    if (self = [super init]) {
        
        _level = level;
        _stars = stars;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        /////////////
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        // Reset Button
        CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
        }];
        CCMenuItemLabel *replay = [CCMenuItemFont itemWithString:@"Replay level" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:1 AndIndex:_level]];
        }];
        CCMenuItemLabel *next = [CCMenuItemFont itemWithString:@"Next level" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:1 AndIndex:_level+1]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:mainMenu, replay, next, nil];
        
        [menu alignItemsVertically];
        
        [menu setPosition:ccp( size.width/2, size.height/2)];
        
        [self addChild: menu z:-1];
    }
    
    return self;
}

@end
