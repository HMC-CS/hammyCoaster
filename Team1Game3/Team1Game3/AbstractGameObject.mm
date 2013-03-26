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

-(id) initWithWorld:(b2World *) world asDefault:(bool) isDefault withSprite:(CCSprite*) sprite withTag:(NSString*) tag
{
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

//void AbstractGameObject::startContact()
//{
//    m_contacting = YES;
//    //NSLog(@"contacting object");
//}
//
//void AbstractGameObject::endContact()
//{
//    m_contacting = NO;
//    //NSLog(@"stopped contacting object");
//}
