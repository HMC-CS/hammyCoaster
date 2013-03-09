//
//  AbstractGameObject.m
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//
//

#import "AbstractGameObject.h"

@implementation AbstractGameObject

-(id) initWithWorld:(b2World *) world andDraggable:(bool) draggable
{
    self = [super init];
    if (self) {
        _world = world;
        _draggable = draggable;
    }
    return self;
}

- (b2Body *) createBody:(CGPoint) location
{
    NSAssert(NO, @"The 'createBody' method must be implemented by the sub-object.");
}

@end
