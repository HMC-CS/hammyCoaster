//
//  WorldManager.h
//  Team1Game3
//
//  Created by jarthur on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "ContactListener.h"
#import "ObjectFactory.h"

#import "GLES-Render.h"

@interface WorldManager : NSObject {
    
    GLESDebugDraw* m_debugDraw;         // debug draw
    
    b2World* _world;
    
    ContactListener* _contactListener;
    ObjectFactory* _objectFactory;
    CGSize _parentSize;
    
    std::vector<b2Body*> _bodiesToDestroy;
    
}

-(id) initWithWorld: (b2World*) world;
-(void) applyMagnets;
-(void) springSeesaw;
-(void) initPhysics;

-(void) setObjectFactory:(ObjectFactory *) objectFactory;

-(void) destroyBody: (b2Body*) body;

-(void) update;

@end
