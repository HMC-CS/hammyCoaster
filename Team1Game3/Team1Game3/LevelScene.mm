//
//  LevelScene.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "LevelScene.h"

#import "PhysicsSprite.h"

#import "PhysicsLayer.h"
#import "InventoryLayer.h"

@implementation LevelScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    CGSize size = [CCDirector sharedDirector].winSize;
    
	// 'layer' is an autorelease object.
	PhysicsLayer* physicsLayer = [PhysicsLayer node];
    physicsLayer.tag = 0;
    //    [physicsLayer setContentSize:CGSizeMake(size.width*0.75, size.height)];
    //    physicsLayer.position = ccp(size.width*0.25, 0);
    
    InventoryLayer* inventoryLayer = [InventoryLayer node];
    inventoryLayer.tag = 1;
    //    [inventoryLayer setContentSize:CGSizeMake(size.width*0.25, size.height)];
    //    inventoryLayer.position = ccp(0,0);
    
	
	// add layer as a child to scene (essentially pushes them to a stack)
    // inventoryLayer is on top
	[scene addChild: physicsLayer];
    [scene addChild: inventoryLayer];
    
	
	// return the scene
	return scene;
}

-(id) init
{
    if (self = [super init])
    {
        
    }
    
    return self;
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
