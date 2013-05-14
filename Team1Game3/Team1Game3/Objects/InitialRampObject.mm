//
//  InitialRampObject.m
//  Team1Game3
//
//  Created by Carson Ramsden on 3/9/13.
//
//

#import "InitialRampObject.h"

@implementation InitialRampObject

- (std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location
{
    // Create the body
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *ramp_Body = _world->CreateBody(&bodyDef);
    
    // Create the fixture
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(-97.0f / PTM_RATIO, 14.2f / PTM_RATIO);
    vertices[1].Set(34.4f / PTM_RATIO, -68.3f / PTM_RATIO);
    vertices[2].Set(54.4f / PTM_RATIO, -42.7f / PTM_RATIO);
    vertices[3].Set(-96.4f / PTM_RATIO, 57.1f / PTM_RATIO);

    
    b2PolygonShape rampShape;
    rampShape.Set(vertices, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &rampShape; // Set the line shape
    fixtureDef.density = 0.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.0f; // Set the restitution
    
    // Add the shape to the body
    ramp_Body->CreateFixture(&fixtureDef);
    
    // Set user data to self and add body to list of bodies
    NSLog(@"object type is %@", self.type);
    ramp_Body->SetUserData((__bridge void*)self);
    _bodies.push_back(ramp_Body);
    
    return _bodies;
}

@end
