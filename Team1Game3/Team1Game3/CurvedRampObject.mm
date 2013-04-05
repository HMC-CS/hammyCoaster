//
//  CurvedRampObject.m
//  Team1Game3
//
//  Created by jarthur on 4/5/13.
//
//

#import "CurvedRampObject.h"

@implementation CurvedRampObject
- (b2Body *)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *cRamp_Body = _world->CreateBody(&_bodyDef);
    
    
    //making 45-degree ramp-shaped shape to add
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(-87.5f / PTM_RATIO, 120.5f / PTM_RATIO);
    vertices[1].Set(-120.5f / PTM_RATIO, 87.5f / PTM_RATIO);
    vertices[2].Set(87.5f / PTM_RATIO, -120.5f / PTM_RATIO);
    vertices[3].Set(120.5f / PTM_RATIO, -87.5f / PTM_RATIO);
    
    b2PolygonShape rampShape;
    rampShape.Set(vertices, num);
    
    _fixtureDef.shape = &rampShape; // Set the line shape
    _fixtureDef.density = 0.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.5f; // Set the restitution
    
    //making square shape to add
    num = 4;
    vertices[0].Set(-26.1f / PTM_RATIO, 27.0f / PTM_RATIO);
    vertices[1].Set(-25.9f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[2].Set(26.2f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[3].Set(26.2f / PTM_RATIO, 27.1f / PTM_RATIO);
    
    
    b2PolygonShape bluePortalShape;
    bluePortalShape.Set(vertices, num);
    
    _fixtureDef.shape = &bluePortalShape; // Set the line shape
    _fixtureDef.density = 100.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.1f; // Set the restitution
    

      // Add ramp shape to the body
    cRamp_Body->CreateFixture(&_fixtureDef);

    // Add the square shape to the body
    cRamp_Body->CreateFixture(&_fixtureDef);

    
    
    cRamp_Body->SetUserData(self);
    
    return cRamp_Body;
}

@end
