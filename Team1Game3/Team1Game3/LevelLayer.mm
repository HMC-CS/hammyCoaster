//
//  LevelLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
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
    
    // Note: bounds checking on set and index done in init.
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    LevelLayer* levelLayer = [[LevelLayer alloc] initWithLevelSet:set AndIndex:index];
    
    [scene addChild:levelLayer];
	
	// return the scene
	return scene;
}

-(id) initWithLevelSet:(int) set AndIndex:(int) index
{
	if( (self=[super init])) {
        
        
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
        
        NSAssert1(set > 0 && set <= _gameManager.numLevelSets, @"Invalid set index %d given in LevelLayer.", set);
        NSAssert1(index > 0 && index <= _gameManager.numLevelIndices, @"Invalid level index %d given in LevelLayer.", index);
		
		// enable events
        
        self.isTouchEnabled = YES;
        
        _levelSet = set;
        _levelIndex = index;
        
        _levelGenerator = [[LevelGenerator alloc] init];
    
        [self createInventoryLayer];
        [self createPhysicsLayer];
        [self createGameplayLayer];
        
	}
	return self;
}

//-----CHILD LAYER INTERACTION FUNCTIONS-----//

/* createInventoryLayer:
 * creates the InventoryLayer and tells it where to send messages for its selectors
 */
-(void) createInventoryLayer
{
    NSArray* initialItems = [_levelGenerator generateInventoryInSet:_levelSet WithIndex:_levelIndex];
    
    _inventoryLayer = [[InventoryLayer alloc] initWithItems:initialItems];
    
    [self addChild:_inventoryLayer];
}

/* createPhysicsLayer:
 * creates the PhysicsLayer and tells it where to send messages for its selectors
 */
-(void) createPhysicsLayer
{
    NSArray* initialObjects = [_levelGenerator generateObjectsInSet:_levelSet WithIndex:_levelIndex];
    
    _physicsLayer = [[PhysicsLayer alloc] initWithObjects:initialObjects];
    [_physicsLayer setTarget:self atAction:@selector(getInventorySelectedObject)]; //physics selector1
    [_physicsLayer setTarget:self atAction:@selector(gameWon)]; //physics selector2
    [_physicsLayer setTarget:self atAction:@selector(updateStarCount)]; // physics selector 3
    [_physicsLayer setTarget:self atAction:@selector(checkIfInventoryIsDelete)]; //physics selector 4
    [_physicsLayer setTarget:self atAction:@selector(objectDeletedOfType:)]; //physics selector 5
    [self addChild:_physicsLayer];
}

/* createGameplayLayer:
 * creates the GameplayLayer and tells it where to send messages for its selectors
 */
-(void) createGameplayLayer
{
    _gameplayLayer = [[GameplayLayer alloc] init];
    [_gameplayLayer setTarget:self atAction:@selector(playPhysicsLayer)];
    [_gameplayLayer setTarget:self atAction:@selector(resetBallPhysicsLayer)];
    [_gameplayLayer setTarget:self atAction:@selector(resetPhysicsLayer)];
    [self addChild:_gameplayLayer];
}

/* playPhysicsLevel:
 * from: InventoryLayer
 * to: PhysicsLayer
 * tries the level by putting the ball in it.
 */
-(void) playPhysicsLayer
{
    // NSLog(@"Play Button pressed in LevelLayer with edit mode %d", _physicsLayer->_editMode);
    
    [_physicsLayer playLevel];
//    _physicsLayer->_editMode = false;
}

/* resetBallPhysicsLayer:
 * from: InventoryLayer
 * to: PhysicsLayer
 * Resets the level, currently by re-creating the _physicsLayer.
 */

-(void) resetBallPhysicsLayer
{
    //reset ball and stars
    _physicsLayer->_editMode = true;
}

/* resetPhysicsLayer:
 * from: InventoryLayer
 * to: PhysicsLayer
 * Resets the level, currently by re-creating the _physicsLayer.
 */

-(void) resetPhysicsLayer
{
    [self removeChild:_physicsLayer cleanup:YES];
    [self createPhysicsLayer];
    
    //[_inventoryLayer resetInventory];
    
    [self removeChild:_inventoryLayer cleanup:YES];
    [self createInventoryLayer];
}

/* getInventorySelectedObject:
 * from: PhysicsLayer
 * to: InventoryLayer
 * Gets the currently selected object from the InventoryLayer.
 * Used so that physics layer can tell what's selected.
 */
-(NSString*)getInventorySelectedObject;
{
    return [_inventoryLayer getSelectedObject];
}
-(bool) checkIfInventoryIsDelete;
{
    return [_inventoryLayer isDeleteSelected];
}

-(void) objectDeletedOfType:(NSString*) type;
{
    [_inventoryLayer increaseInventoryForType:type];
}
/* gameWon:
 * from: PhysicsLayer
 * to: LevelLayer
 * displays popup with congratulations and options after winning game
 */
-(void) gameWon
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS, YOU'VE WON!"
//                                                    message:@"Play Again?"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Yes!"
//                                          otherButtonTitles:@"No, thanks.", nil];
//    alert.tag=1;
//    [alert show];
    
    [[CCDirector sharedDirector] pushScene:[WinLayer sceneWithLevel:_levelIndex AndStarCount:_gameplayLayer.starCount]];
    
    [_gameManager registerCompletedLevelWithLevelSet:_levelSet AndIndex:_levelIndex];
}

/* updateStarCount:
 * from: PhysicsLayer
 * to: GameplayLayer
 * increments the star cont in GameplayLayer when a star is hit
 */
-(void) updateStarCount
{
    [_gameplayLayer updateStarCount];
}

//-----OTHER FUNCTIONS-----//

/* registerWithTouchDispacher:
 * Initializes touches for LevelLayer. Makes layer second
 * priority for touches, also allows them to fall through it
 * to the physics and inventory layers
 */
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:NO];
}

/* alertView: clickedButtonAtIndex:
 * Currently unused function to allow for selecting
 * difficulty of next level.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //if the user was sure he wanted a new game, this asks the user how difficult
    //he wants his new game to be.  It then loads a game of the selected difficulty.
    if (alertView.tag==1){
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [[CCDirector sharedDirector] pushScene:[LevelLayer sceneWithLevelSet:_levelSet AndIndex:_levelIndex]];
        }
        else {
            [[CCDirector sharedDirector] pushScene:[MainMenuLayer scene]];
        }
    }
}

/* dealloc:
 * deallocates everything in LevelLayer
 */
-(void) dealloc
{
	[super dealloc];
}

@end
