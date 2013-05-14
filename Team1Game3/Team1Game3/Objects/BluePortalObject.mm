//
//  BluePortalObject.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//
//

#import "BluePortalObject.h"

@implementation BluePortalObject

- (std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location
{
    // Create body
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *bluePortalBody = _world->CreateBody(&bodyDef);
    
    // Create fixture
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(-26.1f / PTM_RATIO, 27.0f / PTM_RATIO);
    vertices[1].Set(-25.9f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[2].Set(26.2f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[3].Set(26.2f / PTM_RATIO, 27.1f / PTM_RATIO);

    b2PolygonShape bluePortalShape;
    bluePortalShape.Set(vertices, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &bluePortalShape; // Set the line shape
    fixtureDef.density = 100.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.1f; // Set the restitution
    
    // Add the fixture to the body
    bluePortalBody->CreateFixture(&fixtureDef);
    
    // Set user data to self and add bodies to list of bodies
    bluePortalBody->SetUserData(self);
    _bodies.push_back(bluePortalBody);
    
    return _bodies;
}

@end
