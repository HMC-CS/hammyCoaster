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
	
    CGSize size = [CCDirector sharedDirector].winSize;
    
//	// 'layer' is an autorelease object.
//	PhysicsLayer* physicsLayer = [PhysicsLayer node];
//    physicsLayer.tag = 0;
//    //    [physicsLayer setContentSize:CGSizeMake(size.width*0.75, size.height)];
//    //    physicsLayer.position = ccp(size.width*0.25, 0);
//    
//    InventoryLayer* inventoryLayer = [InventoryLayer node];
//    inventoryLayer.tag = 1;
//    //    [inventoryLayer setContentSize:CGSizeMake(size.width*0.25, size.height)];
//    //    inventoryLayer.position = ccp(0,0);
//    
//	
//	// add layer as a child to scene (essentially pushes them to a stack)
//    // inventoryLayer is on top
//	[scene addChild: physicsLayer];
//    [scene addChild: inventoryLayer];
    
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
        
        _inventoryLayer = [InventoryLayer node];
        _physicsLayer = [PhysicsLayer node];
        
        [_physicsLayer setTarget:self atAction:@selector(getInventorySelectedObject)]; //physics selector1
        [_physicsLayer setTarget:self atAction:@selector(gameWon)]; //physics selector2
        
        [_inventoryLayer setTarget:self atAction:@selector(playLevel)]; //inventory selector1
        [_inventoryLayer setTarget:self atAction:@selector(resetLevel)]; //inventory selector2
        
        [self addChild:_inventoryLayer];
        [self addChild:_physicsLayer];
		
		// create menu button
		
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void)registerWithTouchDispatcher
{
    // makes layer second priority for touches, also allows them to fall through it to the physics and inventory layers
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:NO];
}

-(NSString*)getInventorySelectedObject;
{
    return [_inventoryLayer getSelectedObject];
}

/* playLevel:
 * tries the level by putting the ball in it.
 */
-(void) playPhysicsLevel
{
    NSLog(@"Play Button pressed in LevelLayer");
}

/* gameWon:
 * displays popup withe congratulaitons and options after winning game
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

-(void) resetLevel
{
    PhysicsLayer* oldPhysicsLayer = _physicsLayer; // NEED TO SOMEHOW REMOVE MEMORY LEAK!
    [self removeChild:_physicsLayer cleanup:YES];
    
    _physicsLayer = [PhysicsLayer node];
    [_physicsLayer setTarget:self atAction:@selector(getInventorySelectedObject)]; //physics selector1
    [_physicsLayer setTarget:self atAction:@selector(gameWon)]; //physics selector2
    [self addChild:_physicsLayer];
    
}

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

@end
