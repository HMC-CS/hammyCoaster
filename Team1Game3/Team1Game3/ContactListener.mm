//
//  ContactListener.m
//  Team1Game3
//
//  Created by jarthur on 3/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//


#import "ContactListener.h"
#import "AbstractGameObject.h"

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact* contact) {
    
//    printf("contact");
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
    //check if fixture A was a ball
    void* bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();
    //if ( bodyUserData )
       // static_cast<AbstractGameObject*>( bodyUserData )->endContact;
    
    //check if fixture B was a ball
    bodyUserData = contact->GetFixtureB()->GetBody()->GetUserData();
    //if ( bodyUserData )
        //static_cast<AbstractGameObject*>( bodyUserData )->endContact();
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}