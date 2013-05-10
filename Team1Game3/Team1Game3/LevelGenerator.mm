//
//  LevelGenerator.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LevelGenerator.h"

#import "JSONKit.h"

@implementation LevelGenerator

-(id) init
{
    if (self = [super init]) {
        _gameManager = [(AppController*)[[UIApplication sharedApplication] delegate] gameManager];
    }
    
    return self;
}

-(NSMutableArray*) generateObjectsInSet:(int)set WithIndex:(int)index
{
    NSAssert1(set > 0 && set <= _gameManager.numLevelSets, @"Invalid set index %d given in LevelGenerator.", set);
    NSAssert1(index > 0 && index <= _gameManager.numLevelIndices, @"Invalid level index %d given in LevelGenerator.", index);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"InitialObjects" ofType:@"json"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    JSONDecoder* decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSArray* json = [decoder objectWithData:jsonData];
    
    NSMutableArray* returnedObjects = [[NSMutableArray alloc] init];
    
    NSString* levelString = [[NSString alloc] initWithFormat:@"%02d%02d", set, index];
    
    for (NSDictionary* level in json) {
        if ([[level objectForKey:@"level"] isEqualToString:levelString])
        {
            NSArray* levelObjects = [level objectForKey:@"objects"];
            for (NSArray* object in levelObjects) {
                [returnedObjects addObject:object];
            }
            break;
        }
    }
    
    // If level is not specified in file.
    if ([returnedObjects count] == 0)
    {
        // Default to first level if unspecified.
        NSDictionary* level = [json objectAtIndex:0];
        
        NSArray* levelObjects = [level objectForKey:@"objects"];
        for (NSArray* object in levelObjects) {
            [returnedObjects addObject:object];
        }
    }
    
    return returnedObjects;
}

-(NSMutableArray*) generateInventoryInSet:(int)set WithIndex:(int)index
{
    
    NSAssert1(set > 0 && set <= _gameManager.numLevelSets, @"Invalid set index %d given.", set);
    NSAssert1(index > 0 && index <= _gameManager.numLevelIndices, @"Invalid level index %d given.", index);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"InitialObjects" ofType:@"json"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    JSONDecoder* decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSArray* json = [decoder objectWithData:jsonData];
    
    NSMutableArray* returnedInventory = [[NSMutableArray alloc] init];
    
    NSString* levelString = [[NSString alloc] initWithFormat:@"%02d%02d", set, index];
    
    for (NSDictionary* level in json) {
        if ([[level objectForKey:@"level"] isEqualToString:levelString])
        {
            NSArray* levelObjects = [level objectForKey:@"inventory"];
            for (NSArray* object in levelObjects) {
                [returnedInventory addObject:object];
            }
            break;
        }
    }
    
    // If level is not specified in file.
    if ([returnedInventory count] == 0)
    {
        // Default to first level if unspecified.
        NSDictionary* level = [json objectAtIndex:0];
        
        NSArray* levelObjects = [level objectForKey:@"inventory"];
        for (NSArray* object in levelObjects) {
            [returnedInventory addObject:object];
        }
    }
    
    return returnedInventory;
}


@end
