//
//  ObjectFactory.m
//  Team1Game2
//
//  Created by jarthur on 3/8/13.
//
//

#import "ObjectFactory.h"

@implementation ObjectFactory

+(id)sharedObjectFactory
{
    static ObjectFactory *sharedObjectFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObjectFactory = [[self alloc] init];
    });
    return sharedObjectFactory;
}

- (AbstractGameObject *) objectFromString:(NSString *)className forWorld:(b2World *)world asDefault:(bool)isDefault withSprite:(CCSprite*) sprite
{
    Class objectClass = NSClassFromString(className);
    
    NSAssert1(objectClass, @"ObjectFactory called with invalid class name %@", className);
    
    AbstractGameObject* newObject = [[objectClass alloc] initWithWorld:world asDefault:isDefault withSprite:(CCSprite*) sprite withTag:className];
    return newObject;
}

@end
