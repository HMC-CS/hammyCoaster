//
//  BallObject.m
//  Team1Game
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "BallObject.h"

@implementation BallObject

- (std::vector<b2Body*>)createBodyAtLocation:(CGPoint)location
{    
    // Create body
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = _world->CreateBody(&bodyDef);
    
    // Create fixture
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.3f;
    
    // Add fixture to body
    body->CreateFixture(&fixtureDef);
    
    // Set user data to self and add body to list of bodies
    body->SetUserData(self);
    _bodies.push_back(body);
    
    return _bodies;
}


@end

