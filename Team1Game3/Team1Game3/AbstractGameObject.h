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
    
    NSMutableArray* _sprites;
    std::vector<b2Body*> _bodies;
    NSString* _type;
    bool _isDefault;
}

@property(retain, readonly) NSMutableArray* sprites;
@property(readonly) std::vector<b2Body*> bodies;
@property(retain, readonly) NSString* type;
@property(readonly) bool isDefault;

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprites:(NSMutableArray*) spriteArray withType:(NSString*) type;
-(std::vector<b2Body*>) createBody:(CGPoint) location;

@end
