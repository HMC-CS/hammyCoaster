//
//  CreditsLayer.m
//  Team1Game3
//
//  Created by Carson Ramsden on 7/9/13.
//
//

#import "CreditsLayer.h"


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
        
        // Label declaring "YOU WIN!"
        [CCMenuItemFont setFontSize:22];
        CCLabelTTF* _winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"YOU WIN!"] fontName:@"Marker Felt" fontSize:34];
        _winLabel.position = CGPointMake(size.width*3/4, size.height*2/3);
        [self addChild:_winLabel];
        
        CCMenuItemLabel *backMenu = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] pushScene: [OverallWinLayer scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:backMenu, nil];
        [menu alignItemsHorizontallyWithPadding:20.0f];
        [menu setPosition:ccp( size.width*3/4, size.height*5/9)];
        [self addChild: menu z:-1];
    }
    return self;
}


@end
