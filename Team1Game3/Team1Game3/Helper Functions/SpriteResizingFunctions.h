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

/* setSpriteSize:InLayer:WithSize:
 * Scales the sprite based on the layer and the fraction of the layer you want the size of
 * the object to be, then sets the contentSize to the size of the new bounding box
 */
+ (void) setSpriteSize: (CCSprite*) sprite InLayer: (CCLayer*) layer WithSize: (CGFloat) size;;

@end

#endif  // SPRITE_RESIZING_FUNCTIONS_INCLUDED