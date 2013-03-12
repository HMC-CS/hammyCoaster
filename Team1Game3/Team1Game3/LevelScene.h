//
//  LevelScene.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "CCScene.h"

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ObjectFactory.h"

@interface LevelScene : CCScene

//temp function for inventoryto call on physicslayer
-(void) dropBall;

+(CCScene *) scene;

@end
