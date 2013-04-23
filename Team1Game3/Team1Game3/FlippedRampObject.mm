//
//  FlippedRampObject.m
//  Team1Game3
//
//  Created by Michelle Chesley on 4/15/13.
//
//

#import "FlippedRampObject.h"

@implementation FlippedRampObject
- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *ramp_Body = _world->CreateBody(&_bodyDef);
    
    b2Vec2 vertices[8];
    int num = 8;
    vertices[0].Set(83.2f / PTM_RATIO, 115.0f / PTM_RATIO);
    vertices[1].Set(-114.8f / PTM_RATIO, -80.3f / PTM_RATIO);
    vertices[2].Set(-111.4f / PTM_RATIO, -94.3f / PTM_RATIO);
    vertices[3].Set(-86.0f / PTM_RATIO, -94.2f / PTM_RATIO);
    vertices[4].Set(-9.3f / PTM_RATIO, -51.3f / PTM_RATIO);
    vertices[5].Set(60.7f / PTM_RATIO, 13.4f / PTM_RATIO);
    vertices[6].Set(95.4f / PTM_RATIO, 92.9f / PTM_RATIO);
    vertices[7].Set(93.6f / PTM_RATIO, 115.2f / PTM_RATIO);
    
    b2PolygonShape rampShape;
    rampShape.Set(vertices, num);
    
    
    _fixtureDef.shape = &rampShape; // Set the line shape
    _fixtureDef.density = 0.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.5f; // Set the restitution
    
    // Add the shape to the body
    ramp_Body->CreateFixture(&_fixtureDef);
    ramp_Body->SetUserData(self);
    
    _bodies.push_back(ramp_Body);
    
    return _bodies;
}



@end
