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
#import "PhysicsSprite.h"


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
        
        self.isTouchEnabled = YES;
        
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
        
        /////////////
        
        [self createMenu];
        [self drawStars];
    }
    
    return self;
}

-(void) createMenu
{
    [CCMenuItemFont setFontSize:30];
    
    // Reset Button
    
    CCMenuItemLabel *replay = [CCMenuItemFont itemWithString:@"Replay level" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:1 AndIndex:_level]];
    }];
    CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
    }];
    CCMenuItemLabel *levelMenu = [CCMenuItemFont itemWithString:@"Level Selector" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
    }];
    
    
    CCMenu* menu;
    if (_level != _gameManager.numLevelIndices) {
        CCMenuItemLabel *next = [CCMenuItemFont itemWithString:@"Next level" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:1 AndIndex:_level+1]];
        }];
        menu = [CCMenu menuWithItems:replay, next, mainMenu, levelMenu, nil];
    } else {
        menu = [CCMenu menuWithItems:replay, mainMenu, levelMenu, nil];
    }
        
    [menu alignItemsVerticallyWithPadding:30.0f];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [menu setPosition:ccp( size.width/2, size.height/2)];
    
    [self addChild: menu z:-1];
}

-(void) drawStars
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CGPoint starLocation = ccp(size.width/2 - 75, size.height - 100);
    
    for (int i = 1; i <= 3; ++i) {
        if (_stars < i) {
            CCSprite *sprite = [CCSprite spriteWithFile:@"StarObjectOutline.png"];
            [sprite setPosition:starLocation];
            [self addChild:sprite];
        } else {
            CCSprite *sprite = [CCSprite spriteWithFile:@"StarObject.png"];
            [sprite setPosition:starLocation];
            [self addChild:sprite];
        }
        starLocation = ccp(starLocation.x + 75, starLocation.y);
    }
}

@end
