//
//  PhysicsLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//


// NOTES:
// CCTouchEnded: make sure to do bounds checking here so ball is not added in inventory

#import "PhysicsLayer.h"
#import "InventoryLayer.h"

#import "PhysicsSprite.h"

// We need this for dragging.
// TODO: Move this to its own file once we're sure this way of dragging will work.
class QueryCallback : public b2QueryCallback
{
public:
    QueryCallback(const b2Vec2& point)
    {
        m_point = point;
        m_object = nil;
    }
    
    bool ReportFixture(b2Fixture* fixture)
    {
        if (fixture->IsSensor()) return true; //ignore sensors
        
        bool inside = fixture->TestPoint(m_point);
        if (inside)
        {
            // We are done, terminate the query.
            m_object = fixture->GetBody();
            return false;
        }
        
        // Continue the query.
        return true;
    }
    
    b2Vec2  m_point;
    b2Body* m_object;
};

@implementation PhysicsLayer

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
//		_mouseJoint = NULL;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
//        CGSize size = [self contentSize];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        // Ball to test dragging with
        PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",@"RampObject"]];
        [self addChild:sprite];
        
        draggingBall = [[_objectFactory objectFromString:@"RampObject" forWorld:world asDefault:NO] createBody:ccp([self contentSize].width/2,0)];
        [sprite setPhysicsBody:draggingBall];
        [sprite setPosition: ccp([self contentSize].width/2,0)];
//        [self addNewSpriteOfType:@"BallObject" AtPosition:ccp([self contentSize].width/2, 0) AsDefault:NO];
        
        [self addNewSpriteOfType:@"BallObject" AtPosition:ccp(300.0, 300.0) AsDefault:NO];
        
        [self addNewSpriteOfType:@"BluePortalObject" AtPosition:ccp(723.0,217.0) AsDefault:YES];
        
        [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(400.0,250.0) AsDefault:YES];
        [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(500.0,240.0) AsDefault:YES];
        [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(600.0,230.0) AsDefault:YES];


		
        //#if 1
        //		// Use batch node. Faster
        //		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
        //		spriteTexture_ = [parent texture];
        //#else
        //		// doesn't use batch node. Slower
        //		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
        //		CCNode *parent = [CCNode node];
        //#endif
        //		[self addChild:parent z:0 tag:kTagParentNode];
		
		//[self addNewSpriteOfType:@"BallObject" AtPosition:ccp(size.width/2, size.height/2)];
//		
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
//		[self addChild:label z:0];
//		[label setColor:ccc3(0,0,255)];
//		label.position = ccp( size.width/2, size.height-50);
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        world->DestroyBody(b);
    }
	
	[super dealloc];
}

-(void) initPhysics
{
	
	CGSize s = [self contentSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
    
    // For collision callbacks
    _contactListener = new ContactListener();
    world->SetContactListener(_contactListener);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    
    //Claire:Comment out this line to disable debug draw
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    
    
    /* hacked default ramps
     * ---------------------------------------------------------------------- */
    
    // Starting ramp
    b2BodyDef rampBodyDef;
    rampBodyDef.position.Set(0/PTM_RATIO,100/PTM_RATIO);
    
    b2Body *rampBody = world->CreateBody(&rampBodyDef);
    b2EdgeShape rampEdge;
    b2FixtureDef rampShapeDef;
    rampShapeDef.shape = &rampEdge;
    
    // ramp definitions
    rampEdge.Set(b2Vec2(0/PTM_RATIO,450/PTM_RATIO), b2Vec2(s.width/(4*PTM_RATIO), 400/PTM_RATIO));
    rampBody->CreateFixture(&rampShapeDef);
    
    //Ending Ramp
    b2BodyDef ramp2BodyDef;
    ramp2BodyDef.position.Set(0/PTM_RATIO,100/PTM_RATIO);
    
    b2Body *ramp2Body = world->CreateBody(&ramp2BodyDef);
    b2EdgeShape ramp2Edge;
    b2FixtureDef ramp2ShapeDef;
    ramp2ShapeDef.shape = &ramp2Edge;
    
    // ramp2 definitions
    ramp2Edge.Set(b2Vec2(s.width*2/(4*PTM_RATIO),150/PTM_RATIO), b2Vec2(s.width/PTM_RATIO, 100/PTM_RATIO));
                 ramp2Body->CreateFixture(&ramp2ShapeDef);
    
    /* hacked ball starting position
     * ---------------------------------------------------------------------- */
    ballStartingPoint = CGPointMake(10/PTM_RATIO, 500/PTM_RATIO);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p AsDefault:(bool)isDefault
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	//CCNode *parent = [self getChildByTag:kTagParentNode]; //This line isn't necessary?
    
    
	PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
	//[parent addChild:sprite]; //This line isn't necessary?
    [self addChild:sprite];
    //[sprite setPTMRatio:PTM_RATIO];
    
    b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:isDefault] createBody:p];
	[sprite setPhysicsBody:body];
    [sprite setPosition: ccp(p.x,p.y)];
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    if (_contactListener->gameWon) {
        _contactListener->gameWon = false;
        [_target1 performSelector:_selector2];
    }
}

//-(void) gameWon
//{
//    //This congratulates the user if he wins the game.
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS, YOU'VE WON!"
//                                                    message:@"Play Again?"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Yes!"
//                                          otherButtonTitles:@"No, thanks.", nil];
//    alert.tag=1;
//    [alert show];
//    
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    //if the user was sure he wanted a new game, this asks the user how difficult
//    //he wants his new game to be.  It then loads a game of the selected difficulty.
//    if (alertView.tag==1){
//        if (buttonIndex == [alertView cancelButtonIndex]) {
//            [[CCDirector sharedDirector] pushScene:[LevelLayer scene]];
//        }
//        else {
//            [[CCDirector sharedDirector] pushScene:[MainMenuLayer scene]];
//        }
//    }
//}

-(void)playLevel
{
    
}

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target1=sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else {
        _selector2 = action;
    }
}

//-----TOUCHING WITH NO DRAGGING-----//

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Physics touch began");
    
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"physics ended");
	//Add a new body/atlas sprite at the touched location
    CGPoint location = [touch locationInView: [touch view]];
    
    if (CGRectContainsPoint(self.boundingBox, location)) {
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        location = [self convertToNodeSpace:location];
        
        //NSLog(@"(%f,%f)", location.x, location.y);
	
        // get object type from inventory
        NSString* objectType = [_target1 performSelector:_selector1];
    
        if(objectType && ![objectType isEqualToString:@"None"]){
            [self addNewSpriteOfType:objectType AtPosition: location AsDefault:NO];
        }
    }
}


////-----TOUCHING WITH DRAGGING-----//
//-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"Physics touch began");
//    
//    //Get tap location and convert to cocos2d-box2d coordinates
//    CGPoint touchLocation = [touch locationInView:[touch view]];
//    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
//    touchLocation = [self convertToNodeSpace:touchLocation];
//    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
//    
//    // Make a small box.
//    b2AABB aabb;
//    b2Vec2 d;
//    d.Set(0.001f, 0.001f);
//    aabb.lowerBound = locationWorld - d;
//    aabb.upperBound = locationWorld + d;
//    
//    // Query the world for overlapping shapes.
//    QueryCallback callback(locationWorld);
//    world->QueryAABB(&callback, aabb);
//    
//    b2Body* body = callback.m_object;
//    
//    // TODO: check draggability -- need to get Object from b2Body
//    if (body)
//    {
////        anchorPoint = ccpSub(locationWorld, CGPointMake(body->GetPosition().x*PTM_RATIO, body->GetPosition().y+PTM_RATIO));
////        anchorPoint = locationWorld;
//        body->SetType(b2_staticBody);
//        currentMoveableBody = body;
//    }
//    return YES;
//}
//-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    NSLog(@"Physics touch moved");
//    CGPoint location = [touch locationInView:[touch view]];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    if (currentMoveableBody != NULL) {
////        anchorPoint = ccpSub(location, CGPointMake(currentMoveableBody->GetPosition().x*PTM_RATIO, currentMoveableBody->GetPosition().y*PTM_RATIO));
////        CGPoint newPos = ccpAdd(location,anchorPoint);
//        
//        currentMoveableBody->SetTransform(b2Vec2(location.x/PTM_RATIO,location.y/PTM_RATIO),currentMoveableBody->GetAngle());
//    }    
//}
//
//-(void)ccTouchCancelled:(UITouch *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Physics touch cancelled");
////    if (_mouseJoint) {
////        world->DestroyJoint(_mouseJoint);
////        _mouseJoint = NULL;
////    }
//    currentMoveableBody = NULL;
//}
//
//- (void)ccTouchEnded:(UITouch *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Physics touch ended");
////    if (_mouseJoint) {
////        world->DestroyJoint(_mouseJoint);
////        _mouseJoint = NULL;
////    }
//    currentMoveableBody = NULL;
//}

@end
