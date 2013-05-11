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
    
    NSUserDefaults* _defaults;      // Stores user information
    
    int _numLevelSets;              // Number of level "packs"
    int _numLevelIndices;           // Number of levels per "pack"
    int _numLevelsCompleted;        // Counts number of levels completed
    
    NSMutableArray* _levelCompletionStatuses;   // Tracks if levels are completed
    NSMutableArray* _levelHighScores;           // Tracks max stars obtained in each level
    NSMutableArray* _isLevelLocked;             // Tracks if user is allowed to play level
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

/* isLevelLockedAtLevelSet:AndIndex:
 * returns whether a user is allowed to play a particular level
 */
-(bool) isLevelLockedAtLevelSet:(int)set AndIndex:(int)index;

@end
