//
//  LevelLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "LevelLayer.h"

#import "PhysicsSprite.h"

#import "PhysicsLayer.h"
#import "InventoryLayer.h"
#import "MainMenuLayer.h"
#import "LevelSelectorLayer.h"
#import "WinLayer.h"

@implementation LevelLayer


+(CCScene *) sceneWithLevelSet:(int) set AndIndex:(int) index
{
	CCScene *scene = [CCScene node];
    LevelLayer* levelLayer = [[LevelLayer alloc] initWithLevelSet:set AndIndex:index];
    
    // Add layer to scene
    [scene addChild:levelLayer];

	return scene;
}


-(id) initWithLevelSet:(int) set AndIndex:(int) index
{
	if (self = [super init]) {
        
        // setting hint_displayed as false in the beginning
        _hint_displayed = false;
    
        
        // The AppController's game manager
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
        
        NSAssert1(set > 0 && set <= _gameManager.numLevelSets, @"Invalid set index %d given in LevelLayer.", set);
        NSAssert1(index > 0 && index <= _gameManager.numLevelIndices, @"Invalid level index %d given in LevelLayer.", index);
		
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
        _levelSet = set;
        _levelIndex = index;
        
        _levelGenerator = [[LevelGenerator alloc] init];
        
        // Create background image
        CCSprite *background;
        if (set == 1)
        {
        background = [CCSprite spriteWithFile:@"newBackground.png"];
        } else if (set ==2 )
        {
            background = [CCSprite spriteWithFile:@"background2.png"];
        }
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background];
    
        // Create the other layers
        [self createInventoryLayer];
        [self createPhysicsLayer];
        [self createGameplayLayer];
        [self createHintMenu];
        
        // Display the puzzle level at the top of the screen
        CCLabelTTF* _levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d-%d", _levelSet, _levelIndex] fontName:@"Marker Felt" fontSize:30];
        _levelLabel.position = CGPointMake(2.9*size.width/5, 5*size.height/6);
        [self addChild:_levelLabel];
        
        //Cat paws animation
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pawsAnim-hd.plist"];
        CCSpriteBatchNode* spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"pawsAnim-hd.png"];
        [self addChild:spriteSheet];
        NSMutableArray* catAnimFrames = [NSMutableArray array];
        for (int i =1; i <= 2; i++)
        {
            [catAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"paws%d.png",i]]];
        }
        CCAnimation* catAnim = [CCAnimation animationWithSpriteFrames:catAnimFrames delay:0.7f];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        

        for (int i= 0; i <= 4; i++)
        {
             self.catPaws = [CCSprite spriteWithSpriteFrameName:@"paws1.png"];
            self.catPaws.position = CGPointMake(winSize.width*(.2)+self.catPaws.boundingBox.size.width*i,self.catPaws.boundingBox.size.height/3);
            self.catAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:catAnim]];
            [self.catPaws runAction:self.catAction];
            [self.catArray addObject:self.catPaws];
            
            
            [spriteSheet addChild:self.catPaws];
        }

        
        
	}
	return self;
}



-(void) createHintMenu
{
    
        
    // This loads the hints.plist file into a dictionary (root_dict)
    NSString* fileName = [NSString stringWithFormat:@"hints.plist"];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSDictionary* root_dict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    // This loads the correct levelSet_# array into an array (levelSet)
    NSString* levelSet_number = [[NSString alloc] initWithFormat:@"levelSet%i", _levelSet];
    NSArray* levelSet = [[NSArray alloc] initWithArray:root_dict[levelSet_number]];
    
    // This loads the value of the string at index = _levelIndex-1
    NSString* level_1_pic = [[NSString alloc] initWithFormat:levelSet[_levelIndex-1]];
    
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMenuItemImage *hintButtonOn = [CCMenuItemImage itemWithNormalImage:@"question.png" selectedImage:@"question.png"];
    
    CCMenuItemImage *hintButtonOff = [CCMenuItemImage itemWithNormalImage:@"question.png" selectedImage: @"question.png" block:^(id sender) {
        [self hintOffPressed];
    }];
    if (((_levelSet == 1 && (_levelIndex == 1 || _levelIndex == 4 || _levelIndex == 7)) || (_levelSet == 2 && (_levelIndex ==1 || _levelIndex ==7))) && _hint_displayed == false)
    {
        [self hintOnPressed];
    }
    
    _hintToggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects: hintButtonOn, hintButtonOff, nil] block:^(id sender) {
       
        [self hintOnOffPressed];
    }];
    
    
    
    /*
    CCMenuItemImage* hintButton = [CCMenuItemImage itemWithNormalImage:@"lightbulb.png" selectedImage:@"lightbulb.png" block:^(id sender) {
        if (_hint_displayed == false) 
        {
            _hint_displayed = true;
            _draggingPopup = [CCSprite spriteWithFile:level_1_pic];
            
            [_draggingPopup setPosition:CGPointMake(size.width/1.7, size.height/2)];
            NSMutableArray* popUpArray = [[NSMutableArray alloc] init];
            CCAnimation* spriteAnimation = [CCAnimation animationWithSpriteFrames:popUpArray];
            id popupAnimateAction = [CCAnimate actionWithAnimation:spriteAnimation];
            id callSpriteAnim = [CCCallFunc actionWithTarget:self selector:@selector(removePopUp)];
            id delay  = [CCDelayTime actionWithDuration:3];
            id animateSequence = [CCSequence actions: popupAnimateAction, delay, callSpriteAnim, nil];
            [self runAction:animateSequence];
             
            [self addChild:_draggingPopup z:4];
        }
    }];
*/
    CCMenu* hintGameMenu = [CCMenu menuWithItems: _hintToggle, nil];
    [hintGameMenu setPosition:ccp(17*size.width/20, 19*size.height/20)];
    [self addChild: hintGameMenu z:4];
    
    
}


-(void) hintOnPressed
{
    
    NSString* fileName = [NSString stringWithFormat:@"hints.plist"];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSDictionary* root_dict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    // This loads the correct levelSet_# array into an array (levelSet)
    NSString* levelSet_number = [[NSString alloc] initWithFormat:@"levelSet%i", _levelSet];
    NSArray* levelSet = [[NSArray alloc] initWithArray:root_dict[levelSet_number]];
    
    // This loads the value of the string at index = _levelIndex-1
    NSString* level_1_pic = [[NSString alloc] initWithFormat:levelSet[_levelIndex-1]];
    
    
    CGSize size = [[CCDirector sharedDirector] winSize];
     _draggingPopup = [CCSprite spriteWithFile:level_1_pic];
     [_draggingPopup setPosition:CGPointMake(size.width/1.7, size.height/2)];
    _hint_displayed = true;
    [self addChild:_draggingPopup];
}
-(void) hintOffPressed
{
    [self removeChild:_draggingPopup cleanup:YES];
    _hint_displayed = false;
}

-(void) hintOnOffPressed
{
    if ([_hintToggle selectedIndex] == 1 && _hint_displayed == false) {
        [self hintOnPressed];
    } else {
        [self hintOffPressed];
    }
}

/* ////////////////////////////// Private Functions ////////////////////////////// */

/* createInventoryLayer:.json * Creates the InventoryLayer
 */
-(void) createInventoryLayer
{
    // Get the inventory items and countsfrom the level generator
    NSArray* initialItems = [_levelGenerator generateInventoryInSet:_levelSet WithIndex:_levelIndex];
    
    // Create the inventorylayer
    _inventoryLayer = [[InventoryLayer alloc] initWithItems:initialItems];
    [self addChild:_inventoryLayer];
}

/* createPhysicsLayer:
 * Creates the PhysicsLayer and tells it where to send messages for its selectors
 */
-(void) createPhysicsLayer
{
    // Get the objects already on the level screen from the level generator
    NSArray* initialObjects = [_levelGenerator generateObjectsInSet:_levelSet WithIndex:_levelIndex];
    
    // Create the physics layer and send it selectors, then add it to the level layer
    _physicsLayer = [[PhysicsLayer alloc] initWithObjects:initialObjects];
    [_physicsLayer setTarget:self AtAction:@selector(getInventorySelectedObject)]; // physics selector1
    [_physicsLayer setTarget:self AtAction:@selector(gameWon)]; // physics selector2
    [_physicsLayer setTarget:self AtAction:@selector(updateStarCount)]; // physics selector 3
    [_physicsLayer setTarget:self AtAction:@selector(objectDeletedOfType:)]; // physics selector 4
    [_physicsLayer setTarget:self AtAction:@selector(togglePlayResetButton)]; // physics selector 5
    [_physicsLayer setTarget:self AtAction:@selector(resetStarCount)];
    [self addChild:_physicsLayer];
}


/* createGameplayLayer:
 * Creates the GameplayLayer and tells it where to send messages for its selectors
 */
-(void) createGameplayLayer
{
    // Create the gameplay layer and send it selectors, then add it to the level layer
    _gameplayLayer = [[GameplayLayer alloc] initWithHighScore:[_gameManager highScoreAtLevelSet:_levelSet AndIndex:_levelIndex] AndStartButtonLocation:[self getBallStartPoint]];
    [_gameplayLayer setTarget:self AtAction:@selector(playPhysicsLayer)];   // gameplay selector 1
    [_gameplayLayer setTarget:self AtAction:@selector(resetBallPhysicsLayer)];  // gameplay selector 2
    [_gameplayLayer setTarget:self AtAction:@selector(resetPhysicsLayer)];  // gameplay selector 3
    [self addChild:_gameplayLayer];
}


/* getBallStartPoint
 * Called by: LevelLayer to construct GameplayLayer
 * Response from: PhysicsLayer
 * Returns starting location of ball
 */
-(CGPoint) getBallStartPoint
{
    return _physicsLayer.ballStartingPoint;
}


/* /////////// Private Functions Ctd. - Selectors Passed to Layers /////////// */


/* getInventorySelectedObject
 * Called by: PhysicsLayer (selector 1)
 * Response from: InventoryLayer
 * Gets the currently selected object from the InventoryLayer.
 * Used so that physics layer can tell what's selected.
 */
-(NSString*)getInventorySelectedObject
{
    return [_inventoryLayer getSelectedObject];
}


/* gameWon:
 * Called by: PhysicsLayer (selector 2)
 * Response from: LevelLayer
 * Displays scene with congratulations and options after winning game.
 * Also updates game data.
 */
-(void) gameWon
{
    // Win scene
    [[CCDirector sharedDirector] pushScene:[WinLayer sceneWithLevelSet:_levelSet AndIndex:_levelIndex AndStarCount:_gameplayLayer.starCount]];
    
    // Update data in game manager
    [_gameManager registerCompletedLevelWithLevelSet:_levelSet AndIndex:_levelIndex AndStarCount:_gameplayLayer.starCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
}


/* updateStarCount
 * Called by: PhysicsLayer (selector 3)
 * Response from: GameplayLayer
 * Increments the star count in GameplayLayer when a star is hit
 */
-(void) updateStarCount
{
    [_gameplayLayer updateStarCount];
}


/* objectDeletedOfType:
 * Called by: PhysicsLayer (selector 4)
 * Response from: InventoryLayer
 * Updates object count information when object of a given type is deleted
 */
-(void) objectDeletedOfType:(NSString*) type;
{
    [_inventoryLayer increaseInventoryForType:type];
}


/* togglePlayResetButton
 * Called by: PhysicsLayer (selector 5)
 * Response from: GameplayLayer
 * Toggles the button on the red portal
 */
-(void) togglePlayResetButton
{
     [_gameplayLayer.playResetToggle setSelectedIndex: 1 - [_gameplayLayer.playResetToggle selectedIndex]];
//    if (_physicsLayer.safe_to_play == true) {
//        [_gameplayLayer.playResetToggle setSelectedIndex: 1 - [_gameplayLayer.playResetToggle selectedIndex]];
//    }
//    
//    else {
//        return;
//    }
}

// selector 6
-(void) resetStarCount
{
    [_gameplayLayer resetStarCount];
}

/* playPhysicsLayer
 * Called by: GameplayLayer (selector 1)
 * Response from: PhysicsLayer
 * tries the level by putting the ball in it.
 */
-(void) playPhysicsLayer
{
    [_physicsLayer playLevel];

}


/* resetBallPhysicsLayer
 * Called by: GameplayLayer (selector 2)
 * Response from: PhysicsLayer
 * Resets the ball and stars in the physics layer
 */
-(void) resetBallPhysicsLayer
{
    [_physicsLayer resetBall];
}


/* resetPhysicsLayer
 * Called by: GameplayLayer (selector 3)
 * Response from: LevelLayer
 * Resets the level, currently by re-creating all child layers.
 */

-(void) resetPhysicsLayer
{
    [self removeChild:_inventoryLayer cleanup:YES];
    [self createInventoryLayer];
    
    [self removeChild:_physicsLayer cleanup:YES];
    [self createPhysicsLayer];
    
    [self removeChild:_gameplayLayer cleanup:YES];
    [self createGameplayLayer];
}




/* ////////////// Private Functions Ctd. - Touch Functions ////////////// */

/* registerWithTouchDispacher:
 * Initializes touches for LevelLayer. Makes layer second
 * priority for touches, also allows them to fall through it
 * to the physics and inventory layers
 */
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:NO];
}


@end
