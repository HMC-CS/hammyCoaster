//
//  SpriteResizingFunctions.h
//  Team1Game3
//
//  Created by Carson Ramsden on 5/12/13.
//
//

#ifndef SPRITE_RESIZING_FUNCTIONS_INCLUDED
#define SPRITE_RESIZING_FUNCTIONS_INCLUDED 1

#import <Foundation/Foundation.h>

#import "PhysicsSprite.h"

#import "CCLayer.h"

@interface SpriteResizingFunctions : NSObject

+ (void) setSpriteSize: (CCSprite*) sprite inLayer: (CCLayer*) layer withSize: (CGFloat) size;;

@end

#endif  // SPRITE_RESIZING_FUNCTIONS_INCLUDED