//
//  Team1Game3Tests.m
//  Team1Game3Tests
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/24/13.
//
//

#import "Team1Game3Tests.h"

@implementation Team1Game3UnitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    //STAssertTrue(NO, @"no");
    
    b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
    
    ball = [[BallObject alloc] initWithWorld:world asDefault:NO withTag:@"BallObject"];
    ramp = [[RampObject alloc] initWithWorld:world asDefault:YES withTag:@"RampObject"];
    bluePortal = [[BluePortalObject alloc] initWithWorld:world asDefault:YES withTag:@"BluePortalObject"];
    abstractBall = [[BallObject alloc] initWithWorld:world asDefault:NO withTag:@"BallObject"];
    
    levelLayer = [[LevelLayer alloc] init];
    inventoryLayer = [[InventoryLayer alloc] init];
    physicsLayer = [[PhysicsLayer alloc] init];
    mainMenuLayer = [[MainMenuLayer alloc] init];
}

-(void)checkNotNil
{
    STAssertNotNil(ball, @"ball is nil");
    STAssertNotNil(ramp, @"ramp is nil");
    STAssertNotNil(bluePortal, @"bluePortal is nil");
    STAssertNotNil(abstractBall, @"abstractBall is nil");
    
    STAssertNotNil(levelLayer, @"levelLayer is nil");
    STAssertNotNil(inventoryLayer, @"inventoryLayer is nil");
    STAssertNotNil(physicsLayer, @"physicsLayer is nil");
    STAssertNotNil(mainMenuLayer, @"mainMenuLayer is nil");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//- (void)testExample
//{
//    STFail(@"Unit tests are not implemented yet in Team1GameUnitTests");
//}

@end

