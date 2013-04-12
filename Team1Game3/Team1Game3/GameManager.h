//
//  GameManager.h
//  Team1Game3
//
//  Created by jarthur on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "CCNode.h"

@interface GameManager : CCNode {
    int _numLevelSets;
    int _numLevelIndices;
    
    int _numLevelsCompleted;
    NSMutableArray* _levelCompletionStatuses;
}

@property (readonly) int numLevelSets;
@property (readonly) int numLevelIndices;

/* isLevelCompletedAtLevelSet:AndIndex:
 * returns whether a given level has been completed 
 * (true = previously completed, false = not)
 */
-(bool) isLevelCompletedAtLevelSet: (int) set AndIndex: (int) index;

/* registerCompletedLevelWithLevelSet:AndIndex:
 * registers a level as completed with the GameManager when it is beaten
 */
-(void) registerCompletedLevelWithLevelSet:(int)set AndIndex:(int)index;

@end
