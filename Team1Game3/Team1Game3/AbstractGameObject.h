//
//  AbstractGameObject.h
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32

@interface AbstractGameObject : NSObject
{
    b2World* _world;
    b2BodyDef _bodyDef;
    b2FixtureDef _fixtureDef;
    
    bool _isDefault;
}

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault;
-(b2Body *) createBody:(CGPoint) location;

@end
