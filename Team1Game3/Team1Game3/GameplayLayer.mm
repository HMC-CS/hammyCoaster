//
//  GameplayLayer.m
//  Team1Game3
//
//  Created by jarthur on 4/8/13.
//
//

#import "GameplayLayer.h"
#import "LevelSelectorLayer.h"
#import "LevelLayer.h"

@implementation GameplayLayer

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		
        [self setPosition:ccp(0,0)];
        
		// create menu button
		[self createMenu];
        
        _starCount = 0;
        _starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", _starCount] fontName:@"Marker Felt" fontSize:24];
        _starLabel.position = CGPointMake(600.0, 600.0);
        [self addChild:_starLabel];
	}
	return self;
}

-(void) createMenu
{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    // Play Button: drops ball
    CCMenuItemLabel *playButton = [CCMenuItemFont itemWithString:@"Get the Ball Rolling!" block:^(id sender){
        [self playButtonPressed];
        // stick a ball on the screen at starting position;
    }];
    
    // Reset Button: Gets rid of all non-default items in level
    // for now, just selects nothing so you can click freely
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
        // reset level; currently just redraw everything
        [self resetButtonPressed];
    }];
    
    // Back Button: goes back to level selector menu
    CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
    }];
    
    CCMenu *gameMenu = [CCMenu menuWithItems: playButton, resetButton, nil];
    [gameMenu alignItemsHorizontallyWithPadding:25];
    [gameMenu setPosition:ccp(size.width/8, size.height*3/4)];
    [self addChild: gameMenu z:-1];
    
    CCMenu *gameMenu2 = [CCMenu menuWithItems: backButton, nil];
    [gameMenu2 setPosition:ccp(size.width/8, size.height*1/4)];
    [self addChild: gameMenu2 z:-1];
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else {
        _selector2 = action;
    }
}

-(void) playButtonPressed
{
    [_target performSelector:_selector1];
}

-(void) resetButtonPressed
{
    [_target performSelector:_selector2];
}

-(void) updateStarCount
{
    ++_starCount;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}

-(void) resetStarCount
{
    _starCount = 0;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}

@end
