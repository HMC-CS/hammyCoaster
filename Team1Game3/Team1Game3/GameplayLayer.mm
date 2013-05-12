//
//  GameplayLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/8/13.
//
//

#import "GameplayLayer.h"
#import "LevelSelectorLayer.h"
#import "LevelLayer.h"
#import "SoundManager.h"

@implementation GameplayLayer

@synthesize starCount = _starCount, playResetToggle = _playResetToggle;


-(id) initWithHighScore:(int) stars AndStartButtonLocation:(CGPoint) startButtonPoint
{
	if (self = [super init]) {
        
		self.isTouchEnabled = YES;
		
        // Same position as Level Layer
        [self setPosition:ccp(0,0)];
        
        _bestStars = stars;
        _startButtonLocation = startButtonPoint;
        
		// Create menu buttons
		[self createMenu];
        
        // Create user feedback labels
        [self createLabels];
        
        // Add sound buttons
        CCMenu* soundMenu = [[SoundManager sharedSoundManager] createSoundMenu];
        [self addChild:soundMenu z:1];
	}
	return self;
}


-(void) setTarget:(id) sender AtAction:(SEL)action
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


-(void) updateStarCount
{
    ++_starCount;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* createMenu
 * Creates menu with player "action" type buttons.
 */
-(void) createMenu
{
    
    CGSize size = [CCDirector sharedDirector].winSize;

    [CCMenuItemFont setFontSize:30];
    
    // Play and reset ball buttons, which are toggle-able.
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
    // Create toggle menu for play and reset ball buttons
    _startButtonLocation.x += (size.width/4);
    CCMenu* playResetMenu = [CCMenu menuWithItems: _playResetToggle, nil];
    [playResetMenu setPosition:_startButtonLocation];
    [self addChild: playResetMenu z:-1];
    
    
    // Reset Button: Gets rid of all non-default items in level
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Restart Level" block:^(id sender){
        // reset level; currently just redraw everything
        [self resetButtonPressed];
    }];
    // Menu for reset button (at top of inventory panel)
    CCMenu *gameMenu0 = [CCMenu menuWithItems: resetButton, nil];
    [gameMenu0 alignItemsVerticallyWithPadding:10];
    [gameMenu0 setPosition:ccp(size.width/8, size.height*15/20)];
    [self addChild: gameMenu0 z:-1];
    
    
    // Back Button: goes back to level selector menu
    CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Level Select" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
    }];
    // Menu for back button (at bottom of inventory panel)
    CCMenu *gameMenu1 = [CCMenu menuWithItems: backButton, nil];
    [gameMenu1 setPosition:ccp(size.width/8, 4*size.height/16)];
    [self addChild: gameMenu1 z:-1];
}



/* createLabels
 * Creates star/score display labels
 */
-(void) createLabels
{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    // Label for number of stars obtained
    _starCount = 0;
    _starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", _starCount] fontName:@"Marker Felt" fontSize:30];
    _starLabel.position = CGPointMake(size.width/8, 5*size.height/32);
    [self addChild:_starLabel];
    
    // Label for level high score
    _bestStarLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Best Stars: %d", _bestStars] fontName:@"Marker Felt" fontSize:30];
    _bestStarLabel.position = CGPointMake(size.width/8, 3*size.height/32);
    [self addChild:_bestStarLabel];
}


/* playResetButtonPressed
 * Performs a play or reset action based on the state of the play/reset toggle
 */
-(void) playResetButtonPressed
{
    if ([_playResetToggle selectedIndex] == 1) {
        [self playButtonPressed];
    } else {
        [self resetBallButtonPressed];
    }
}


/* playButtonPressed
 * Asks LevelLayer to start the level
 */
-(void) playButtonPressed
{
    [_target performSelector:_selector1];
}


/* resetBallPhysicsLevel
 * Asks LevelLayer to reset the ball in the level
 */
-(void) resetBallButtonPressed
{
    [_target performSelector:_selector2];
    [self resetStarCount];
}


/* resetButtonPressed
 * Asks LevelLayer to restart the level, and resets GameplayLayer level data
 */
-(void) resetButtonPressed
{
    [_target performSelector:_selector3];
    [self resetStarCount];
}


/* resetStarCount:
 * Resets the star count to 0 if the level is reset
 */
-(void) resetStarCount
{
    _starCount = 0;
    [_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}


@end
