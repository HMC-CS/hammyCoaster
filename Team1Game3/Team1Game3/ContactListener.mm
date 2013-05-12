//
//  ContactListener.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//


#import "ContactListener.h"
#import "AbstractGameObject.h"

#import "SoundManager.h"

ContactListener::ContactListener()
{
    _levelWon = false;
    _contactStar = NULL;
}

ContactListener::~ContactListener()
{
    // Nothing to be done here.
}

void ContactListener::BeginContact(b2Contact* contact)
{
    
    // Get the objects
    b2Body* body1 = contact->GetFixtureA()->GetBody();
    b2Body* body2 = contact->GetFixtureB()->GetBody();
    
    AbstractGameObject* body1Object = static_cast<AbstractGameObject*>(body1->GetUserData());
    AbstractGameObject* body2Object = static_cast<AbstractGameObject*>(body2->GetUserData());
    
    
    if (body1Object && body2Object)
    {
        // Find the object types
        NSString* body1Type = body1Object.type;
        NSString* body2Type = body2Object.type;
        
        // Sound effects for ball collisions
        if ([body1Type isEqualToString:@"BallObject"] || [body2Type isEqualToString:@"BallObject"]) {
            NSString* objectType;
            if ([body1Type isEqualToString:@"BallObject"]) {
                objectType = body2Type;
            } else {
                objectType = body1Type;
            }
            [[SoundManager sharedSoundManager] playEffectOfType:objectType];
        }
        
        // If the ball collides with the blue portal, the level has been won
        if (([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"BluePortalObject"])
            || ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"BluePortalObject"])) {
            _levelWon = true;
            body1->SetAwake(false);
            body2->SetAwake(false);
        }
        
        // If the ball collides with a star, keep the star body.
        if ([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"StarObject"]) {
            _contactStar = body2;
        }
        if ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"StarObject"]) {
            _contactStar = body1;
        }
    }
}

void ContactListener::EndContact(b2Contact* contact)
{
    // Nothing to be done here.
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
    // Nothing to be done here.
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
    // Nothing to be done here.
}

bool ContactListener::IsLevelWon()
{
    return _levelWon;
}

void ContactListener::SetLevelWonStatus(bool levelWon)
{
    _levelWon = levelWon;
}

b2Body* ContactListener::GetContactStar()
{
    return _contactStar;
}

void ContactListener::EraseContactStar()
{
    _contactStar = NULL;
}