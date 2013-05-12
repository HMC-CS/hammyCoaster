//
//  AbstractGameObject.m
//  Team1Game
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "AbstractGameObject.h"

@implementation AbstractGameObject

@synthesize sprites = _sprites, bodies = _bodies, type = _type, isDefault = _isDefault;


-(id) initWithWorld:(b2World *) world AsDefault:(bool) isDefault WithSprites:(NSMutableArray *)spriteArray WithType:(NSString *)type
{
    NSAssert(world, @"Physics world passed to AbstractGameObject init is null.");
    NSAssert1(spriteArray, @"Sprite array %@ passed to AbstractGameObject is null.", spriteArray);
    NSAssert1(NSClassFromString(type), @"AbstractGameObject type %@ does not refer to a valid class.", type);
    
    self = [super init];
    if (self) {
        _world = world;
        _isDefault = isDefault;
        _sprites = [[NSMutableArray alloc] initWithArray:spriteArray];
        _type = type;
    }
    return self;
}


- (std::vector<b2Body*>) createBodyAtLocation:(CGPoint)location
{
    // Must create body and set user data to "self"
    NSAssert(NO, @"The 'createBody' method must be implemented by the sub-object.");
    
    // This code should never execute; only included so that the
    // function returns the correct data type as promised
    b2BodyDef bodyDef;
    b2Body* body = self->_world->CreateBody(&bodyDef);
    _bodies.push_back(body);
    return _bodies;
}

@end
