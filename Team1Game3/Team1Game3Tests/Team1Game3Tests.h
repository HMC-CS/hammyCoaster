//
//  Team1Game3Tests.h
//  Team1Game3Tests
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/24/13.
//
//

// TODO - organize files into folders so imports become easier!

#import <SenTestingKit/SenTestingKit.h>

#import "AbstractGameObject.h"
#import "BallObject.h"
#import "RampObject.h"
#import "BluePortalObject.h"

#import "LevelLayer.h"
#import "InventoryLayer.h"
#import "PhysicsLayer.h"
#import "MainMenuLayer.h"

//#import "ContactListener.h"
//#import "ObjectFactory.h"

#import "cocos2d.h"
#import "Box2D.h"

@interface Team1Game3UnitTests : SenTestCase {
    
    BallObject* ball;
    RampObject* ramp;
    BluePortalObject* bluePortal;
    AbstractGameObject* abstractBall;
    
    LevelLayer* levelLayer;
    InventoryLayer* inventoryLayer;
    PhysicsLayer* physicsLayer;
    MainMenuLayer* mainMenuLayer;
    
}

- (void) checkNotNil;

@end
