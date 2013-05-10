//
//  WorldManager.h
//  Team1Game3
//
//  Created by jarthur on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "ContactListener.h"

@interface WorldManager : NSObject {
    
    b2World* _world;
    
    ContactListener* _contactListener;
    
}

-(id) initWithWorld: (b2World*) world;
-(void) applyMagnets;
-(void) springSeesaw;

-(void) setContactListener: (ContactListener*) contactListener;
//-(void) update;

@end
