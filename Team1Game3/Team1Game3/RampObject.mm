//
//  RampObject.m
//  Team1Game3
//
//  Created by Carson Ramsden on 3/9/13.
//
//

#import "RampObject.h"

@implementation RampObject
- (b2Body *)createBody:(CGPoint)location {
    
    //b2BodyDef rampBodyDef;
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *ramp_Body = _world->CreateBody(&_bodyDef);
    
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(-87.5f / PTM_RATIO, 120.5f / PTM_RATIO);
    vertices[1].Set(-120.5f / PTM_RATIO, 87.5f / PTM_RATIO);
    vertices[2].Set(87.5f / PTM_RATIO, -120.5f / PTM_RATIO);
    vertices[3].Set(120.5f / PTM_RATIO, -87.5f / PTM_RATIO);
    
    b2PolygonShape rampShape;
    rampShape.Set(vertices, num);
    
    //b2FixtureDef _fixtureDef;
    _fixtureDef.shape = &rampShape; // Set the line shape
    _fixtureDef.density = 0.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.5f; // Set the restitution
    
    // Add the shape to the body
    ramp_Body->CreateFixture(&_fixtureDef);
    //b2Fixture->SetUserData("Ramp");[/code]
    //b2CircleShape circle;
    //circle.m_radius = 26.0/PTM_RATIO;
    
    //_fixtureDef.shape = &circle;
    //_fixtureDef.density = 1.0f;
    //_fixtureDef.friction = 0.4f;
    //_fixtureDef.restitution = 0.3f;
    
    //body->CreateFixture(&_fixtureDef);
    return ramp_Body;
}


@end
