//
//  ContactListener.m
//  Team1Game3
//
//  Created by jarthur on 3/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//


#import "ContactListener.h"
#import "AbstractGameObject.h"

ContactListener::ContactListener() {
    gameWon = false;
    contactStar = NULL;
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
        if (([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"BluePortalObject"])
            || ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"BluePortalObject"])) {
            gameWon = true;
            body1->SetAwake(false);
            body2->SetAwake(false);
        }
        if ([body1Type isEqualToString:@"BallObject"] && [body2Type isEqualToString:@"StarObject"])
        {
            NSLog(@"Star Collision");
            contactStar = body2;

        }
        if ([body2Type isEqualToString:@"BallObject"] && [body1Type isEqualToString:@"StarObject"])
        {
            NSLog(@"Star Collision");
            contactStar = body1;

        }
    }
    
    
//    
//    void* bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();
//    if (bodyUserData) {
//        bodyUserData->startContact();
//    }

//    //check if fixture A was a ball
//    void* bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();
//    if ( bodyUserData )
//        //static_cast<AbstractGameObject*>( bodyUserData ) startContact;
//        //NSLog(@"contact");
//    
//    //check if fixture B was a ball
//    bodyUserData = contact->GetFixtureB()->GetBody()->GetUserData();
//    //if ( bodyUserData )
//        //static_cast<AbstractGameObject*>( bodyUserData )->startContact;
}

void ContactListener::EndContact(b2Contact* contact) {
//    //check if fixture A was a ball
//    void* bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();
//    //if ( bodyUserData )
//       // static_cast<AbstractGameObject*>( bodyUserData )->endContact;
//    
//    //check if fixture B was a ball
//    bodyUserData = contact->GetFixtureB()->GetBody()->GetUserData();
//    //if ( bodyUserData )
//        //static_cast<AbstractGameObject*>( bodyUserData )->endContact();
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}