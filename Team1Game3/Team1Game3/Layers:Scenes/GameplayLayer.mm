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
        
        _starArray = [[NSMutableArray alloc] init];
        
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
    } else if (!_selector2){
        _selector2 = action;
    } else{
        _selector3 = action;
    }
}


-(void) updateStarCount
{
    ++_starCount;
    CGPoint starLocation = CGPointMake(self.contentSize.width/1.9, 9*self.contentSize.height/10);
    for (int i = 1; i <= 3; ++i) {
        if (_starCount < i) {
            _stars = [CCSprite spriteWithFile:@"StarObjectOutline.png"];
            [_stars setPosition:starLocation];
            [self addChild:_stars];
            //[_starArray addObject:_stars];
        } else {
            _stars = [CCSprite spriteWithFile:@"StarObject.png"];
            [_stars setPosition:starLocation];
            [self addChild:_stars];
            [_starArray addObject:_stars];
        }
        starLocation.x += _stars.boundingBox.size.width+10;
    }
    //[_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* createMenu
 * Creates menu with player "action" type buttons.
 */
-(void) createMenu
{
    
    CGSize size = [CCDirector sharedDirector].winSize;

    [CCMenuItemFont setFontSize:20];
    
    // Play and reset ball buttons, which are toggle-able.
    CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"playButton.png" selectedImage:@"playButton.png"];

    CCMenuItemImage *resetBallButton = [CCMenuItemImage itemWithNormalImage:@"stopButton.png" selectedImage: @"stopButton.png" block:^(id sender) {
        [self resetBallButtonPressed];
    }];

    _playResetToggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects: playButton, resetBallButton, nil] block:^(id sender) {
        [self playResetButtonPressed];
    }];
    // Create toggle menu for play and reset ball buttons
    _startButtonLocation.x += (size.width/7.5-5);
    _startButtonLocation.y +=(size.height/5-92);
    CCMenu* playResetMenu = [CCMenu menuWithItems: _playResetToggle, nil];
    [playResetMenu setPosition:_startButtonLocation];
    [self addChild: playResetMenu z:-1];
    
    
    // Reset Button: Gets rid of all non-default items in level
    CCMenuItemLabel *resetButton = [CCMenuItemImage itemWithNormalImage:@"restart.png" selectedImage:@"restart.png" block:^(id sender){
        // reset level; currently just redraw everything
        [self resetButtonPressed];
    }];
    // Menu for reset button (at top of inventory panel)
    CCMenu *gameMenu0 = [CCMenu menuWithItems: resetButton, nil];
    [gameMenu0 alignItemsVerticallyWithPadding:10];
    [gameMenu0 setPosition:ccp(size.width*(.065), size.height*18/20)];
    [self addChild: gameMenu0 z:-1];
    
    
    // Back Button: goes back to level selector menu
    CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Menu" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]];
    }];
    // Menu for back button (at bottom of inventory panel)
    CCMenu *gameMenu1 = [CCMenu menuWithItems: backButton, nil];
    [gameMenu1 setPosition:ccp(size.width*(.065), 2*size.height/16)];
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
    CGPoint starLocation = CGPointMake(self.contentSize.width/1.9, 9*self.contentSize.height/10);
    for (int i = 1; i <= 3; ++i) {
        if (_starCount < i) {
            _stars = [CCSprite spriteWithFile:@"StarObjectOutline.png"];
            [_stars setPosition:starLocation];
            [self addChild:_stars];
            //[_starArray addObject:_stars];
        } else {
            _stars = [CCSprite spriteWithFile:@"StarObject.png"];
            [_stars setPosition:starLocation];
            [self addChild:_stars];
            //[_starArray addObject:_stars];
        }
        starLocation.x += _stars.boundingBox.size.width +10;
    }
    
    //_starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", _starCount] fontName:@"Marker Felt" fontSize:20];
    //_starLabel.position = CGPointMake(size.width*(.075), 4*size.height/32);

    //[self addChild:_starLabel];
    
    // Label for level high score
    _bestStarLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Best Stars: %d", _bestStars] fontName:@"Marker Felt" fontSize:20];
    _bestStarLabel.position = CGPointMake(size.width*(.075), 2*size.height/32);
    //[self addChild:_bestStarLabel];
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


/* resetStarCount:
 * Resets the star count to 0 if the level is reset
 */
-(void) resetStarCount
{
    _starCount = 0;
   for(CCSprite* star in _starArray)
   {
        NSLog(@"remove stars");
        [self removeChild:star cleanup:YES];
    }
    //[self createLabels];
 
    
    //[_starLabel setString:[NSString stringWithFormat:@"Stars: %d", _starCount]];
}


/* ///////////////////////// Target-Selector Functions ///////////////////////// */

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




@end
