//
//  WorldManager.h
//  Team1Game3
//
//  Created by jarthur on 5/9/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#ifndef WORLD_MANAGER_INCLUDED
#define WORLD_MANAGER_INCLUDED 1

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "ContactListener.h"
#import "ObjectFactory.h"

#import "GLES-Render.h"

@interface WorldManager : NSObject {
    
    GLESDebugDraw* m_debugDraw;         // DEBUG_DRAW: debug draw.
                                        // Remove before publishing.
    
    b2World* _world;                    // The physics world
    
    std::vector<b2Body*> _bodiesToDestroy;
    
}

-(id) initWithWorld: (b2World*) world;

-(void) setBoundariesForLayer: (CCLayer*) layer;

-(void) destroyBody: (b2Body*) body;

-(void) update;

@end

#endif  // WORLD_MANAGER_INCLUDED