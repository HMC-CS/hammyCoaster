//
//  SeesawObject.m
//  Team1Game3
//
//  Created by user on 4/4/13.
//
//

#import "SeesawObject.h"

@implementation SeesawObject

- (b2Body *)createBody:(CGPoint)location {
    
    // Not yet implemented
    
//    _bodyDef.type = b2_dynamicBody;
//    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    b2Body* seesawBody = _world->CreateBody(&_bodyDef);
//    
//    b2FixtureDef circleFixtureDef;
//    
//    b2CircleShape circleShape;
//    
//    circleShape.m_radius = 26.0/PTM_RATIO;
//    
//    circleFixtureDef.shape = &circleShape;
//    circleFixtureDef.density = 100.0f;
//    circleFixtureDef.friction = 10.0f;
//    circleFixtureDef.restitution = 0.8f;
//    seesawBody->CreateFixture(&circleFixtureDef);
//    
//    b2FixtureDef teeterFixtureDef;
//    b2PolygonShape teeterShape;
//    teeterShape.SetAsBox(50.0/PTM_RATIO,50.0/PTM_RATIO);
//    
//    
//    
//    
//    
//    b2RevoluteJointDef jointdef;
    

}

// For reference
//- (b2Body *)createBody:(CGPoint)location {
//    
//    _bodyDef.type = b2_staticBody;
//    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    b2Body *ramp_Body = _world->CreateBody(&_bodyDef);
//    
//    b2Vec2 vertices[4];
//    int num = 4;
//    vertices[0].Set(-87.5f / PTM_RATIO, 120.5f / PTM_RATIO);
//    vertices[1].Set(-120.5f / PTM_RATIO, 87.5f / PTM_RATIO);
//    vertices[2].Set(87.5f / PTM_RATIO, -120.5f / PTM_RATIO);
//    vertices[3].Set(120.5f / PTM_RATIO, -87.5f / PTM_RATIO);
//    
//    b2PolygonShape rampShape;
//    rampShape.Set(vertices, num);
//    
//    
//    _fixtureDef.shape = &rampShape; // Set the line shape
//    _fixtureDef.density = 0.0f; // Set the density
//    _fixtureDef.friction = 0.5f; // Set the friction
//    _fixtureDef.restitution = 0.5f; // Set the restitution
//    
//    // Add the shape to the body
//    ramp_Body->CreateFixture(&_fixtureDef);
//    ramp_Body->SetUserData(self);
//    
//    return ramp_Body;
//}


@end
