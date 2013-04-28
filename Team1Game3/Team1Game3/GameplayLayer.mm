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
#import "SoundManager.h"

@implementation GameplayLayer

-(id) initWithHighScore:(int) stars StartButtonLocation:(CGPoint) startButtonPoint
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		
        [self setPosition:ccp(0,0)];
        
        _bestStars = stars;
        _startButtonLocation = startButtonPoint;
        
		// create menu buttons
		[self createMenu];
        
        // create user feedback labels
        [self createLabels];
        
        // add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
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
    
    [CCMenuItemFont setFontSize:30];
    
    CCMenuItem* playButton = [CCMenuItemFont itemWithString:@"Start!" block:^(id sender) {
        [self playButtonPressed];
        NSLog(@"Play button pressed");
    }];
    CCMenuItem* resetBallButton = [CCMenuItemFont itemWithString:@"Reset\nBall" block:^(id sender) {
        [self resetBallButtonPressed];
        NSLog(@"Reset ball button pressed");
    }];
    
    _playResetToggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects: playButton, resetBallButton, nil] block:^(id sender) {
        [self playResetButtonPressed];
    }];
    
    _startButtonLocation.x += (size.width/4);

    CCMenu* playResetMenu = [CCMenu menuWithItems: _playResetToggle, nil];
    [playResetMenu setPosition:_startButtonLocation];
    [self addChild: playResetMenu z:-1];
    
    // Reset Button: Gets rid of all non-default items in level
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Restart Level" block:^(id sender){
        // reset level; currently just redraw everything
        [self resetButtonPressed];
    }];
    
    // Back Button: goes back to level selector menu
    CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
    }];

// TODO: put play button on top of start portal.  But for now, hopefully this layout is okay.
//    // Buttons at top of inventory panel
//    CCMenu *gameMenu0 = [CCMenu menuWithItems: playButton, nil];
//    [gameMenu0 alignItemsHorizontallyWithPadding:25];
//    [gameMenu0 setPosition:ccp(size.width/8, size.height*17/20)];
//    [self addChild: gameMenu0 z:-1];
    
    CCMenu *gameMenu0 = [CCMenu menuWithItems: resetButton, nil];
    [gameMenu0 alignItemsVerticallyWithPadding:10];
    [gameMenu0 setPosition:ccp(size.width/8, size.height*15/20)];
    [self addChild: gameMenu0 z:-1];

    // Buttons at bottom of inventory panel
    CCMenu *gameMenu1 = [CCMenu menuWithItems: backButton, nil];
    [gameMenu1 setPosition:ccp(size.width/8, 4*size.height/16)];
    [self addChild: gameMenu1 z:-1];
}

-(void) createLabels
{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    // Number of Stars label
    _starCount = 0;
    _starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", _starCount] fontName:@"Marker Felt" fontSize:30];
    _starLabel.position = CGPointMake(size.width/8, 5*size.height/32);
    [self addChild:_starLabel];
    
    _bestStarLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Best Stars: %d", _bestStars] fontName:@"Marker Felt" fontSize:30];
    _bestStarLabel.position = CGPointMake(size.width/8, 3*size.height/32);
    [self addChild:_bestStarLabel];
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    NSAssert1(sender, @"Sender %@ for GameplayLayer setTarget is null.", sender);
    NSAssert(action, @"Selector for GameplayLayer setTarget is null.");
    
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
/*
-(void)getPlayButtonLocation
{
    //CGPoint returnValue = (CGPoint)[_target performSelector:_selector1]
    NSLog(@"GamePlay Layer ball starting point %@", [_target performSelector:_selector1]);
    // (CGPoint)[_target performSelector:_selector1];
}*/


-(void) playResetButtonPressed
{
    if ([_playResetToggle selectedIndex] == 1) {
        [self playButtonPressed];
    } else {
        [self resetBallButtonPressed];
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
 * from: GameplayLayer
 * to: PhysicsLayer
 * Resets the level, currently by re-creating the _physicsLayer.
 */

-(void) resetBallButtonPressed
{
    [_target performSelector:_selector2];
    [self resetStarCount];
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
