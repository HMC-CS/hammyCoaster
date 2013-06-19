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


-(void) setBoundariesForLayer:(CCLayer *)layer
{
    CGSize size = [layer contentSize];
    
	// Create the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	b2Body* groundBody = _world->CreateBody(&groundBodyDef);
	
	// Create ground fixtures.
	b2EdgeShape groundBox;
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	// top
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	// left
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	// right
	groundBox.Set(b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    
    
    // DEBUG_DRAW. Debug draw. Remove these lines out before publishing.
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	_world->SetDebugDraw(m_debugDraw);
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	m_debugDraw->SetFlags(flags);
}



-(void) destroyBody:(b2Body *)body
{
    _bodiesToDestroy.push_back(body);
}



-(void) update
{
    // Attract the ball to magnets and rotate the seesaw if needed.
    [self applyMagnets];
    [self springSeesaw];
    
    // Destroy bodies
    for (std::vector<b2Body*>::iterator i = _bodiesToDestroy.begin(); i != _bodiesToDestroy.end(); ++i) {
        b2Body* body = *i;
        _world->DestroyBody(body);
    }
    _bodiesToDestroy.erase(_bodiesToDestroy.begin(), _bodiesToDestroy.end());
}


/* ////////////////////////////// Private Functions ////////////////////////////// */

/* applyMagnets
 * Affects the ball based on magnets.
 * MULTI: Change this function if the ball or the magnet is changed to a
 *  multi-bodied object
 */
-(void) applyMagnets
{
    int magnetConstant = 400000000;
    
    // Find all the magnets
    for (b2Body* magnet = _world->GetBodyList(); magnet; magnet = magnet->GetNext()) {
        if ([((__bridge AbstractGameObject*)(magnet->GetUserData())).type isEqualToString:@"MagnetObject"]) {
            
            // Get the ball's body
            for (b2Body* ball = _world->GetBodyList(); ball; ball = ball->GetNext()) {
                if ([((__bridge AbstractGameObject*)(ball->GetUserData())).type isEqualToString:@"BallObject"]) {
                    
                    // Get the distance of the ball from one fixture and create a magnetic force vector on
                    // the ball based on this distance
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
                    
                    
                    // Do the same for the other fixture
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
                    
                    
                    // Attract the magnet to north and repel it from south
                    b2Vec2 force;
                    if ([(__bridge NSString*)(fixture1->GetUserData()) isEqualToString:@"NORTH"]) {
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


/* springSeesaw
 * Adjusts the seesaw gradually back to equilibrium
 */
-(void) springSeesaw
{
    
    // Find joints in the world
    for (b2Joint* joint = _world->GetJointList(); joint; joint = joint->GetNext()) {
        
        // Get joint object (seesaw?)
        AbstractGameObject* object = (__bridge AbstractGameObject*)(joint->GetUserData());
        CFBridgingRetain(object);
        NSString* type = object.type;
        
        // Apply torque to body back towards equilibrium
        if ([type isEqualToString:@"SeesawObject"]) {
            const float springTorqForce = 1.0f;
            float jointAngle = joint->GetBodyA()->GetAngle(); // teeter body
            
            b2Body *jointpoint2 = joint->GetBodyA();
            
            if (jointAngle == 0.0) {
                jointpoint2 ->IsFixedRotation();
                jointpoint2->SetAngularVelocity(0);
                NSLog(@"things set to 0");
                return;
            }
            if ( jointAngle != 0.0 ) {
                float torque = fabs(jointAngle * springTorqForce * 50);
                if (jointAngle > 0.0) {
                    joint->GetBodyA()->ApplyTorque(-torque);
                } else {
                    joint->GetBodyA()->ApplyTorque(torque);
                }
            }
        }
    }
}


/* resetSeesaw
 * resets the seesaw to equilbrium/zero offset when the ball is reset.
 */
-(void) resetSeesaw
{
    NSLog(@"resetSeesaw inside the method");
    // Find joints in the world
    for (b2Joint* joint = _world->GetJointList(); joint; joint = joint->GetNext()) {
        
        // Get joint object (seesaw?)
        AbstractGameObject* object = (__bridge AbstractGameObject*)(joint->GetUserData());
        CFBridgingRetain(object);
        NSString* type = object.type;
        
        // Apply torque to body back towards equilibrium
        if ([type isEqualToString:@"SeesawObject"]) {
            
            b2Body *jointpoint = joint->GetBodyA();
            float jointAngle = joint->GetBodyA()->GetAngle();
            jointAngle = 0.0;
            NSLog(@"joint angle set to zero");

            NSLog(@"%f", jointAngle);

        }
    }

}



@end
