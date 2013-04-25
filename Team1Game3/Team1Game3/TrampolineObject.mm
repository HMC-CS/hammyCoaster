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

    // --- Inner (bouncy) shape ---
    b2Vec2 vertices1[4];
    int num = 4;
    vertices1[0].Set(105.1f / PTM_RATIO, -4.0f / PTM_RATIO);
    vertices1[1].Set(-94.3f / PTM_RATIO, -2.7f / PTM_RATIO);
    vertices1[2].Set(-40.6f / PTM_RATIO, -17.4f / PTM_RATIO);
    vertices1[3].Set(47.9f / PTM_RATIO, -18.1f / PTM_RATIO);
    
    b2PolygonShape trampolineShape;
    trampolineShape.Set(vertices1, num);
    
    _fixtureDef.shape = &trampolineShape; // Set the line shape
    _fixtureDef.density = 0.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.95f; // Set the restitution
    
    // Add the shape to the body
    trampoline_Body->CreateFixture(&_fixtureDef);
    
    // --- Outer (sensor) shape--for easy dragging ---
    
    b2Vec2 vertices2[8];
    int num2 = 8;
    vertices2[0].Set(166.2f / PTM_RATIO, -3.1f / PTM_RATIO);
    vertices2[1].Set(80.2f / PTM_RATIO, 23.4f / PTM_RATIO);
    vertices2[2].Set(-3.7f / PTM_RATIO, 26.3f / PTM_RATIO);
    vertices2[3].Set(-102.4f / PTM_RATIO, 22.3f / PTM_RATIO);
    vertices2[4].Set(-162.0f / PTM_RATIO, -1.2f / PTM_RATIO);
    vertices2[5].Set(-96.0f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices2[6].Set(1.8f / PTM_RATIO, -33.1f / PTM_RATIO);
    vertices2[7].Set(100.6f / PTM_RATIO, -27.2f / PTM_RATIO);
    
    b2PolygonShape trampolineShape2;
    trampolineShape2.Set(vertices2, num2);
    
    b2Filter trampolineFilter;
    trampolineFilter.maskBits = 0;
    b2FixtureDef _fixtureDef2;
    _fixtureDef2.shape = &trampolineShape2; // Set the line shape
    _fixtureDef2.filter = trampolineFilter;
    
    // Add the shape to the body
    trampoline_Body->CreateFixture(&_fixtureDef2);
    
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
