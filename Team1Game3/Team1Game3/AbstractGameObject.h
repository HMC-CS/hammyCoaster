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
    b2BodyDef _bodyDef;
    b2FixtureDef _fixtureDef;
  
    
    // TODO: we will fix these public variables for v1!
    @public
    NSMutableArray* _sprites;
    std::vector<b2Body*> _bodies;
    NSString* _tag;
    bool _isDefault;
}

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprites:(NSMutableArray*) spriteArray withTag:(NSString*) tag;
-(NSMutableArray *) getSprites;
-(std::vector<b2Body*>) createBody:(CGPoint) location;

@property(retain, readonly) NSString* _tag;
//@property(readonly) bool _isDefault;

@end
