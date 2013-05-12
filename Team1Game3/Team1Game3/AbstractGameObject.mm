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

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprites:(NSMutableArray *)spriteArray withType:(NSString *)type
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


// TODO: make createBody:AtLocation to make consistent with rest of code.
- (std::vector<b2Body*>) createBody:(CGPoint)location
{
    // Must create body, set user data to "self," and create tag.
    NSAssert(NO, @"The 'createBody' method must be implemented by the sub-object.");
    // this code should never execute; only included so that the
    // function returns the data type as promised
    b2BodyDef bodyDef;
    b2Body *body = self->_world->CreateBody(&bodyDef);
    _bodies.push_back(body);
    return _bodies;
}

@end
