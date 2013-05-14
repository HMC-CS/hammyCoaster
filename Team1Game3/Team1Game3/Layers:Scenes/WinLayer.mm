//
//  WinLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "WinLayer.h"

#import "LevelLayer.h"

#import "MainMenuLayer.h"
#import "LevelSelectorLayer.h"
#import "PhysicsSprite.h"
#import "SoundManager.h"


@implementation WinLayer

+(CCScene *) sceneWithLevelSet:(int)levelSet AndIndex:(int)levelIndex AndStarCount:(int)stars
{
    CCScene *scene = [CCScene node];
    WinLayer* winLayer = [[WinLayer alloc] initWithLevelSet:levelSet AndIndex:levelIndex AndStarCount:stars];
    
    // Add layer as a child to scene
    [scene addChild:winLayer];
	
	return scene;
}


-(id) initWithLevelSet:(int)levelSet AndIndex:(int)levelIndex AndStarCount:(int)stars
{
    if (self = [super init]) {
        
        _levelSet = levelSet;
        _levelIndex = levelIndex;
        _stars = stars;
        
        self.isTouchEnabled = YES;
        
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
        
        /////////////
        
        // put picture as background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"GoalLayer.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:-2];
        
        [self createMenu];
        [self drawStars];
        
        // add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }
    
    return self;
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* createMenu
 * Create menu buttons on Win Layer
 */
-(void) createMenu
{
    [CCMenuItemFont setFontSize:30];
    
    // Replay, main menu, and level selector menu buttons
    CCMenuItemLabel *replay = [CCMenuItemFont itemWithString:@"Replay level" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:_levelSet AndIndex:_levelIndex]];
    }];
    CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
    }];
    CCMenuItemLabel *levelMenu = [CCMenuItemFont itemWithString:@"Level Selector" block:^(id sender){
        [[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
    }];
    
    int levelNumber = _gameManager.numLevelIndices * (_levelSet - 1) + _levelIndex;
    CCMenu* menu;
    
    // Different menus based on whether you've hit the last level or not.
    if (levelNumber != _gameManager.numLevelIndices * _gameManager.numLevelSets) {
        ++levelNumber;
        int nextLevelSet = (levelNumber-1)/_gameManager.numLevelIndices + 1;
        int nextLevelIndex = (levelNumber-1) % _gameManager.numLevelIndices + 1;
        CCMenuItemLabel *next = [CCMenuItemFont itemWithString:@"Next level" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelLayer sceneWithLevelSet:nextLevelSet AndIndex:nextLevelIndex]];
        }];
        menu = [CCMenu menuWithItems:replay, next, mainMenu, levelMenu, nil];
    } else {
        menu = [CCMenu menuWithItems:replay, mainMenu, levelMenu, nil];
    }
    
    // Format the menu and add it to the scene
    [menu alignItemsVerticallyWithPadding:30.0f];
    CGSize size = [[CCDirector sharedDirector] winSize];
    [menu setPosition:ccp( size.width/2, size.height/2)];
    [self addChild: menu z:-1];
}


/* drawStars
 * Draws the stars on the WinLayer screen based on number of stars obtained in level
 */
-(void) drawStars
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CGPoint starLocation = ccp(size.width/2 - 75, size.height - 100);
    
    // Insert star outlines or filled-in stars based on how many stars have been obtained
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
