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
#import "QueryCallback.h"

@implementation PhysicsLayer


//-----INITIALIZATION-----//

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
//		_mouseJoint = NULL;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
        starCount = 0;
        starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", starCount] fontName:@"Arial" fontSize:24];
        starLabel.position = CGPointMake(300.0, 600.0);
        [self addChild:starLabel];
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        [self addInitialObjects];
		
		[self scheduleUpdate];
	}
	return self;
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
    ballStartingPoint = CGPointMake(10.0, 600.0);
}

- (void) addInitialObjects
{    
    [self addNewSpriteOfType:@"BluePortalObject" AtPosition:ccp(723.0,217.0) AsDefault:YES];
    
    [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(400.0,250.0) AsDefault:YES];
    [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(500.0,240.0) AsDefault:YES];
    [self addNewSpriteOfType:@"StarObject" AtPosition:ccp(600.0,230.0) AsDefault:YES];
    
    
    /* differently hacked default ramps
     * ---------------------------------------------------------------------- */
    
    //Code right out of sprite making function
    NSString* type = @"RampObject";
	PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
    [self addChild:sprite];
    CGPoint position = CGPointMake(100, 500);
    
    b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:TRUE withSprite:sprite] createBody:position];
	[sprite setPhysicsBody:body];
    [sprite setPosition: ccp(position.x,position.y)];
    
    //rotate ramp
    body->SetTransform(b2Vec2(600/PTM_RATIO,191.3/PTM_RATIO), .7);
    

    
    
    //		// Code kept around for later
    //        #if 1
    //        		// Use batch node. Faster
    //        		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
    //        		spriteTexture_ = [parent texture];
    //        #else
    //        		// doesn't use batch node. Slower
    //        		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
    //        		CCNode *parent = [CCNode node];
    //        #endif
    //        		[self addChild:parent z:0 tag:kTagParentNode];
    //
    //		[self addNewSpriteOfType:@"BallObject" AtPosition:ccp(size.width/2, size.height/2)];
    //
    //		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
    //		[self addChild:label z:0];
    //		[label setColor:ccc3(0,0,255)];
    //		label.position = ccp( size.width/2, size.height-50);
}


//-----GAME METHODS-----//

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p AsDefault:(bool)isDefault
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	//CCNode *parent = [self getChildByTag:kTagParentNode]; //This line isn't necessary?
    
	PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
    [self addChild:sprite];
    //[sprite setPTMRatio:PTM_RATIO];
    
    b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:isDefault withSprite:sprite] createBody:p];
	[sprite setPhysicsBody:body];
    [sprite setPosition: ccp(p.x,p.y)];
}

-(void)playLevel
{
    NSLog(@"Physics PlayLevel");
    [self addNewSpriteOfType:@"BallObject" AtPosition:ballStartingPoint AsDefault:NO];
    
    // disallow dragging or altering physicsLayer
    // Doesn't work:
    //     * setTouchEnabled FALSE
    //     * Iterating through the children and setting them to default
    // Other option: setting a clear, touch-absorbing layer over the physics layer
    
}

-(void) addObjectOfType:(NSString *)type
{
    [self addNewSpriteOfType:type AtPosition:ccp(-150, 400) AsDefault:NO];
//    [self ccTouchBegan: withEvent:]
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else {
        _selector2 = action;
    }
}

-(void) gameWon
{
    [_target performSelector:_selector2];
}

-(void) hitStar:(b2Body*) starBody
{
    //increment the star counter
    ++starCount;
    [starLabel setString:[NSString stringWithFormat:@"Stars: %d", starCount]];
    
    // delete the star sprite
    AbstractGameObject* starBodyObject = static_cast<AbstractGameObject*>(starBody->GetUserData());
    CCSprite* sprite = [starBodyObject getSprite];
    [self removeChild: sprite cleanup:YES];
    // delete the star body
        // (this doesn't actually happen 'till end of collision because
        //  hitStar is called inside a callback, but it doesn't seem to matter.)
    world->DestroyBody(starBody);
    NSLog(@"hitStar in PhysicsLayer, starcount: %d", starCount);
}

- (NSString*) getObjectType
{
    return [_target performSelector:_selector1];
}

//-----BUILT-IN/BOX 2D-----//

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
        [self gameWon];
    }
    if (_contactListener->contactStar != NULL) {
        [self hitStar:(_contactListener->contactStar)];
        _contactListener->contactStar = NULL;
    }
    
}


-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


//-----TOUCHING WITH DRAGGING-----//

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Physics touch began");
    if ([[self getObjectType] isEqualToString:@"None"]) {
        //Get tap location and convert to cocos2d-box2d coordinates
        CGPoint touchLocation = [touch locationInView:[touch view]];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
        // Make a small box.
        b2AABB aabb;
        b2Vec2 d;
        d.Set(0.001f, 0.001f);
        aabb.lowerBound = location - d;
        aabb.upperBound = location + d;
    
        // Query the world for overlapping shapes.
        QueryCallback callback(location);
        world->QueryAABB(&callback, aabb);
    
        b2Body* body = callback.m_object;
    
        if (body) {
            AbstractGameObject* bodyObject = static_cast<AbstractGameObject*>(body->GetUserData());
            if (!bodyObject->_isDefault && _editMode) {
                // calculate the offset between the touch and the center of the object
                b2Vec2 bodyLocation = body->GetPosition();
                xOffset = bodyLocation.x - location.x;
                yOffset = bodyLocation.y - location.y;
                body->SetType(b2_staticBody);
                currentMoveableBody = body;
            }
        }
    }
    return YES;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Physics touch moved");
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    if (currentMoveableBody != NULL) {
        b2Vec2 newPos = b2Vec2(location.x + xOffset, location.y + yOffset);
        currentMoveableBody->SetTransform(newPos,currentMoveableBody->GetAngle());
    }    
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Physics touch cancelled");
    currentMoveableBody = NULL;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Physics touch ended");
    
    //Add a new body/atlas sprite at the touched location
    CGPoint location = [touch locationInView: [touch view]];
    
    if (CGRectContainsPoint(self.boundingBox, location)) {
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        location = [self convertToNodeSpace:location];
        
        //NSLog(@"(%f,%f)", location.x, location.y);
        
        // get object type from inventory
        NSString* objectType = [self getObjectType];
        
        if(objectType && ![objectType isEqualToString:@"None"]){
            [self addNewSpriteOfType:objectType AtPosition: location AsDefault:NO];
        }
    }
    
    currentMoveableBody = NULL;
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

@end
