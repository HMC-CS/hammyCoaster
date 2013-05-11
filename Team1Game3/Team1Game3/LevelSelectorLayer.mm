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
    CCScene *scene = [CCScene node];	// 'scene' is an autorelease object.
    
    LevelSelectorLayer* selectorLayer = [LevelSelectorLayer node];
    
    [scene addChild:selectorLayer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
        
        /////////////
        [CCMenuItemFont setFontSize:35];
        CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
        }];
        
        CCMenuItem *resetDefaults = [CCMenuItemFont itemWithString:@"Reset Game Data" block:^(id sender) {
            [_gameManager resetUserData];
            [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];

        }];
        
        CCMenu *menu = [CCMenu menuWithItems: mainMenu, resetDefaults, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/15 )];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        ////////////////
        
//        // TODO: comment back in if multiple level sets added
//        NSMutableArray* _levelIconLayers = [[NSMutableArray alloc] init];
        
        NSMutableArray* _selectedLevelIcons = [[NSMutableArray alloc] init];
        NSMutableArray* levelIcons = [[NSMutableArray alloc] init];
        //NSMutableArray* lockedLevelIcons = [[NSMutableArray alloc] init];
        
        //creating locked levels add an array of the locked levels all but the first 2
        double iconSize = size.height/6;

//        // TODO: comment back in if multiple level sets added
//        for (int k = 0; k < 1; ++k) {  // TODO - get rid of magic number (k is number of sets we want)
        
            CCLayer* levelSetLayer = [[CCLayer alloc] init];
            NSMutableArray *menuItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *iconSet = [[NSMutableArray alloc] init];
            [levelIcons addObject:iconSet];
            NSMutableArray *selectedIconSet = [[NSMutableArray alloc] init];
            [_selectedLevelIcons addObject:selectedIconSet];
        
            // TODO - change these level icons... I pretty blatantly stole them from
            // my other game!!
            for (int j = 0; j < 3; ++j) {
                for (int i = 0; i < _gameManager.numLevelIndices/3; ++i) {
                    CCSprite *levelIcon = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];   // TODO: make 0 "k" if loop added back
                    [iconSet addObject:levelIcon];
                    
//                    [lockedLevelIcons addObject:levelIcon];
//                    
//                    //locked changes now lock every level but 1 TO FIX!
//                    if ( !(i == 0 && j== 0))
//                    {
//                    levelIcon.userData = @"Locked";
//                    CCSprite* lock = [CCSprite spriteWithFile:@"lock.png"];
//                    [lock setPosition:ccp(levelIcon.contentSize.width/4, levelIcon.contentSize.height/4)];
//                    [levelIcon addChild:lock];
//                    }
                    
                    // Change label to "k-(4j+i+1)" format if we have multiple sets
                    CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"%d", 4*j+i+1] fontName:@"Marker Felt" fontSize:levelIcon.contentSize.width*0.4];
                    [label setColor:ccBLACK];
                    [label setPosition:ccp(levelIcon.contentSize.width/2, levelIcon.contentSize.height/2)];
                    [levelIcon addChild:label];
                    
                    CCSprite *levelIconSelected = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];   // TODO: make 0 "k" if loop added back
                    [selectedIconSet addObject:levelIconSelected];
                    levelIconSelected.scale = 1.2;
                    [levelIconSelected setPosition:ccp(-levelIconSelected.contentSize.width/10, -levelIconSelected.contentSize.height/10)];

                    // Change label to "k-(4j+i+1)" format if we have multiple sets
                    CCLabelTTF *labelSelected = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"%d", 4*j+i+1] fontName:@"Marker Felt" fontSize:levelIcon.contentSize.width*0.4];
                    [labelSelected setColor:ccBLACK];
                    [labelSelected setPosition:ccp(levelIconSelected.contentSize.width/2, levelIconSelected.contentSize.height/2)];
                    [levelIconSelected addChild:labelSelected];
                    
                    if([_gameManager isLevelLockedAtLevelSet:1 AndIndex:j*(_gameManager.numLevelIndices/3) + i + 1 ])
                        {
                            levelIcon.userData = (__bridge void*) @"Locked";
                            CCSprite* lock = [CCSprite spriteWithFile:@"lock.png"];
                            [lock setPosition:ccp(levelIcon.contentSize.width/4, levelIcon.contentSize.height/4)];
                            [levelIcon addChild:lock];
                        }
                    
                    if ([_gameManager isLevelCompletedAtLevelSet:1 AndIndex:j*(_gameManager.numLevelIndices/3) + i + 1]){
                        
                        int numStars = [_gameManager highScoreAtLevelSet:1 AndIndex:j*(_gameManager.numLevelIndices/3) + i + 1];
                        
                        [_gameManager registerCompletedLevelWithLevelSet:1 AndIndex:j*(_gameManager.numLevelIndices/3) + i + 1 AndStarCount:numStars];
                        
                        CGPoint starLocation = ccp(levelIcon.contentSize.width/4.5, levelIcon.contentSize.height/5);
                        
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
                    
                    
                    
                    // Check here if 2 of the levels have been completed
                    // if so remove two more from the locked levels array
                    // and unlock them
                    //if ([_gameManager isLevelCompletedAtLevelSet:1 AndIndex:j*(_gameManager.numLevelIndices/3) + i + 1]){
//                        CCSprite* levelUnlock1 = [lockedLevelIcons objectAtIndex:i+3];
//                        levelUnlock1.userData = @"Unlocked";
//                        
//                    }
                    

                    CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:levelIcon selectedSprite:levelIconSelected block:^(id sender) {
                        // TODO: change this line to load different sets
                        NSString* lockString = (NSString *)levelIcon.userData;
                        if (![lockString isEqualToString:@"Locked"])
                        {
                        [[CCDirector sharedDirector] pushScene:[LevelLayer sceneWithLevelSet:1 AndIndex:4*j+i+1]];  // TODO: make set "k" if loop added back
                        }else{
                            return;
                        }
                    }];
                    menuItem.scale = (iconSize * levelIcon.scale)/levelIcon.contentSize.width;
                    [menuItem setPosition:ccp(size.width*((i+1.0)/5.0-0.5), -size.height*((j+1.0)/4.0-0.5))];
                    [menuItems addObject:menuItem];
                }
            }
            
            CCMenu* menu2 = [CCMenu menuWithArray:menuItems];
            [menu2 setPosition:ccp( size.width/2, size.height/2)];
            [levelSetLayer addChild:menu2];
        
//            // TODO: comment back in if multiple level sets added
//            [_levelIconLayers addObject:levelSetLayer];
        
            [self addChild:levelSetLayer];
        
//        // TODO: comment back in if multiple level sets added
//        }  
    
//        // TODO: comment back in if multiple level sets added
//        CCScrollLayer* scroller = [CCScrollLayer nodeWithLayers:_levelIconLayers widthOffset:0];
//        [self addChild:scroller];
        
        
        // add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
    }

    return self;
}

@end
