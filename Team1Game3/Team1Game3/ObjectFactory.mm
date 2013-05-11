//
//  ObjectFactory.m
//  Team1Game2
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "ObjectFactory.h"

@implementation ObjectFactory

+(id)sharedObjectFactory
{
    static ObjectFactory *sharedObjectFactory = nil;
    
    // Make sure a class can't make two object factories.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObjectFactory = [[self alloc] init];
    });
    
    return sharedObjectFactory;
}


- (AbstractGameObject *) objectFromString:(NSString *)className ForWorld:(b2World *)world AsDefault:(bool)isDefault WithSprites:(NSMutableArray *)spriteArray
{
    Class objectClass = NSClassFromString(className);
    
    NSAssert1(objectClass, @"ObjectFactory called with invalid class name %@", className);
    
    // Make a new object with the given parameters
    AbstractGameObject* newObject = [[objectClass alloc] initWithWorld:world asDefault:isDefault withSprites:(NSMutableArray*) spriteArray withTag:className];
    
    return newObject;
}

@end
