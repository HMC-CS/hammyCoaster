//
//  LevelGenerator.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/31/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#ifndef LEVEL_GENERATOR_INCLUDED
#define LEVEL_GENERATOR_INCLUDED 1

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppController.h"
#import "GameManager.h"

@interface LevelGenerator : CCNode {
    
    GameManager* _gameManager;      // To get level data
    
}

/* generateObjectsInSet:WithIndex:
 * Returns the objects in level Set-Index 
 */
-(NSMutableArray*) generateObjectsInSet:(int) set WithIndex:(int) index;

/* generateInventoryInSet:WithIndex:
 * Returns the inventory in level Set-Index 
 */
-(NSMutableArray*) generateInventoryInSet:(int) set WithIndex:(int) index;

@end

#endif  // LEVEL_GENERATOR_INCLUDED
