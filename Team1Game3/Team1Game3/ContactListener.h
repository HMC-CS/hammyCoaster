//
//  ContactListener.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/14/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import <vector>
#import <algorithm>

//struct MyContact {
//    b2Fixture *fixtureA;
//    b2Fixture *fixtureB;
//    bool operator==(const MyContact& other) const
//    {
//        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
//    }
//};

class ContactListener : public b2ContactListener {
    
public:
//    std::vector<MyContact>_contacts;
    
    ContactListener();
    ~ContactListener();
    
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
    bool _gameWon;
    b2Body* _contactStar;
    
};
