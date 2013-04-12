//
//  LevelGenerator.h
//  Team1Game3
//
//  Created by jarthur on 3/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppDelegate.h"

@interface LevelGenerator : CCNode {
    
    AppController* _appController;
    
}

/* generateObjectsInSet:WithIndex:
 Returns the objects in level Set-Index */
-(NSMutableArray*) generateObjectsInSet:(int) set WithIndex:(int) index;

/* generateInventoryInSet:WithIndex:
 Returns the inventory in level Set-Index */
-(NSMutableArray*) generateInventoryInSet:(int) set WithIndex:(int) index;

@end
