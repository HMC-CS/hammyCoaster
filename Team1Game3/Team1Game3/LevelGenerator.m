//
//  LevelGenerator.m
//  Team1Game3
//
//  Created by jarthur on 3/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LevelGenerator.h"

#import "JSONKit.h"


@implementation LevelGenerator

-(NSMutableArray*) generateObjectsInSet:(int)set WithIndex:(int)index
{
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
    
    return returnedObjects;
}

-(NSMutableArray*) generateInventoryInSet:(int)set WithIndex:(int)index
{
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
    
    return returnedInventory;
}


@end
