//
//  ObjectFactory.h
//  Team1Game2
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AbstractGameObject.h"
#import "BallObject.h"

@interface ObjectFactory : NSObject

/* sharedObjectFactory
 * Implements Object Factory as a singleton class
 * Returns the object factory
 */
+ (id) sharedObjectFactory;

/* objectFromString:ForWorld:AsDefault:WithSprites
 * Creates a game object given specifications.
 * Returns the game object.
 */
- (AbstractGameObject *) objectFromString:(NSString *)className ForWorld:(b2World *)world AsDefault:(bool) isDefault WithSprites:(NSMutableArray*) spriteArray;

@end
