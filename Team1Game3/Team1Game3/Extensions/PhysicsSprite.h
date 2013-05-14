//
//  PhysicsSprite.h
//  cocos2d-ios
//
//  Created by Ricardo Quesada on 1/4/12.
//  Copyright (c) 2012 Zynga. All rights reserved.
//

#ifndef PHYSICS_SPRITE_INCLUDED
#define PHYSICS_SPRITE_INCLUDED 1

#import "cocos2d.h"
#import "Box2D.h"

@interface PhysicsSprite : CCSprite
{
	b2Body *body_;	// strong ref
}
-(void) setPhysicsBody:(b2Body*)body;
-(b2Body) getPhysicsBody;

@end

#endif  // PHYSICS_SPRITE_INCLUDED