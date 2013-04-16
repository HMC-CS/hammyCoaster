//
//  AbstractGameObject.m
//  Team1Game
//
//  Created by jarthur on 3/8/13.
//
//

#import "AbstractGameObject.h"

@implementation AbstractGameObject

@synthesize _tag;
//@synthesize _isDefault;

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprite:(CCSprite*) sprite withTag:(NSString*) tag
{
    NSAssert(world, @"Physics world passed to AbstractGameObject init is null.");
    NSAssert1(sprite, @"Sprite %@ passed to AbstractGameObject is null.", sprite);
    NSAssert1(NSClassFromString(tag), @"AbstractGameObject tag %@ does not refer to a valid class.", tag);
    
    self = [super init];
    if (self) {
        _world = world;
        _isDefault = isDefault;
        _sprite = sprite;
        _tag = tag;
    }
    return self;
}

-(CCSprite *) getSprite
{
    return _sprite;
}


// TODO: make createBody:AtLocation to make consistent with rest of code.
- (b2Body *) createBody:(CGPoint)location
{
    // Must create body, set user data to "self," and create tag.
    NSAssert(NO, @"The 'createBody' method must be implemented by the sub-object.");
    // this code should never execute; only included so that the
    // function returns the data type as promised
    b2Body *body = self->_world->CreateBody(&_bodyDef);
    return body;
}

@end
