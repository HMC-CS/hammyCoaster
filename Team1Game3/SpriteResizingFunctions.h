//
//  SpriteResizingFunctions.h
//  Team1Game3
//
//  Created by Carson Ramsden on 5/12/13.
//
//

#import <Foundation/Foundation.h>

#import "PhysicsSprite.h"


#import "CCLayer.h"

@interface SpriteResizingFunctions : NSObject

+ (void) setSpriteSize: (CCSprite*) sprite inLayer: (CCLayer*) layer withSize: (CGFloat) size;;

@end
