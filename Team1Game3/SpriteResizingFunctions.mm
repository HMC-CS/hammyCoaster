//
//  SpriteResizingFunctions.m
//  Team1Game3
//
//  Created by Carson Ramsden on 5/12/13.
//
//

#import "SpriteResizingFunctions.h"

#import "PhysicsSprite.h"


#import "CCLayer.h"

@implementation SpriteResizingFunctions

/* setSpritSize inLayer: withSize:
 * scales the sprite based on the layer and the fraction of the layer you want the size of
 * the object to be, then sets the contentSize to the size of the new bounding box
 */

+ (void) setSpriteSize: (CCSprite*) sprite inLayer: (CCLayer*) layer withSize: (CGFloat) size;
{
    //[sprite setTextureRect:CGRectMake(x,y,width,height)]
    CGFloat newWidth = size * layer.boundingBox.size.width;
    CGFloat newHeight = size * (layer.boundingBox.size.height/3);
    [sprite setScaleX: (newWidth/sprite.contentSize.width)];
    [sprite setScaleY: (newHeight/sprite.contentSize.height)];
    sprite.contentSize = sprite.boundingBox.size;
    
}



@end
