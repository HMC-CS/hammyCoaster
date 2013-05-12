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

+ (void) setSpriteSize: (CCSprite*) sprite inLayer: (CCLayer*) layer withSize: (CGFloat) size;
{
    //[sprite setTextureRect:CGRectMake(x,y,width,height)]
    CGFloat newWidth = size * layer.boundingBox.size.width;
    CGFloat newHeight = size * (layer.boundingBox.size.height/4);
    [sprite setScaleX: (newWidth/sprite.contentSize.width)];
    [sprite setScaleY: (newHeight/sprite.contentSize.height)];
    NSLog(@"%f s content size", newWidth);
    NSLog(@"%f is content size", newHeight);
    
}



@end
