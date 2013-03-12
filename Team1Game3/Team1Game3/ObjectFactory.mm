//
//  ObjectFactory.m
//  Team1Game2
//
//  Created by jarthur on 3/8/13.
//
//

#import "ObjectFactory.h"

@implementation ObjectFactory

+ (AbstractGameObject *) objectFromString:(NSString *)className forWorld:(b2World *)world
{
    Class objectClass = NSClassFromString(className);
    AbstractGameObject* newObject = [[objectClass alloc] initWithWorld:world];
    return newObject;
}

@end
