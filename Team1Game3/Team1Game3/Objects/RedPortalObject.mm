//
//  RedPortalObject.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//
//

#import "RedPortalObject.h"

#include <vector>

@implementation RedPortalObject

-(std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location
{
    // Create body
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *redPortal_Body = _world->CreateBody(&bodyDef);
    
    
    // Create fixture
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(-26.1f / PTM_RATIO, 27.0f / PTM_RATIO);
    vertices[1].Set(-25.9f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[2].Set(26.2f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[3].Set(26.2f / PTM_RATIO, 27.1f / PTM_RATIO);
    
    b2PolygonShape redPortalShape;
    redPortalShape.Set(vertices, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &redPortalShape; // Set the line shape
    fixtureDef.density = 100.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.1f; // Set the restitution
    fixtureDef.isSensor = TRUE; // Make the star a sensor (no interaction with other bodies)
    
    // Add the shape to the body
    redPortal_Body->CreateFixture(&fixtureDef);
    
    // Set user data to self and add body to list of bodies
    redPortal_Body->SetUserData(self);
    _bodies.push_back(redPortal_Body);
    
    return _bodies;
}

@end
