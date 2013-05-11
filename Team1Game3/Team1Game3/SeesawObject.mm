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

-(std::vector<b2Body*>)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body* circleBody = _world->CreateBody(&_bodyDef);
    
    CCSprite* circleSprite = [_sprites objectAtIndex:0];
    float circleHeight = circleSprite.contentSize.height/PTM_RATIO/2 * 0.63;
    float circleWidth = circleSprite.contentSize.width/PTM_RATIO/2;
    b2PolygonShape circleShape;
    circleShape.SetAsBox(circleWidth, circleHeight);
    
//    b2CircleShape circleShape;
//    circleShape.m_radius = 26.0/PTM_RATIO;
    
    b2FixtureDef circleFixtureDef;
    circleFixtureDef.shape = &circleShape;
    circleFixtureDef.density = 100.0f;
    circleFixtureDef.friction = 10.0f;
    circleFixtureDef.restitution = 0.8f;
    circleBody->CreateFixture(&circleFixtureDef);
    
    circleBody->SetUserData(self);
    
    b2Vec2 anchor1 = circleBody->GetWorldCenter();
    anchor1.y += 26.0/(PTM_RATIO*2.0);
    _bodyDef2.type = b2_dynamicBody;
    _bodyDef2.position.Set(anchor1.x, anchor1.y);
    
    
    NSLog(@"finished second body Def");
    
    // TODO: this line is causing the code to crash!  figure out why?
    b2Body* teeterBody = _world->CreateBody(&_bodyDef2);
    NSLog(@"got through next one too");
    
   /* CCSprite* teeterSprite = [_sprites objectAtIndex:1];
    float teeterHeight = teeterSprite.contentSize.height/PTM_RATIO/2;
    float teeterWidth = teeterSprite.contentSize.width/PTM_RATIO/2;
    */
    b2Vec2 vertices[8];
    int num = 8;
    vertices[0].Set(149.8f / PTM_RATIO, 12.2f / PTM_RATIO);
    vertices[1].Set(-148.2f / PTM_RATIO, 11.9f / PTM_RATIO);
    vertices[2].Set(-157.5f / PTM_RATIO, 5.6f / PTM_RATIO);
    vertices[3].Set(-157.5f / PTM_RATIO, -14.2f / PTM_RATIO);
    vertices[4].Set(-147.7f / PTM_RATIO, -21.7f / PTM_RATIO);
    vertices[5].Set(145.2f / PTM_RATIO, -21.9f / PTM_RATIO);
    vertices[6].Set(157.2f / PTM_RATIO, -17.9f / PTM_RATIO);
    vertices[7].Set(159.7f / PTM_RATIO, 1.6f / PTM_RATIO);
    
    b2PolygonShape teeterShape;
    teeterShape.Set(vertices, num);
    //teeterShape.SetAsBox(teeterWidth, teeterHeight);
    b2FixtureDef teeterFixtureDef;
    teeterFixtureDef.shape = &teeterShape;
    teeterFixtureDef.density = 1.5f;
    teeterFixtureDef.friction = 200.0f;
    teeterBody->CreateFixture(&teeterFixtureDef);
    
    teeterBody->SetUserData(self);
    
    
    b2RevoluteJointDef jointdef1;
    b2Joint* rev1_joint;
    
    jointdef1.Initialize(teeterBody, circleBody, anchor1);
    jointdef1.collideConnected = false;
    jointdef1.lowerAngle = -b2_pi/6.0;
    jointdef1.upperAngle = b2_pi/6.0;
    jointdef1.enableLimit = true;
    jointdef1.maxMotorTorque = 50.0f;
    jointdef1.motorSpeed = 8.0f;
    jointdef1.enableMotor = false;
    rev1_joint = _world->CreateJoint(&jointdef1);
    
    rev1_joint->SetUserData(self);
    
    
    _bodies.push_back(circleBody);
    _bodies.push_back(teeterBody);
    
    return _bodies;
}

@end
