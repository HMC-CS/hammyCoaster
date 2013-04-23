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

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprites:(NSMutableArray *)spriteArray withTag:(NSString *)tag
{
    NSAssert(world, @"Physics world passed to AbstractGameObject init is null.");
    NSAssert1(spriteArray, @"Sprite array %@ passed to AbstractGameObject is null.", spriteArray);
    NSAssert1(NSClassFromString(tag), @"AbstractGameObject tag %@ does not refer to a valid class.", tag);
    
    self = [super init];
    if (self) {
        _world = world;
        _isDefault = isDefault;
        _sprites = spriteArray;
        _tag = tag;
    }
    return self;
}

-(NSMutableArray *) getSprites
{
    return _sprites;
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
