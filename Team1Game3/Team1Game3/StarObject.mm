//
//  StarObject.m
//  Team1Game3
//
//  Created by William O'Brien on 3/20/13.
//
//

#import "StarObject.h"

@implementation StarObject

//stars have the same shape/size as a blue portal for now

- (b2Body *)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *star_Body = _world->CreateBody(&_bodyDef);
    
    b2Vec2 vertices[4];
    //row 1, col 1
    int num = 4;
    vertices[0].Set(-26.1f / PTM_RATIO, 27.0f / PTM_RATIO);
    vertices[1].Set(-25.9f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[2].Set(26.2f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[3].Set(26.2f / PTM_RATIO, 27.1f / PTM_RATIO);
    
    
    b2PolygonShape starShape;
    starShape.Set(vertices, num);
    
    //b2FixtureDef _fixtureDef;
    _fixtureDef.shape = &starShape; // Set the line shape
    _fixtureDef.density = 100.0f; // Set the density
    _fixtureDef.friction = 0.5f; // Set the friction
    _fixtureDef.restitution = 0.1f; // Set the restitution
    
    // Add the shape to the body
    star_Body->CreateFixture(&_fixtureDef);
    star_Body->SetUserData(self);
    //b2Fixture->SetUserData("bluePortal");[/code]
    //b2CircleShape circle;
    //circle.m_radius = 26.0/PTM_RATIO;
    
    //_fixtureDef.shape = &circle;
    //_fixtureDef.density = 1.0f;
    //_fixtureDef.friction = 0.4f;
    //_fixtureDef.restitution = 0.3f;
    
    //body->CreateFixture(&_fixtureDef);
    return star_Body;
}

@end
