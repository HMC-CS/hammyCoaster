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
    
    // TODO - this is currently a dynamic body so it rests nicely on things.  We want to make this a static object.
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
    body->SetUserData(self);
    
    return body;
}


-(void)dealloc
{
    // Does the world need to be created here?
    delete _world;
    _world = NULL;
    //For loop of all the balls created
    
    [super dealloc];
    // make an array of all the balls created in the world and delete them all
    //for loop here there should be a ball object
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
    {
        _world->DestroyBody(b);
    }
}


@end

