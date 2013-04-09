//
//  LevelLayer.h
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
#import "InventoryLayer.h"
#import "PhysicsLayer.h"
#import "LevelGenerator.h"
#import "GameplayLayer.h"

@interface LevelLayer : CCLayer {
    InventoryLayer* _inventoryLayer;
    PhysicsLayer* _physicsLayer;
    GameplayLayer* _gameplayLayer;
    
    int _levelSet;
    int _levelIndex;
    
    LevelGenerator* _levelGenerator;
}

/* sceneWithLevelSet:AndIndex:
 * returns a CCScene containing LevelLayer (with Level Set-Index) as the only child
 */
-(id) initWithLevelSet:(int) set AndIndex:(int) index;

/* sceneWithLevelSet:AndIndex:
 * returns a CCScene containing LevelLayer (with Level Set-Index) as the only child
 */
+(CCScene *) sceneWithLevelSet:(int) set AndIndex:(int) index;

-(void) updateStarCount;

@end
