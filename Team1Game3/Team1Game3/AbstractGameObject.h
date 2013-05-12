//
//  AbstractGameObject.h
//  Team1Game
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#include <vector>

#define PTM_RATIO 32

@interface AbstractGameObject : NSObject
{
    b2World* _world;                // The world in which the object resides
    
    NSMutableArray* _sprites;       // The object's sprites
    std::vector<b2Body*> _bodies;   // The object's bodies
    NSString* _type;                // The object's class (type)
    bool _isDefault;                // Whether the object was added by default or by the player
}

@property(retain, readonly) NSMutableArray* sprites;
@property(readonly) std::vector<b2Body*> bodies;
@property(retain, readonly) NSString* type;
@property(readonly) bool isDefault;


/* initWithWorld:AsDefault:WithSprites:WithType:
 * Init function for AbstractGameObject
 */
-(id) initWithWorld:(b2World *) world AsDefault:(bool) isDefault WithSprites:(NSMutableArray*) spriteArray WithType:(NSString*) type;


/* createBodyAtLocation:
 * Creates an object at a given location
 * Returns a vector of the object's b2Bodies
 */
-(std::vector<b2Body*>) createBodyAtLocation:(CGPoint) location;

@end
