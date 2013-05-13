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
        background = [CCSprite spriteWithFile:@"levelbackground.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background];
    
        // Create the other layers
        [self createInventoryLayer];
        [self createPhysicsLayer];
        [self createGameplayLayer];
        
        // Display the puzzle level at the top of the screen
        CCLabelTTF* _levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d-%d", _levelSet, _levelIndex] fontName:@"Marker Felt" fontSize:30];
        _levelLabel.position = CGPointMake(2.9*size.width/5, 5*size.height/6);
        [self addChild:_levelLabel];
        
	}
	return self;
}

/* ////////////////////////////// Private Functions ////////////////////////////// */

/* createInventoryLayer:
 * Creates the InventoryLayer
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
    return [_physicsLayer getBallStartingPoint];
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
