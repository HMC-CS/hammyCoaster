//
//  SeesawObject.m
//  Team1Game3
//
//  Created by user on 4/4/13.
//
//

#import "TrampolineObject.h"

@implementation TrampolineObject

- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *trampoline_Body = _world->CreateBody(&_bodyDef);
    
    b2Vec2 vertices[4];
    int num = 4;
    vertices[0].Set(105.1f / PTM_RATIO, -4.0f / PTM_RATIO);
    vertices[1].Set(-94.3f / PTM_RATIO, -2.7f / PTM_RATIO);
    vertices[2].Set(-40.6f / PTM_RATIO, -17.4f / PTM_RATIO);
    vertices[3].Set(47.9f / PTM_RATIO, -18.1f / PTM_RATIO);
    
    b2PolygonShape trampolineShape;
    trampolineShape.Set(vertices, num);
    
    
    _fixtureDef.shape = &trampolineShape; // Set the line shape
    _fixtureDef.density = 0.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.95f; // Set the restitution
    
    // Add the shape to the body
    trampoline_Body->CreateFixture(&_fixtureDef);
    trampoline_Body->SetUserData(self);
    
    _bodies.push_back(trampoline_Body);
    
    return _bodies;
    

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
