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
    
    // Play Button: drops ball
    CCMenuItemLabel *playButton;
    
    // Reset Ball Button: Gets rid of ball, puts stars back, sets editMode to true.
    CCMenuItemLabel *resetBallButton;
    
    playButton = [CCMenuItemFont itemWithString:@"Start!" block:^(id sender){
        [self playButtonPressed];
        [self switchButtons];
        // stick a ball on the screen at starting position;
    }];
    playButton.tag = 42;
    playButton.userData = @"playButton";
    
    resetBallButton = [CCMenuItemFont itemWithString:@"Reset Ball" block:^(id sender){
        [self resetBallButtonPressed];
        [self switchButtons];
    }];
    resetBallButton.tag = 42;
    resetBallButton.userData = @"resetBall";
    [resetBallButton setIsEnabled:NO];
    [resetBallButton setVisible:NO];
    //[resetBallButton setOpacity:[resetBallButton isEnabled]*100];

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

    CCLOG(@"play button location x: %f y: %f", _startButtonLocation.x, _startButtonLocation.y);
    _startButtonLocation.x += (size.width/4);
    
    CCMenu *gameMenu2 = [CCMenu menuWithItems: playButton, nil];
    [gameMenu2 setPosition:_startButtonLocation];
     gameMenu2.userData = @"playMenu";
    [self addChild: gameMenu2 z:-1];

    CCMenu *gameMenu3 = [CCMenu menuWithItems: resetBallButton, nil];
    [gameMenu3 setPosition:_startButtonLocation];
    [self addChild: gameMenu3 z:-1];
    gameMenu3.userData = @"resetBallMenu";
}

-(void)switchButtons
{
    NSLog(@"switch!");
    for (CCNode* menu in [self children])
    {
        NSLog(@" found a child!");
        NSLog(@"user data: %@", [menu userData]);
        NSString* menuData = (NSString*)[menu userData];
        if (([menuData isEqualToString:@"playMenu"] || [menuData isEqualToString:@"resetBallMenu"])/*&& [child isKindOfClass: NSClassFromString(@"CCMenuItem*")]*/)
        {
            CCMenuItem* child = (CCMenuItem*)[(CCMenu*)menu getChildByTag:42];
            [child setIsEnabled: ![child isEnabled]];
            [child setVisible:[child isEnabled]];
            //[child setOpacity:[child isEnabled]*100];
            //NSLog(@"%@ is enabled? %d", childData, [child isEnabled]);

        }
    }
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
