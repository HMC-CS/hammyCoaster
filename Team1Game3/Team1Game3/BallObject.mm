//
//  BallObject.m
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//
//

#import "BallObject.h"

@implementation BallObject

- (b2Body *)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_dynamicBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = self->_world->CreateBody(&_bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
    _fixtureDef.shape = &circle;
    _fixtureDef.density = 1.0f;
    _fixtureDef.friction = 0.4f;
    _fixtureDef.restitution = 0.3f;
    
    body->CreateFixture(&_fixtureDef);
    return body;
}

@end
