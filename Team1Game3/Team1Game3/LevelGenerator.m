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

-(NSMutableArray*) generateLevel
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"InitialObjects" ofType:@"json"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    JSONDecoder* decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSArray* json = [decoder objectWithData:jsonData];
    
    NSMutableArray* returnedObjects = [[NSMutableArray alloc] init];
    
    for (NSDictionary* level in json) {
        if ([[level objectForKey:@"level"] isEqualToString:@"0101"])
        {
            NSArray* levelObjects = [level objectForKey:@"objects"];
            for (NSArray* object in levelObjects) {
                [returnedObjects addObject:object];
            }
            break;
        }
    }
    
    
//    [objects addObject:[[NSMutableArray alloc] initWithObjects:@"BluePortalObject", @"723.0", @"217.0", @"0",nil]];
//    [objects addObject:[[NSMutableArray alloc] initWithObjects:@"StarObject", @"400.0", @"250.0", @"0",nil]];
//    [objects addObject:[[NSMutableArray alloc] initWithObjects:@"StarObject", @"500.0", @"240.0", @"0",nil]];
//    [objects addObject:[[NSMutableArray alloc] initWithObjects:@"StarObject", @"600.0", @"230.0", @"0",nil]];
//    [objects addObject:[[NSMutableArray alloc] initWithObjects:@"RampObject", @"578.0", @"160.0", @"0.7",nil]];
    
    return returnedObjects;
}


//[self addNewSpriteOfType:@"BluePortalObject" AtPosition:ccp(723.0,217.0) AsDefault:YES];
//
//[self addNewSpriteOfType:@"StarObject" AtPosition:ccp(400.0,250.0) AsDefault:YES];
//[self addNewSpriteOfType:@"StarObject" AtPosition:ccp(500.0,240.0) AsDefault:YES];
//[self addNewSpriteOfType:@"StarObject" AtPosition:ccp(600.0,230.0) AsDefault:YES];
//[self addNewSpriteOfType:@"RampObject" AtPosition:ccp(578.0,160.0) WithRotation:0.7 AsDefault:YES];
//
//
///* differently hacked default ramps
// * ---------------------------------------------------------------------- */
//
////Code right out of sprite making function
//NSString* type = @"RampObject";
//PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
//[self addChild:sprite];
//CGPoint position = CGPointMake(100, 500);
//
//b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:TRUE withSprite:sprite] createBody:position];
//[sprite setPhysicsBody:body];
//[sprite setPosition: ccp(position.x,position.y)];
//
////rotate ramp
//body->SetTransform(b2Vec2(605/PTM_RATIO,191/PTM_RATIO), 0.7);

@end
