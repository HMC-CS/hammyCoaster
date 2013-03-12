//
//  AbstractGameObject.m
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//
//

#import "AbstractGameObject.h"

@implementation AbstractGameObject

-(id) initWithWorld:(b2World *)world
{
    self = [super init];
    if (self) {
        self ->_world = world;
    }
    return self;
}

- (b2Body *) createBody:(CGPoint)location
{
    NSAssert(NO, @"The 'createBody' method must be implemented by the sub-object.");
}

@end
