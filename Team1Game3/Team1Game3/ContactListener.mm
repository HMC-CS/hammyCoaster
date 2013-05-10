//
//  ContactListener.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//


#import "ContactListener.h"
#import "AbstractGameObject.h"

#import "SoundManager.h"

ContactListener::ContactListener() {
    _gameWon = false;
    _contactStar = NULL;
}

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact* contact) {
    
    b2Body* body1 = contact->GetFixtureA()->GetBody();
    b2Body* body2 = contact->GetFixtureB()->GetBody();
    
    AbstractGameObject* body1Object = static_cast<AbstractGameObject*>(body1->GetUserData());
    AbstractGameObject* body2Object = static_cast<AbstractGameObject*>(body2->GetUserData());
    
    
    if (body1Object && body2Object)
    {
        NSString* body1Type = body1Object->_tag;
        NSString* body2Type = body2Object->_tag;
        
        // Sound effects
        if ([body1Type isEqualToString:@"BallObject"] || [body2Type isEqualToString:@"BallObject"]) {
            NSString* objectType;
            if ([body1Type isEqualToString:@"BallObject"])
                objectType = body2Type;
            else
                objectType = body1Type;
            [[SoundManager sharedSoundManager] playEffectOfType:objectType];
        }
        
        if (([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"BluePortalObject"])
            || ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"BluePortalObject"])) {
            _gameWon = true;
            body1->SetAwake(false);
            body2->SetAwake(false);
        }
        if ([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"StarObject"])
        {
           // NSLog(@"Star Collision");
            _contactStar = body2;
        }
        if ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"StarObject"])
        {
           // NSLog(@"Star Collision");
            _contactStar = body1;
        }
    }
}

void ContactListener::EndContact(b2Contact* contact) {

    // Nothing to be done here.
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    
    // Nothing to be done here.
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
    
    // Nothing to be done here.
}