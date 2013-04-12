//
//  OverallWinLayer.m
//  Team1Game3
//
//  Created by jarthur on 4/11/13.
//
//

#import "OverallWinLayer.h"

@implementation OverallWinLayer

+(CCScene *) sceneWithLevel: (int)level AndStarCount: (int) stars
{
    CCScene *scene = [CCScene node];	// 'scene' is an autorelease object.
    
    OverallWinLayer* overallWinLayer = [[OverallWinLayer alloc] init];
    
    [scene addChild:overallWinLayer];
	
	// return the scene
	return scene;
}

-(id) initWithLevel:(int)level AndStarCount:(int)stars
{
    if (self = [super init]) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        /////////////
        
        // Default font size will be 22 points.
        [CCMenuItemFont setFontSize:22];
        
        CCLabelTTF* _winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"YOU WIN!"] fontName:@"Marker Felt" fontSize:24];
        _winLabel.position = CGPointMake(600.0, 600.0);
        [self addChild:_winLabel];
    }
    
    return self;
}


@end
