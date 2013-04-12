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
        
		// create menu buttons
		[self createMenu];
        
        // create user feedback labels
        [self createLabels];
	}
	return self;
}

-(void) createMenu
{
    
    CGSize size = [CCDirector sharedDirector].winSize;

    /*
     * Game Menu:
     * The menu with the "action" type buttons, as opposed to inventory items.
     * -------------------------------------------------------------------------
     */
    
    // Play Button: drops ball
    CCMenuItemLabel *playButton = [CCMenuItemFont itemWithString:@"Get the Ball Rolling!" block:^(id sender){
        [self playButtonPressed];
        // stick a ball on the screen at starting position;
    }];
    
    // Reset Ball Button: Gets rid of ball, puts stars back, sets editMode to true.
    CCMenuItemLabel *resetBallButton = [CCMenuItemFont itemWithString:@"Reset Ball" block:^(id sender){
        [self resetBallButtonPressed];
    }];
    
    // Reset Button: Gets rid of all non-default items in level
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
        // reset level; currently just redraw everything
        [self resetButtonPressed];
    }];
    
    // Back Button: goes back to level selector menu
    CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
    }];
    
    // Buttons at top of inventory panel
    CCMenu *gameMenu0 = [CCMenu menuWithItems: playButton, nil];
    [gameMenu0 alignItemsHorizontallyWithPadding:25];
    [gameMenu0 setPosition:ccp(size.width/8, size.height*4/5)];
    [self addChild: gameMenu0 z:-1];
    
    CCMenu *gameMenu1 = [CCMenu menuWithItems: resetBallButton, resetButton, nil];
    [gameMenu1 alignItemsHorizontallyWithPadding:25];
    [gameMenu1 setPosition:ccp(size.width/8, size.height*7/10)];
    [self addChild: gameMenu1 z:-1];

    // Buttons at bottom of inventory panel
    CCMenu *gameMenu2 = [CCMenu menuWithItems: backButton, nil];
    [gameMenu2 setPosition:ccp(size.width/8, 5*size.height/16)];
    [self addChild: gameMenu2 z:-1];
}

-(void) createLabels
{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    // Number of Stars label
    _starCount = 0;
    _starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", _starCount] fontName:@"Marker Felt" fontSize:24];
    _starLabel.position = CGPointMake(size.width/8, 3*size.height/16);
    [self addChild:_starLabel];
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    NSAssert1(sender, @"Sender %@ for GameplayLayer setTarget is null.", sender);
    NSAssert1(action, @"Selector %@ for GameplayLayer setTarget is null.", action);
    
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else if (!_selector2){
        _selector2 = action;
    }
    else {
        _selector3 = action;
    }
}

/* playButtonPressed:
 * asks LevelLayer to start the level
 */
-(void) playButtonPressed
{
    [_target performSelector:_selector1];
    // NSLog(@"PLAY in gameplay layer");
}

/* resetBallPhysicsLevel:
 * from: InventoryLayer
 * to: PhysicsLayer
 * Resets the level, currently by re-creating the _physicsLayer.
 */

-(void) resetBallButtonPressed
{
    [_target performSelector:_selector2];
}

/* resetButtonPressed:
 * asks LevelLayer to restart the level, and resets GameplayLayer level data
 */
-(void) resetButtonPressed
{
    [_target performSelector:_selector3];
    [self resetStarCount];
}

/* resetStarCount:
 * resets the star count to 0 if the level is reset
 */
-(void) resetStarCount
{
    _starCount = 0;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}

// public functions, documented in GameplayLayer.h

-(void) updateStarCount
{
    ++_starCount;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}

@end
