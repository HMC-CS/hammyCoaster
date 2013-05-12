//
//  RampObject.m
//  Team1Game3
//
//  Created by Carson Ramsden on 3/9/13.
//
//

#import "RampObject.h"

@implementation RampObject
- (std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *ramp_Body = _world->CreateBody(&bodyDef);
    
    b2Vec2 vertices[7];
    int num = 7;
    vertices[0].Set(-81.4f / PTM_RATIO, 113.4f / PTM_RATIO);
    vertices[1].Set(-94.5f / PTM_RATIO, 113.4f / PTM_RATIO);
    vertices[2].Set(-59.6f / PTM_RATIO, 9.5f / PTM_RATIO);
    vertices[3].Set(10.0f / PTM_RATIO, -53.9f / PTM_RATIO);
    vertices[4].Set(87.1f / PTM_RATIO, -93.1f / PTM_RATIO);
    vertices[5].Set(115.0f / PTM_RATIO, -91.6f / PTM_RATIO);
    vertices[6].Set(114.0f / PTM_RATIO, -77.8f / PTM_RATIO);
    
    b2PolygonShape rampShape;
    rampShape.Set(vertices, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &rampShape; // Set the line shape
    fixtureDef.density = 0.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.5f; // Set the restitution
    
    // Add the shape to the body
    ramp_Body->CreateFixture(&fixtureDef);
    ramp_Body->SetUserData(self);
  
    _bodies.push_back(ramp_Body);
    
    return _bodies;
}



@end
