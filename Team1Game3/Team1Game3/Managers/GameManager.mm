//
//  GameManager.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/12/13.
//
//

#import "GameManager.h"

#import "OverallWinLayer.h"

@implementation GameManager

-(id) init
{
    if (self = [super init]) {
        [self loadGame];
        
        // Control the number of levels with these variables.
        _numLevelSets = 2;
        _numLevelIndices = 12;
        
        // Load level and game information using NSUserDefaults
        
        _numLevelsCompleted = [_defaults integerForKey:@"levels_complete"];
        
        _levelCompletionStatuses = [[NSMutableArray alloc] init];
        _levelHighScores = [[NSMutableArray alloc] init];
        _isLevelLocked = [[NSMutableArray alloc] init];
        for (int i = 0; i < _numLevelSets * _numLevelIndices; ++i) {
            // Load level information using NSUserDefaults
            bool levelComplete = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_complete", i]];
            bool levelLocked = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_locked", i]];
            int levelStars = [_defaults integerForKey:[NSString stringWithFormat:@"level_%d_stars", i]];
            
            // Store level information
            
            if (levelComplete) {
                [_levelCompletionStatuses addObject:@"true"];
            } else {
                [_levelCompletionStatuses addObject:@"false"];
            }
            
            [_levelHighScores addObject:[NSNumber numberWithInt:levelStars]];
            
            if (levelLocked) {
                [_isLevelLocked addObject:@"true"];
            } else{
                [_isLevelLocked addObject:@"false"];
            }
        }
    }
    
    return self;
}


-(void) resetUserData
{
    // Load NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self loadGame];
    
    _numLevelsCompleted = [_defaults integerForKey:@"levels_complete"];
    
    // Read data from NSUserDefaults and put it in local storage
    for (int i = 0; i < _numLevelSets * _numLevelIndices; ++i) {
        
        bool levelComplete = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_complete", i]];
        bool levelLocked = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_locked", i]];
        int levelStars = [_defaults integerForKey:[NSString stringWithFormat:@"level_%d_stars", i]];
        
        // Has the user won the level before?
        if (levelComplete) {
            [_levelCompletionStatuses replaceObjectAtIndex: i withObject:@"true"];
        } else {
            [_levelCompletionStatuses replaceObjectAtIndex: i withObject:@"false"];
        }
        
        // Is the user allowed to play the level?
        if(levelLocked) {
            [_isLevelLocked replaceObjectAtIndex: i withObject:@"true"];
        } else {
            [_isLevelLocked replaceObjectAtIndex: i withObject:@"false"];
        }
        
        // Highest number of stars obtained?
        [_levelHighScores setObject:[NSNumber numberWithInt:levelStars] atIndexedSubscript:i];
    }
}


-(bool) isLevelCompletedAtLevelSet:(int)set AndIndex:(int)index
{
    NSAssert1(set > 0 && set <= _numLevelSets, @"Invalid set index %d given in AppController.", set);
    NSAssert1(index > 0 && index <= _numLevelIndices, @"Invalid level index %d given in AppController.", index);
    
    if ([[_levelCompletionStatuses objectAtIndex:(set-1)*_numLevelIndices + (index-1)] isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}


-(void) registerCompletedLevelWithLevelSet:(int)set AndIndex:(int)index AndStarCount:(int)stars
{
    NSAssert1(set > 0 && set <= _numLevelSets, @"Invalid set index %d given in AppController.", set);
    NSAssert1(index > 0 && index <= _numLevelIndices, @"Invalid level index %d given in AppController.", index);
    
    int arrayIndex = [self arrayIndexForLevelSet:set AndIndex:index];

    
    // Update high scores
    if (stars > [[_levelHighScores objectAtIndex:arrayIndex] intValue]) {
        [_levelHighScores setObject:[NSNumber numberWithInt:stars] atIndexedSubscript:arrayIndex];
        [_defaults setInteger:stars forKey:[NSString stringWithFormat:@"level_%d_stars", arrayIndex]];
    }
    
    
    // Update level completion data
    
    if ([[_levelCompletionStatuses objectAtIndex:arrayIndex] isEqualToString:@"false"]) {
        
        // Update level status if level wasn't previously completed.
        [_levelCompletionStatuses setObject:@"true" atIndexedSubscript:arrayIndex];
        [_defaults setBool:YES forKey:[NSString stringWithFormat:@"level_%d_complete", arrayIndex]];
        ++_numLevelsCompleted;
        [_defaults setInteger:_numLevelsCompleted forKey:@"levels_complete"];
        
        // If you've completed all the levels, you win.
        if (_numLevelsCompleted == _numLevelSets * _numLevelIndices) {
            ++_numLevelsCompleted; // So you only get the win screen once.
            [[CCDirector sharedDirector] pushScene: [OverallWinLayer scene]];
        }
        
        // Unlock one new level.
        for (int i = arrayIndex; i < _numLevelSets * _numLevelIndices; ++i) {
            if ([[_isLevelLocked objectAtIndex:i] isEqualToString: @"true"]) {
                [_isLevelLocked setObject:@"false" atIndexedSubscript:i];
                [_defaults setBool:NO forKey:[NSString stringWithFormat:@"level_%d_locked", i]];
                return;
            }
        }
    }
}


-(int) highScoreAtLevelSet:(int)set AndIndex:(int)index
{
    int arrayIndex = [self arrayIndexForLevelSet:set AndIndex:index];
    return [[_levelHighScores objectAtIndex:arrayIndex] intValue];
}


-(bool) isLevelLockedAtLevelSet:(int)set AndIndex:(int)index
{
    int arrayIndex = [self arrayIndexForLevelSet:set AndIndex:index];
    if ([[_isLevelLocked objectAtIndex:arrayIndex] isEqualToString: @"true"]) {
        return YES;
    } else {
        return NO;
    }
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* loadGame
 * Loads the default data
 * Function from http://cocoadev.com/wiki/WorkingWithUserDefaults
 */
-(void) loadGame
{
    _defaults = [NSUserDefaults standardUserDefaults];
    
    [_defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"0",          @"levels_complete",
                                 @"NO",         @"level_0_locked",
                                 @"NO",         @"level_1_locked",
                                 @"YES",        @"level_2_locked",
                                 @"YES",        @"level_3_locked",
                                 @"YES",        @"level_4_locked",
                                 @"YES",        @"level_5_locked",
                                 @"YES",        @"level_6_locked",
                                 @"YES",        @"level_7_locked",
                                 @"YES",        @"level_8_locked",
                                 @"YES",        @"level_9_locked",
                                 @"YES",        @"level_10_locked",
                                 @"YES",        @"level_11_locked",
                                 @"YES",        @"level_12_locked",
                                 @"YES",        @"level_13_locked",
                                 @"YES",        @"level_14_locked",
                                 @"YES",        @"level_15_locked",
                                 @"YES",        @"level_16_locked",
                                 @"YES",        @"level_17_locked",
                                 @"YES",        @"level_18_locked",
                                 @"YES",        @"level_19_locked",
                                 @"YES",        @"level_20_locked",
                                 @"YES",        @"level_21_locked",
                                 @"YES",        @"level_22_locked",
                                 @"YES",        @"level_23_locked",
                                 @"YES",        @"level_24_locked",
                                 @"NO",         @"level_0_complete",
                                 @"NO",         @"level_1_complete",
                                 @"NO",         @"level_2_complete",
                                 @"NO",         @"level_3_complete",
                                 @"NO",         @"level_4_complete",
                                 @"NO",         @"level_5_complete",
                                 @"NO",         @"level_6_complete",
                                 @"NO",         @"level_7_complete",
                                 @"NO",         @"level_8_complete",
                                 @"NO",         @"level_9_complete",
                                 @"NO",         @"level_10_complete",
                                 @"NO",         @"level_11_complete",
                                 @"NO",         @"level_12_complete",
                                 @"NO",         @"level_13_complete",
                                 @"NO",         @"level_14_complete",
                                 @"NO",         @"level_15_complete",
                                 @"NO",         @"level_16_complete",
                                 @"NO",         @"level_17_complete",
                                 @"NO",         @"level_18_complete",
                                 @"NO",         @"level_19_complete",
                                 @"NO",         @"level_20_complete",
                                 @"NO",         @"level_21_complete",
                                 @"NO",         @"level_22_complete",
                                 @"NO",         @"level_23_complete",
                                 @"NO",         @"level_24_complete",
                                 @"0",          @"level_0_stars",
                                 @"0",          @"level_1_stars",
                                 @"0",          @"level_2_stars",
                                 @"0",          @"level_3_stars",
                                 @"0",          @"level_4_stars",
                                 @"0",          @"level_5_stars",
                                 @"0",          @"level_6_stars",
                                 @"0",          @"level_7_stars",
                                 @"0",          @"level_8_stars",
                                 @"0",          @"level_9_stars",
                                 @"0",          @"level_10_stars",
                                 @"0",          @"level_11_stars",
                                 @"0",          @"level_12_stars",
                                 @"0",          @"level_13_stars",
                                 @"0",          @"level_14_stars",
                                 @"0",          @"level_15_stars",
                                 @"0",          @"level_16_stars",
                                 @"0",          @"level_17_stars",
                                 @"0",          @"level_18_stars",
                                 @"0",          @"level_19_stars",
                                 @"0",          @"level_20_stars",
                                 @"0",          @"level_21_stars",
                                 @"0",          @"level_22_stars",
                                 @"0",          @"level_23_stars",
                                 @"0",          @"level_24_stars",

                                 nil]];
}

/* arrayIndexForLevelSet:AndIndex:
 * Helper function to calculate array index of a level with a given set and index.
 * Returns the array index.
 */
- (int) arrayIndexForLevelSet: (int) set AndIndex: (int) index
{
    return (set-1)*_numLevelIndices + (index-1);
}


@end
