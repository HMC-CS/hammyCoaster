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


class ContactListener : public b2ContactListener {
    
public:
    
    /*
     * Constructor and destructor
     */
    ContactListener();
    ~ContactListener();
    
    /*
     * Functions to deal with objects colliding
     */
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
    /*
     * IsLevelWon()
     * Returns true if the level has been won (the ball has collided with red portal)
     * Returns false otherwise.
     */
    bool IsLevelWon();
    
    /*
     * SetGameWonStatus
     * Gives user the ability to set level win status to true or false.
     */
    void SetLevelWonStatus(bool levelWon);
    
    /*
     * GetContactStar
     * Returns the body of the star that the ball has hit.
     */
    b2Body* GetContactStar();
    
    /*
     * EraseContactStar
     * Sets body of contact star to null.
     */
    void EraseContactStar();

private:
    
    bool _levelWon;                  // Keeps track of if level is won.
    b2Body* _contactStar;            // Body of star that has been hit.
    
};
