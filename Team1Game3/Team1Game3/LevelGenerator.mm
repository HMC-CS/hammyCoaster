//
//  LevelGenerator.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/31/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "LevelGenerator.h"

#import "JSONKit.h"

@implementation LevelGenerator

-(id) init
{
    if (self = [super init]) {
        
        // The game manager is the same as the AppController's game manager
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
    }
    
    return self;
}


-(NSMutableArray*) generateObjectsInSet:(int)set WithIndex:(int)index
{
    return [self loadItemsForLocation:@"objects" ForLevelSet:set AndIndex:index];
}

-(NSMutableArray*) generateInventoryInSet:(int)set WithIndex:(int)index
{
    return [self loadItemsForLocation:@"inventory" ForLevelSet:set AndIndex:index];
}


/* ////////////////////////////// Private Functions ////////////////////////////// */

/* loadItemsForLocation:ForLevelSet:AndIndex:
 * Loads items from file for either inventory or playing board given the level set and index
 * Returns an array of the items
 */
-(NSMutableArray*) loadItemsForLocation: (NSString*) location ForLevelSet: (int) set AndIndex: (int) index
{
    NSAssert1(set > 0 && set <= _gameManager.numLevelSets, @"Invalid set index %d given.", set);
    NSAssert1(index > 0 && index <= _gameManager.numLevelIndices, @"Invalid level index %d given.", index);
    NSAssert1([location isEqualToString:@"objects"] || [location isEqualToString:@"inventory"], @"Invalid object generation location %@ given", location);
    
    // Load file and data
    NSString* path = [[NSBundle mainBundle] pathForResource:@"InitialObjects" ofType:@"json"];
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    JSONDecoder* decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSArray* json = [decoder objectWithData:jsonData];
    
    // Array to hold objects read from file
    NSMutableArray* returnedItems = [[NSMutableArray alloc] init];
    
    // String representing level
    NSString* levelString = [[NSString alloc] initWithFormat:@"%02d%02d", set, index];
    
    // Add objects from file
    for (NSDictionary* level in json) {
        if ([[level objectForKey:@"level"] isEqualToString:levelString]) {
            NSArray* levelObjects = [level objectForKey:location];
            for (NSArray* object in levelObjects) {
                [returnedItems addObject:object];
            }
            break;
        }
    }
    
    // In case level is not specified in file, default to first level
    if ([returnedItems count] == 0) {
        NSDictionary* level = [json objectAtIndex:0];
        NSArray* levelObjects = [level objectForKey:location];
        for (NSArray* object in levelObjects) {
            [returnedItems addObject:object];
        }
    }
    
    return returnedItems;
}

@end
