//
//  LevelSelectorLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/30/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectorLayer.h"

#import "LevelLayer.h"


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
        
        /////////////
        
        CCMenuItem *back = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: back, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/15 )];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        ////////////////
        
//        // TODO: comment back in if multiple level sets added
//        NSMutableArray* _levelIconLayers = [[NSMutableArray alloc] init];
        
        NSMutableArray* _selectedLevelIcons = [[NSMutableArray alloc] init];
        NSMutableArray* levelIcons = [[NSMutableArray alloc] init];
        
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
                for (int i = 0; i < 4; ++i) {
                    CCSprite *levelIcon = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];   // TODO: make 0 "k" if loop added back
                    [iconSet addObject:levelIcon];
                    
                    CCSprite *levelIconSelected = [CCSprite spriteWithFile:[NSString stringWithFormat: @"LevelIcon%i.png", i]];   // TODO: make 0 "k" if loop added back
                    [selectedIconSet addObject:levelIconSelected];
                    levelIconSelected.scale = 1.2;
                    [levelIconSelected setPosition:ccp(-levelIconSelected.contentSize.width/10, -levelIconSelected.contentSize.height/10)];
                    
                    CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:levelIcon selectedSprite:levelIconSelected block:^(id sender) {
                        // TODO: change this line to load different levels
                        [[CCDirector sharedDirector] pushScene:[LevelLayer scene]];
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
    }

    return self;
}

@end
