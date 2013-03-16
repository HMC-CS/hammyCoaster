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

@implementation PhysicsLayer

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		_mouseJoint = NULL;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
//        CGSize size = [self contentSize];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        [self addNewSpriteOfType:@"BallObject" AtPosition:ccp([self contentSize].width/2, 0) AsDefault:NO];
        
        [self addNewSpriteOfType:@"BluePortalObject" AtPosition:ccp(723.0,217.0) AsDefault:YES];
		
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
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
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
    
    
    // hacked default ramps
    
    
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
        [_target performSelector:_selector2];
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

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
	
        NSString* objectType = [_target performSelector:_selector1];
    
        if(objectType && ![objectType isEqualToString:@"None"]){
            [self addNewSpriteOfType:objectType AtPosition: location AsDefault:NO];
        }
    }
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target=sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else {
        _selector2 = action;
    }
}

//-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    NSLog(@"Physics touch began");
//
//    return YES;
//}
//
//-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    NSLog(@"Physics touch ended");
//}

////-----TOUCHING WITH DRAGGING-----//
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"Physics touches began");
//    for (b2Body* body = world->GetBodyList(); body; body = body->GetNext()) {
//        if (_mouseJoint != NULL) return NO;
//    
////        UITouch *myTouch = [touches anyObject];
//        CGPoint location = [touch locationInView:[touch view]];
//        location = [[CCDirector sharedDirector] convertToGL:location];
//        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    
//        b2Fixture* f = body->GetFixtureList();
//        
//        if (f->TestPoint(locationWorld)) {
//            NSLog(@"Touch in object");
//            b2MouseJointDef md;
//            md.bodyA = body;
////            md.bodyB = _paddleBody;
//            md.target = locationWorld;
////            md.collideConnected = true;
//            md.maxForce = 1000.0f * body->GetMass();
//        
//            _mouseJoint = (b2MouseJoint *) world->CreateJoint(&md);
//            body->SetAwake(true);
//            
//        }
//    }
//    return YES;
//}
//
//-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"Physics touches moved");
//    if (_mouseJoint == NULL) return;
//    
////    UITouch *myTouch = [touches anyObject];
//    CGPoint location = [touch locationInView:[touch view]];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    
//    _mouseJoint->SetTarget(locationWorld);
//    
//}
//
//-(void)ccTouchCancelled:(UITouch *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Physics touches cancelled");
//    if (_mouseJoint) {
//        world->DestroyJoint(_mouseJoint);
//        _mouseJoint = NULL;
//    }
//    
//}
//
//- (void)ccTouchEnded:(UITouch *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Physics touches ended");
//    if (_mouseJoint) {
//        world->DestroyJoint(_mouseJoint);
//        _mouseJoint = NULL;
//    }
//}

@end
