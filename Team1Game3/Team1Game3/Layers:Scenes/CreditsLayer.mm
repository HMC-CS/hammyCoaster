//
//  CreditsLayer.m
//  Team1Game3
//
//  Created by Carson Ramsden on 7/9/13.
//
//

#import "CreditsLayer.h"
#import "MainMenuLayer.h"
#import "OverallWinLayer.h"
#import "SoundManager.h"

@implementation CreditsLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
   CreditsLayer* creditsLayer = [[CreditsLayer alloc] init];
    
    // Add the layer to the scene
    [scene addChild:creditsLayer];
	
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
        creditText = [CCSprite spriteWithFile:@"credits.png"];
        creditText.position = ccp(size.width/2, size.height/2);
        [self addChild: creditText z:-1];
        
        
        CCMenuItemLabel *backMenu = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [MainMenuLayer scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:backMenu, nil];
        [menu alignItemsHorizontallyWithPadding:50.0f];
        [menu setPosition:ccp( size.width*1/10, size.height*10/11)];
        [self addChild: menu z:-1];
    }
    return self;
}


@end
