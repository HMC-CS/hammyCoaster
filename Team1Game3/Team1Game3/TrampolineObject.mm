//
//  SeesawObject.m
//  Team1Game3
//
//  Created by user on 4/4/13.
//
//

#import "TrampolineObject.h"

@implementation TrampolineObject

- (std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location
{    
    // Create body
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *trampoline_Body = _world->CreateBody(&bodyDef);

    
    // --- Inner (bouncy) shape --- //
    
    // Create the vertices and polygon
    b2Vec2 vertices1[4];
    int num = 4;
    vertices1[0].Set(105.1f / PTM_RATIO, -4.0f / PTM_RATIO);
    vertices1[1].Set(-94.3f / PTM_RATIO, -2.7f / PTM_RATIO);
    vertices1[2].Set(-40.6f / PTM_RATIO, -17.4f / PTM_RATIO);
    vertices1[3].Set(47.9f / PTM_RATIO, -18.1f / PTM_RATIO);
    
    b2PolygonShape trampolineShape;
    trampolineShape.Set(vertices1, num);
     
    // Create the fixture
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &trampolineShape; // Set the line shape
    fixtureDef.density = 0.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.95f; // Set the restitution
    
    // Add the shape to the body
    trampoline_Body->CreateFixture(&fixtureDef);
    
    
    // --- Outer (sensor) shape--for easy dragging --- //
    
    // Create the vertices and polygon
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
    
    // Prevents outer shape from colliding with things
    b2Filter trampolineFilter;
    trampolineFilter.maskBits = 0;
    
    // Create the fixture
    b2FixtureDef fixtureDef2;
    fixtureDef2.shape = &trampolineShape2; // Set the line shape
    fixtureDef2.filter = trampolineFilter;
    
    // Add the shape to the body
    trampoline_Body->CreateFixture(&fixtureDef2);
     
     
    // Set user data to self and add body to list of bodies
    trampoline_Body->SetUserData(self);
    _bodies.push_back(trampoline_Body);
    
    return _bodies;
}

@end
