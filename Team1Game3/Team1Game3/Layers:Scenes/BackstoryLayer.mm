//
//  BackstoryLayer.m
//  Team1Game3
//
//  Created by Carson Ramsden on 7/12/13.
//
//

#import "BackstoryLayer.h"
#import "MainMenuLayer.h"
#import "OverallWinLayer.h"
#import "SoundManager.h"
#import "LevelSelectorLayer.h"



@implementation BackstoryLayer


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    BackstoryLayer* backstoryLayer = [[BackstoryLayer alloc] init];
    
    // Add the layer to the scene
    [scene addChild:backstoryLayer];
	
	return scene;
}


-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        // put picture as background
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"LevelSelectorLayer.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:-2];
        
        CCSprite *creditText;
        creditText = [CCSprite spriteWithFile:@"backstory.png"];
        creditText.position = ccp(size.width/2, size.height/1.9);
        [self addChild: creditText z:-1];
        
        CCMenuItemLabel *nextMenu = [CCMenuItemFont itemWithString:@"Play Game" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [LevelSelectorLayer scene]];
        }];
    
        CCMenu *menu = [CCMenu menuWithItems:nextMenu, nil];
        [menu alignItemsHorizontallyWithPadding:50.0f];
        [menu setPosition:ccp( size.width*1/2, size.height*1/12)];
        [self addChild: menu z:-1];
    }
    return self;
}


@end
