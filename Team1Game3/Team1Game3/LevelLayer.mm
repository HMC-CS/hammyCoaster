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

@implementation LevelLayer

+(CCScene *) sceneWithLevelSet:(int) set AndIndex:(int) index
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    // size unused because levelLayer doesn't currently display anything
    // CGSize size = [CCDirector sharedDirector].winSize;
    
    LevelLayer* levelLayer = [[LevelLayer alloc] initWithLevelSet:set AndIndex:index];
    
    [scene addChild:levelLayer];
	
	// return the scene
	return scene;
}

-(id) initWithLevelSet:(int) set AndIndex:(int) index
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
        [self createInventoryLayer];
        [self createPhysicsLayerWithLevelSet:(int)set AndIndex:index];
        _physicsLayer->_editMode = true;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        /*
         * Game Menu:
         * The menu with the "action" type buttons, as opposed to inventory items.
         * -------------------------------------------------------------------------
         */
        
        // Play Button: drops ball
        CCMenuItemLabel *playButton = [CCMenuItemFont itemWithString:@"Get the Ball Rolling!" block:^(id sender){
            [self playPhysicsLevel];
            // stick a ball on the screen at starting position;
        }];
        
        // Reset Button: Gets rid of all non-default items in level
        // for now, just selects nothing so you can click freely
        CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
            // reset level; currently just redraw everything
            [self resetLevel];
        }];
        
        // Back Button: goes back to level selector menu
        CCMenuItemLabel *backButton = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            // TODO: deal with physics layer dealloc stuff so we can have THIS be the line called rather than the following one
            //[[CCDirector sharedDirector] popScene];  // best
            //[[CCDirector sharedDirector] replaceScene:[LevelSelectorLayer scene]]; //meh
            [[CCDirector sharedDirector] pushScene:[LevelSelectorLayer scene]]; // worst
        }];
        
        CCMenu *gameMenu = [CCMenu menuWithItems: playButton, resetButton, nil];
        [gameMenu alignItemsHorizontallyWithPadding:25];
        [gameMenu setPosition:ccp(size.width/8, size.height*3/4)];
        [self addChild: gameMenu z:-1];
        
        CCMenu *gameMenu2 = [CCMenu menuWithItems: backButton, nil];
        [gameMenu2 setPosition:ccp(size.width/8, size.height*1/4)];
        [self addChild: gameMenu2 z:-1];
		
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
    
//    // TODO: comment back in if needed
//    [_inventoryLayer setTarget:self atAction:@selector(playPhysicsLevel)]; //inventory selector1
//    [_inventoryLayer setTarget:self atAction:@selector(resetLevel)]; //inventory selector2
    [self addChild:_inventoryLayer];
}

/* createPhysicsLayer:
 * creates the PhysicsLayer and tells it where to send messages for its selectors
 */
-(void) createPhysicsLayerWithLevelSet:(int) set AndIndex:(int) index
{
    _physicsLayer = [[PhysicsLayer alloc] initWithLevelSet:set AndIndex:index];
    [_physicsLayer setTarget:self atAction:@selector(getInventorySelectedObject)]; //physics selector1
    [_physicsLayer setTarget:self atAction:@selector(gameWon)]; //physics selector2
    _physicsLayer -> _editMode = YES;
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
//    _physicsLayer->_editMode = false;
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
//    
//    _physicsLayer->_editMode = true;
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
