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

@implementation LevelLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    // size unused because levelLayer doesn't currently display anything
    // CGSize size = [CCDirector sharedDirector].winSize;
    
    LevelLayer* levelLayer = [LevelLayer node];
    
    [scene addChild:levelLayer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
        [self createInventoryLayer];
        [self createPhysicsLayer];
        _physicsLayer->_editMode = true;
		
	}
	return self;
}

//-----CHILD LAYER INTERACTION FUNCTIONS-----//

/* createInventoryLayer:
 * creates the InventoryLayer and tells it where to send messages for its selectors
 */
-(void) createInventoryLayer
{
    _inventoryLayer = [InventoryLayer node];
    [_inventoryLayer setTarget:self atAction:@selector(playPhysicsLevel)]; //inventory selector1
    [_inventoryLayer setTarget:self atAction:@selector(resetLevel)]; //inventory selector2
    [_inventoryLayer setTarget:self atAction:@selector(addObject)]; //invenctory selector3
    [self addChild:_inventoryLayer];
}

/* createPhysicsLayer:
 * creates the PhysicsLayer and tells it where to send messages for its selectors
 */
-(void) createPhysicsLayer
{
    _physicsLayer = [PhysicsLayer node];
    [_physicsLayer setTarget:self atAction:@selector(getInventorySelectedObject)]; //physics selector1
    [_physicsLayer setTarget:self atAction:@selector(gameWon)]; //physics selector2
    [self addChild:_physicsLayer];
}

/* playPhysicsLevel:
 * from: InventoryLayer
 * to: PhysicsLayer
 * tries the level by putting the ball in it.
 */
-(void) playPhysicsLevel
{
    NSLog(@"Play Button pressed in LevelLayer");
    
    [_physicsLayer playLevel];
    _physicsLayer->_editMode = false;
}

/* resetLevel:
 * from: InventoryLayer
 * to: PhysicsLayer
 * Resets the level, currently by re-creating the _physicsLayer.
 */

-(void) resetLevel
{
    //PhysicsLayer* oldPhysicsLayer = _physicsLayer; // NEED TO SOMEHOW REMOVE MEMORY LEAK!
    [self removeChild:_physicsLayer cleanup:NO];
    
    [self createPhysicsLayer];
    
    _physicsLayer->_editMode = true;
}

/* addObject:
 * from: InventoryLayer
 * to: PhysicsLayer
 * Adds an object of the current type to the physics layer.
 * Used so we can drag it onto the visible section of the physics layer
 */
-(void) addObject
{
    [_physicsLayer addObjectOfType:[_inventoryLayer getSelectedObject]];
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

/* gameWon:
 * from: PhysicsLayer
 * to: LevelLayer
 * displays popup with congratulaitons and options after winning game
 */
-(void) gameWon
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS, YOU'VE WON!"
                                                    message:@"Play Again?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes!"
                                          otherButtonTitles:@"No, thanks.", nil];
    alert.tag=1;
    [alert show];
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
            [[CCDirector sharedDirector] pushScene:[LevelLayer scene]];
        }
        else {
            [[CCDirector sharedDirector] pushScene:[MainMenuLayer scene]];
        }
    }
}

//-(BOOL)ccTouchBegan:(UITouch* )touch withEvent:(UIEvent *)event
//{
//    CGPoint location = [self convertTouchToNodeSpace: touch];
//    if (CGRectContainsPoint(InventoryLayer.boundingBox, location))
//    {
//        NSLog(@"touched inventory layer");
//        return YES;
//    }
//    else if (CGRectContainsPoint(PhysicsLayer.boundingBox, location))
//    {
//        NSLog(@"touched physics layer");
//        return YES;
//    }
//    return NO;
//}
//

/* dealloc:
 * deallocates everything in LevelLayer
 */
-(void) dealloc
{
	[super dealloc];
}

@end
