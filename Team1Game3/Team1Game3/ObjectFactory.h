//
//  ObjectFactory.h
//  Team1Game2
//
//  Created by jarthur on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "AbstractGameObject.h"
#import "BallObject.h"

@interface ObjectFactory : NSObject

+ (id) sharedObjectFactory;

- (AbstractGameObject *) objectFromString:(NSString *)className forWorld:(b2World *)world asDefault:(bool) isDefault withSprite:(CCSprite*) sprite;

@end
