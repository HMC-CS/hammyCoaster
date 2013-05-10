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

+ (id) sharedObjectFactory;

- (AbstractGameObject *) objectFromString:(NSString *)className forWorld:(b2World *)world asDefault:(bool) isDefault withSprites:(NSMutableArray*) spriteArray;

@end
