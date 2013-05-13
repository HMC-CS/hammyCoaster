//
//  LevelLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
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

#import "AppController.h"
#import "GameManager.h"

@interface LevelLayer : CCLayer {
    
    int _levelSet;                         // Level set (level notation is set-index)
    int _levelIndex;                       // Level index (level notation is set-index)
    
    LevelGenerator* _levelGenerator;       // Generates items for the given level
    
    InventoryLayer* _inventoryLayer;       // Layer containing inventory items
    PhysicsLayer* _physicsLayer;           // Layer containing level
    GameplayLayer* _gameplayLayer;         // Layer containing control buttons
    
    GameManager* _gameManager;             // Holds game data
}


/* sceneWithLevelSet:AndIndex:
 * Returns a CCScene containing LevelLayer (with level set-index) as the only child
 */
+(CCScene *) sceneWithLevelSet:(int) set AndIndex:(int) index;


/* initWithLevelSet:AndIndex:
 * Constructor for LevelLayer of level set-index
 */
-(id) initWithLevelSet:(int) set AndIndex:(int) index;


@end
