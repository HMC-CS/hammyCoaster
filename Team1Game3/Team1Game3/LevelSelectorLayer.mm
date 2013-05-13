//
//  LevelSelectorLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "LevelSelectorLayer.h"

#import "LevelLayer.h"

#import "MainMenuLayer.h"
#import "SoundManager.h"


@implementation LevelSelectorLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    LevelSelectorLayer* selectorLayer = [LevelSelectorLayer node];
    
    // Create a scene with LevelSelectorLayer as the only child
    [scene addChild:selectorLayer];
	
	return scene;
}


-(id) init
{
    if (self = [super init]) {
        
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];

        [self createButtons];
        
        [self createLevelScroller];
        
        // Add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }

    return self;
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* createButtons
 * Creates main menu and data reset buttons
 */
-(void) createButtons
{    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [CCMenuItemFont setFontSize:35];
    
    // Main menu button
    CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
    }];
    
    // Reset defaults button
    CCMenuItem *resetDefaults = [CCMenuItemFont itemWithString:@"Reset Game Data" block:^(id sender) {
        [_gameManager resetUserData];
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
        
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: mainMenu, resetDefaults, nil];
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp( size.width/2, size.height/15 )];
    
    // Add the menu to the layer
    [self addChild:menu];
}

/* createLevelScroller
 * Creates the level icons
 * Note: this function is, by necessity, a little long and ugly.
 */
-(void) createLevelScroller
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // Array of the menu layers
    NSMutableArray* levelIconLayers = [[NSMutableArray alloc] init];
    
    // Selected and normal level icons for each menu layer
    NSMutableArray* levelIcons = [[NSMutableArray alloc] init];
    NSMutableArray* selectedLevelIcons = [[NSMutableArray alloc] init];
    
    double iconSize = size.height/6;
    
    for (int k = 0; k < _gameManager.numLevelSets; ++k) {
        
        // Layer for this level set
        CCLayer* levelSetLayer = [[CCLayer alloc] init];
        
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        
        // Holder for icons for one menu layer
        NSMutableArray *iconSet = [[NSMutableArray alloc] init];
        [levelIcons addObject:iconSet];
        NSMutableArray *selectedIconSet = [[NSMutableArray alloc] init];
        [selectedLevelIcons addObject:selectedIconSet];
        
        int row = _gameManager.numLevelIndices/3;
        for (int j = 0; j < 3; ++j) {
            for (int i = 0; i < row; ++i) {
                
                int levelSet = k + 1;
                int levelIndex = (j*row) + i + 1;
                
                // Normal icon for each level
                CCSprite *levelIcon = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];
                [iconSet addObject:levelIcon];
                
                CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"%d-%d", k+1, 4*j+i+1] fontName:@"Marker Felt" fontSize:levelIcon.contentSize.width*0.4];
                [label setColor:ccBLACK];
                [label setPosition:ccp(levelIcon.contentSize.width/2, levelIcon.contentSize.height/2)];
                [levelIcon addChild:label];
                
                
                // Selected icon for each level
                CCSprite *levelIconSelected = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];
                [selectedIconSet addObject:levelIconSelected];
                levelIconSelected.scale = 1.2;
                [levelIconSelected setPosition:ccp(-levelIconSelected.contentSize.width/10, -levelIconSelected.contentSize.height/10)];
                
                CCLabelTTF *labelSelected = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"%d-%d", k+1, 4*j+i+1] fontName:@"Marker Felt" fontSize:levelIcon.contentSize.width*0.4];
                [labelSelected setColor:ccBLACK];
                [labelSelected setPosition:ccp(levelIconSelected.contentSize.width/2, levelIconSelected.contentSize.height/2)];
                [levelIconSelected addChild:labelSelected];
                
                //////////////////////////////////////////////////////////////////////////
                
                // Lock on level, or display stars if level is completed
                if([_gameManager isLevelLockedAtLevelSet:1 AndIndex:levelIndex])
                {
                    // Set icon as locked, and display a lock
                    levelIcon.userData = (__bridge void*) @"Locked";
                    CCSprite* lock = [CCSprite spriteWithFile:@"lock.png"];
                    [lock setPosition:ccp(levelIcon.contentSize.width/4, levelIcon.contentSize.height/4)];
                    [levelIcon addChild:lock];
                } else if ([_gameManager isLevelCompletedAtLevelSet:levelSet AndIndex:levelIndex]){
                    
                    // Display the number of stars
                    int numStars = [_gameManager highScoreAtLevelSet:levelSet AndIndex:levelIndex];
                    [_gameManager registerCompletedLevelWithLevelSet:levelSet AndIndex:levelIndex AndStarCount:numStars];
                    
                    CGPoint starLocation = ccp(levelIcon.contentSize.width/4.5, levelIcon.contentSize.height/5);
                    
                    // Display star outlines if star not obtained, otherwise display filled-in stars.
                    for (int i = 1; i <= 3; ++i) {
                        if (numStars < i) {
                            CCSprite *sprite = [CCSprite spriteWithFile:@"StarObjectOutline.png"];
                            CCSprite *sprite2 = [CCSprite spriteWithFile:@"StarObjectOutline.png"];
                            [sprite setPosition:starLocation];
                            [sprite2 setPosition:starLocation];
                            [levelIcon addChild:sprite];
                            [levelIconSelected addChild:sprite2];
                        } else {
                            CCSprite *sprite = [CCSprite spriteWithFile:@"StarObject.png"];
                            CCSprite *sprite2 = [CCSprite spriteWithFile:@"StarObject.png"];
                            [sprite setPosition:starLocation];
                            [sprite2 setPosition:starLocation];
                            [levelIcon addChild:sprite];
                            [levelIconSelected addChild:sprite2];
                        }
                        starLocation = ccp(starLocation.x + levelIcon.contentSize.width/3.5, starLocation.y);
                    }
                }
                
                //////////////////////////////////////////////////////////////////////////
                
                // Make a level icon menu item
                CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:levelIcon selectedSprite:levelIconSelected block:^(id sender) {
                    NSString* lockString = (NSString *)levelIcon.userData;
                    if (![lockString isEqualToString:@"Locked"]) {
                        [[CCDirector sharedDirector] pushScene:[LevelLayer sceneWithLevelSet:levelSet AndIndex:levelIndex]];
                    } else{
                        return;
                    }
                }];
                menuItem.scale = (iconSize * levelIcon.scale)/levelIcon.contentSize.width;
                [menuItem setPosition:ccp(size.width*((i+1.0)/5.0-0.5), -size.height*((j+1.0)/4.0-0.5))];
                [menuItems addObject:menuItem];
            }
        }
        
        // Menu of all the level icon buttons
        CCMenu* menu = [CCMenu menuWithArray:menuItems];
        [menu setPosition:ccp( size.width/2, size.height/2)];
        [levelSetLayer addChild:menu];
        
        [levelIconLayers addObject:levelSetLayer];
        
    }
    
    // Scroller with all the level icon button menus
    CCScrollLayer* scroller = [CCScrollLayer nodeWithLayers:levelIconLayers widthOffset:0];
    [self addChild:scroller];
    
}

@end
