//
//  WorldManager.m
//  Team1Game3
//
//  Created by jarthur on 5/9/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "WorldManager.h"

#import "AbstractGameObject.h"

#import "MathHelper.h"


@implementation WorldManager

-(id) initWithWorld: (b2World*) world
{
    if (self = [super init]) {
        _world = world;
    }
    
    return self;
}

// TODO: did not change this method for multi-body because BallObject and MagnetObject are single-body objects.  Change if changed.
/* applyMagnets:
 * helper function to apply magnet's forces to the ball
 */
-(void) applyMagnets
{
    int magnetConstant = 400000000;
    //find all the magnets
    for (b2Body* magnet = _world->GetBodyList(); magnet; magnet = magnet->GetNext()){
        if ([((__bridge AbstractGameObject*)(magnet->GetUserData())).type isEqualToString:@"MagnetObject"])
        {
            //get the ball's body
            for (b2Body* ball = _world->GetBodyList(); ball; ball = ball->GetNext()){
                if ([((__bridge AbstractGameObject*)(ball->GetUserData())).type isEqualToString:@"BallObject"])
                {
                    
                    // TODO: after making magnet into two fixtures (one north, one south), simulate point force for each one.  So it'll be like a dipole.
                    
                    b2Fixture* fixture1 = magnet->GetFixtureList();
                    b2PolygonShape* shape1 = static_cast<b2PolygonShape*>(fixture1->GetShape());
                    b2Vec2 shape1Position = shape1->m_centroid;
                    b2Vec2 shape1WorldPosition = magnet->GetWorldPoint(shape1Position);
                    double d11 = ball->GetPosition().x - shape1WorldPosition.x;
                    double d12 = ball->GetPosition().y - shape1WorldPosition.y;
                    double distance1 = sqrt(d11 * d11 + d12 * d12) * 1000;
                    float angleRadians1 = GetAngle(ball->GetPosition().x, ball->GetPosition().y, shape1WorldPosition.x, shape1WorldPosition.y);
                    float yComponent1 = sinf(angleRadians1);
                    float xComponent1 = cosf(angleRadians1);
                    b2Vec2 direction1 = b2Vec2((magnetConstant*xComponent1*-1)/(distance1*distance1), (magnetConstant*yComponent1*-1)/(distance1*distance1));
                    
                    
                    b2Fixture* fixture2 = fixture1->GetNext();
                    b2PolygonShape* shape2 = static_cast<b2PolygonShape*>(fixture2->GetShape());
                    b2Vec2 shape2Position = shape2->m_centroid;
                    b2Vec2 shape2WorldPosition = magnet->GetWorldPoint(shape2Position);
                    double d21 = ball->GetPosition().x - shape2WorldPosition.x;
                    double d22 = ball->GetPosition().y - shape2WorldPosition.y;
                    double distance2 = sqrt(d21 * d21 + d22 * d22) * 1000;
                    float angleRadians2 = GetAngle(ball->GetPosition().x, ball->GetPosition().y, shape2WorldPosition.x, shape2WorldPosition.y);
                    float yComponent2 = sinf(angleRadians2);
                    float xComponent2 = cosf(angleRadians2);
                    b2Vec2 direction2 = b2Vec2((magnetConstant*xComponent2*-1)/(distance2*distance2), (magnetConstant*yComponent2*-1)/(distance2*distance2));
                    
                    b2Vec2 force;
                    if ([(__bridge NSString*)(fixture1->GetUserData()) isEqualToString:@"NORTH"])
                    {
                        force = direction2 - direction1;
                        
                    } else {
                        
                        force = direction1 - direction2;
                        
                    }
                    ball->ApplyForce(force, ball->GetPosition());
                    
                    break;
                }
            }
            break;
        }
    }
}

-(void) springSeesaw
{
    for (b2Joint* joint = _world->GetJointList(); joint; joint = joint->GetNext())
    {
        AbstractGameObject* object = (__bridge AbstractGameObject*)(joint->GetUserData());
        CFBridgingRetain(object);
        NSString* type = object.type;
        if ([type isEqualToString:@"SeesawObject"]) {
            const float springTorqForce = 1.0f;
            float jointAngle = joint->GetBodyA()->GetAngle(); // teeter body
            if ( jointAngle != 0 ) {
                float torque = fabs(jointAngle * springTorqForce * 50);
                if (jointAngle > 0.0)
                {
                    joint->GetBodyA()->ApplyTorque(-torque);
                } else {
                    joint->GetBodyA()->ApplyTorque(torque);
                }
            }
            
        }
    }
}


-(void) setObjectFactory:(ObjectFactory *) objectFactory 
{
    _objectFactory = objectFactory;
}

-(void) destroyBody:(b2Body *)body
{
    _bodiesToDestroy.push_back(body);
}

-(void) update
{
    [self applyMagnets];
    [self springSeesaw];
    
    for (std::vector<b2Body*>::iterator i = _bodiesToDestroy.begin(); i != _bodiesToDestroy.end(); ++i)
    {
        b2Body* body = *i;
        _world->DestroyBody(body);
    }
    _bodiesToDestroy.erase(_bodiesToDestroy.begin(), _bodiesToDestroy.end());
}

@end
