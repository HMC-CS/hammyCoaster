//
//  BluePortalObject.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//
//

#import "BluePortalObject.h"

@implementation BluePortalObject

- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    b2BodyDef bodyDef;;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *bluePortal_Body = _world->CreateBody(&bodyDef);
    
    b2Vec2 vertices[4];
    //row 1, col 1
    int num = 4;
    vertices[0].Set(-26.1f / PTM_RATIO, 27.0f / PTM_RATIO);
    vertices[1].Set(-25.9f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[2].Set(26.2f / PTM_RATIO, -24.9f / PTM_RATIO);
    vertices[3].Set(26.2f / PTM_RATIO, 27.1f / PTM_RATIO);

    
    b2PolygonShape bluePortalShape;
    bluePortalShape.Set(vertices, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &bluePortalShape; // Set the line shape
    fixtureDef.density = 100.0f; // Set the density
    fixtureDef.friction = 0.5f; // Set the friction
    fixtureDef.restitution = 0.1f; // Set the restitution
    
    // Add the shape to the body
    bluePortal_Body->CreateFixture(&fixtureDef);
    bluePortal_Body->SetUserData(self);
    //b2Fixture->SetUserData("bluePortal");[/code]
    //b2CircleShape circle;
    //circle.m_radius = 26.0/PTM_RATIO;
    
    //fixtureDef.shape = &circle;
    //fixtureDef.density = 1.0f;
    //fixtureDef.friction = 0.4f;
    //fixtureDef.restitution = 0.3f;
    
    //body->CreateFixture(&fixtureDef);
    
    _bodies.push_back(bluePortal_Body);
    return _bodies;
}

@end
