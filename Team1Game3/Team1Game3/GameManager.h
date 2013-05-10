//
//  GameManager.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "CCNode.h"

@interface GameManager : CCNode {
    NSUserDefaults* _defaults;
    
    int _numLevelSets;
    int _numLevelIndices;
    
    int _numLevelsCompleted;
    NSMutableArray* _levelCompletionStatuses;
    NSMutableArray* _levelHighScores;
    NSMutableArray* _isLevelLocked;
}

@property (readonly) int numLevelSets;
@property (readonly) int numLevelIndices;

/* resetUserData
 * resets the user completion/unlock data
 */
-(void)resetUserData;

/* isLevelCompletedAtLevelSet:AndIndex:
 * returns whether a given level has been completed 
 * (true = previously completed, false = not)
 */
-(bool) isLevelCompletedAtLevelSet: (int) set AndIndex: (int) index;

/* registerCompletedLevelWithLevelSet:AndIndex:AndStarCount:
 * registers a level as completed with the GameManager when it is beaten
 */
-(void) registerCompletedLevelWithLevelSet:(int)set AndIndex:(int)index AndStarCount:(int)stars;

/* highScoreAtLevelSet:AndIndex:
 * returns highest star count obtained in level
 */
-(int) highScoreAtLevelSet:(int)set AndIndex:(int)index;

-(bool) isLevelLockedAtSet:(int)set AndIndex:(int)index;

@end
