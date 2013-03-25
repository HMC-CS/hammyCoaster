//
//  PhysicsLayer.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "CCLayer.h"

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ObjectFactory.h"
#import "ContactListener.h"

@interface PhysicsLayer : CCLayer {

    b2World* world;					// strong ref
    GLESDebugDraw* m_debugDraw;		// strong ref
    ObjectFactory* _objectFactory;
    ContactListener* _contactListener;
    
    //should we name these better things? I don't think they're conventions....
    id _target;
    SEL _selector1;
    SEL _selector2;
    
    CGPoint ballStartingPoint;
    
    float xOffset;
    float yOffset;
    b2Body* currentMoveableBody;
}

// playLevel:
// Places a BallObject at ballStartingPoint
// activation: the play button has been pressed(in inventoryLayer)
-(void) playLevel;

-(void) setTarget:(id) sender atAction:(SEL)action;

@end
