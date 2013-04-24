//
//  SeesawObject.m
//  Team1Game3
//
//  Created by user on 4/22/13.
//
//

#import "SeesawObject.h"

@implementation SeesawObject


// Code from http://www.cocos2d-iphone.org/forum/topic/10193

- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    b2BodyDef circleBodyDef;
    circleBodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body* circleBody = _world->CreateBody(&circleBodyDef);
    
    b2CircleShape circleShape;
    circleShape.m_radius = 26.0/PTM_RATIO;
    
    b2FixtureDef circleFixtureDef;
    circleFixtureDef.shape = &circleShape;
    circleFixtureDef.density = 100.0f;
    circleFixtureDef.friction = 10.0f;
    circleFixtureDef.restitution = 0.8f;
    circleBody->CreateFixture(&circleFixtureDef);
    
    
    
    b2Vec2 anchor1 = circleBody->GetWorldCenter();
    anchor1.y += 26.0/(PTM_RATIO*2.0);
    b2BodyDef teeterBodyDef;
    teeterBodyDef.position.Set(anchor1.x, anchor1.y);
    b2Body* teeterBody = _world->CreateBody(&teeterBodyDef);
    
    float teeterHeight = 52.0/PTM_RATIO;
    float teeterWidth = 156.0/PTM_RATIO;
    b2PolygonShape teeterShape;
    teeterShape.SetAsBox(teeterWidth, teeterHeight);
    b2FixtureDef teeterFixtureDef;
    teeterFixtureDef.shape = &teeterShape;
    teeterFixtureDef.density = 10.0f;
    teeterFixtureDef.friction = 10.0f;
    teeterBody->CreateFixture(&teeterFixtureDef);
    
    
    
    
    b2RevoluteJointDef jointdef1;
    b2Joint* rev1_joint;
    
    jointdef1.Initialize(teeterBody, circleBody, anchor1);
    jointdef1.collideConnected = false;
    jointdef1.lowerAngle = -b2_pi/6.0;
    jointdef1.upperAngle = b2_pi/6.0;
    jointdef1.enableLimit = true;
    jointdef1.maxMotorTorque = 50.0f;
    jointdef1.motorSpeed = 0.0f;
    jointdef1.enableMotor = false;
    rev1_joint = _world->CreateJoint(&jointdef1);
    
    
    _bodies.push_back(circleBody);
    _bodies.push_back(teeterBody);
    
    return _bodies;

}
@end


//_bodyDef.type = b2_dynamicBody;
//_bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
//b2Body *body = _world->CreateBody(&_bodyDef);
//
//b2CircleShape circle;
//circle.m_radius = 26.0/PTM_RATIO;
//
//_fixtureDef.shape = &circle;
//_fixtureDef.density = 1.0f;
//_fixtureDef.friction = 0.4f;
//_fixtureDef.restitution = 0.3f;

//body->CreateFixture(&_fixtureDef);
//body->SetUserData(self);
//
//_bodies.push_back(body);

//return _bodies;