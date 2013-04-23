//
//  SeesawObject.m
//  Team1Game3
//
//  Created by user on 4/22/13.
//
//

#import "SeesawObject.h"

@implementation SeesawObject

- (std::vector<b2Body*>)createBody:(CGPoint)location {
b2BodyDef circleBodyDef;

circleBodyDef.position.Set(10,2);

CCSprite *circleSprite = [CCSprite spriteWithFile:@"ball.png"];
circleSprite.scale = .22f;

[self addChild:circleSprite];

circleBodyDef.userData = circleSprite;

b2Body* circleBody = _world->CreateBody(&circleBodyDef);

b2CircleShape circleShape;

circleShape.m_radius = 26.0/PTM_RATIO;

b2FixtureDef circleFixtureDef;
circleFixtureDef.shape = &circleShape;
circleFixtureDef.density = 100.0f;
circleFixtureDef.friction = 10.0f;
circleFixtureDef.restitution = 0.8f;
circleBody->CreateFixture(&circleFixtureDef);

b2Vec2 anchor1 =  circleBody->GetWorldCenter();
anchor1.y += 26.0/(PTM_RATIO*2.0);


b2BodyDef teeterBodyDef;

teeterBodyDef.type = b2_dynamicBody;

teeterBodyDef.position.Set(anchor1.x,anchor1.y);

CCSprite *teeterSprite = [CCSprite spriteWithFile:@"arm.png"];
teeterSprite.scaleX = 3;

[self addChild:teeterSprite];

float teeterHeight = ((teeterSprite.contentSize.height/PTM_RATIO)/2)*teeterSprite.scaleY;
float teeterWidth = ((teeterSprite.contentSize.width/PTM_RATIO)/2)*teeterSprite.scaleX;

teeterBodyDef.userData = teeterSprite;

b2Body* teeterBody = _world->CreateBody(&teeterBodyDef);

b2PolygonShape teeterShape;

teeterShape.SetAsBox(teeterWidth,teeterHeight);
b2FixtureDef teeterFixtureDef;
teeterFixtureDef.shape = &teeterShape;
teeterFixtureDef.density = 10.0f;
teeterFixtureDef.friction = 10.0f;
teeterBody->CreateFixture(&teeterFixtureDef);


b2RevoluteJointDef jointdef1;
b2Joint *rev1_joint;

jointdef1.Initialize(teeterBody, circleBody, anchor1);
jointdef1.collideConnected = false;
jointdef1.lowerAngle = -b2_pi/6.0;
jointdef1.upperAngle = b2_pi/6.0;
jointdef1.enableLimit = true;
jointdef1.maxMotorTorque = 50.0f;
jointdef1.motorSpeed = 0.0f;
jointdef1.enableMotor = false;
rev1_joint = _world -> CreateJoint(&jointdef1);
    
    _bodies.push_back(circleBody);
    _bodies.push_back(teeterBody);

}
    
@end
