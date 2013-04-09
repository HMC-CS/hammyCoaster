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

-(id) initWithObjects:(NSArray *)objects
{
	if( (self=[super init])) {
		
		// enable events
//		_mouseJoint = NULL;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
//        starCount = 0;
//        starLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Stars: %d", starCount] fontName:@"Arial" fontSize:24];
//        starLabel.position = CGPointMake(300.0, 600.0);
//        [self addChild:starLabel];
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        _initialObjects = objects;
        
        [self addInitialObjects];
		
		[self scheduleUpdate];
        
        _editMode = YES;
	}
	return self;
}

-(void) initPhysics
{
	
	CGSize size = [self contentSize];
	
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
    
    // NOTE: comment this line out to disable debug draw
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
	groundBox.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,0));
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
    rampEdge.Set(b2Vec2(0/PTM_RATIO,450/PTM_RATIO), b2Vec2(size.width/(4*PTM_RATIO), 400/PTM_RATIO));
    rampBody->CreateFixture(&rampShapeDef);

    /* hacked ball starting position
     * ---------------------------------------------------------------------- */
    ballStartingPoint = CGPointMake(35.0, 600.0);

}

- (void) addInitialObjects
{
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        CGFloat px = [[item objectAtIndex:1] floatValue];
        CGFloat py = [[item objectAtIndex:2] floatValue];
        CGFloat rotation = [[item objectAtIndex:3] floatValue];
        [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
    }
    
    //---test code for curved ramp---//
    [self addNewSpriteOfType:@"CurvedRampObject" AtPosition:ccp(200.0, 400.0) WithRotation:0 AsDefault:NO];    
}


//-----GAME METHODS-----//

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation AsDefault:(bool)isDefault;
{
	PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
    
    //TODO:
    //read from the file to see how many objects should be added
    //Check how many sprites have been added
    //getBodylist() then loop through and for each body apperance you are looking for count 1 and if count
    // = the count in the file return
    
    b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:isDefault withSprite:sprite] createBody:p];
    
    body->SetTransform(b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO), rotation);

    b2Fixture* f = body->GetFixtureList();
    b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
    int count = polygonShape->GetVertexCount();
    
    CGFloat offset = self.boundingBox.origin.x;
    
    for(int i = 0; i < count; i++)
    {
        CGFloat xCoordinate =(CGFloat) (&polygonShape->GetVertex(i))->x;
        CGFloat yCoordinate = (CGFloat) (&polygonShape->GetVertex(i))->y;
        CGPoint point = ccpMult(CGPointMake(xCoordinate, yCoordinate), PTM_RATIO);
        CGPoint boundPoint = CGPointMake(point.x + p.x + offset, point.y + p.y);
        boundPoint = [[CCDirector sharedDirector] convertToGL: boundPoint];

        if ( !CGRectContainsPoint(self.boundingBox, boundPoint))
        {
            world->DestroyBody(body);
            NSLog(@"Body destroy");
            return;
        }
    }
    
    [self addChild:sprite];
	[sprite setPhysicsBody:body];
    [sprite setPosition: ccp(p.x,p.y)];
}


-(void)playLevel
{
    NSLog(@"Physics PlayLevel");
    if (_editMode) { // So you can only do it once before resetting.
        _editMode = NO;
        [self addNewSpriteOfType:@"BallObject" AtPosition:ballStartingPoint WithRotation:0 AsDefault:NO];
    }
}

/* hitStar:
 * removes star from screen when it is hit
 */
-(void) hitStar:(b2Body*) starBody
{
    // delete the star sprite
    AbstractGameObject* starBodyObject = static_cast<AbstractGameObject*>(starBody->GetUserData());
    CCSprite* sprite = [starBodyObject getSprite];
    [self removeChild: sprite cleanup:YES];
    
    // delete the star body
    // (this doesn't actually happen 'till end of collision because
    //  hitStar is called inside the update function, but it doesn't seem to matter.)
    world->DestroyBody(starBody);
    
    [self updateStarCount];
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else if (!_selector2) {
        _selector2 = action;
    }
    else {
        _selector3 = action;
    }
}

/* gameWon:
 * indicates the game is won when the ball hits the portal
 */
-(void) gameWon
{
    [_target performSelector:_selector2];
}

/* updateStarCount:
 * causes star count to be updated when a star is hit
 */
-(void) updateStarCount
{
    [_target performSelector:_selector3];
}

/* getObjectType:
 * gets type of object to be added to screen
 */
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
	// It is recommended to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

/* update:
 * simulates a time step in the physics world
 */
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


//-----TOUCHING WITH DRAGGING-----//

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Physics touch began");
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
            if ([[self getObjectType] isEqualToString:@"Delete"]) {
                CCSprite* sprite = [bodyObject getSprite];
                [self removeChild: sprite cleanup:YES];
                world->DestroyBody(body);
            } else {
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
    if (currentMoveableBody != NULL) {
        currentMoveableBody = NULL;
    } else if (_editMode) {
    
        //Add a new body/atlas sprite at the touched location
        CGPoint location = [touch locationInView: [touch view]];
    
        if (CGRectContainsPoint(self.boundingBox, location)) {
        
            location = [[CCDirector sharedDirector] convertToGL: location];
            location = [self convertToNodeSpace:location];
        
            // get object type from inventory
            NSString* objectType = [self getObjectType];
            
            if(objectType && ![objectType isEqualToString:@"None"] && ![objectType isEqualToString:@"Delete"]){
                [self addNewSpriteOfType:objectType AtPosition:location WithRotation:0 AsDefault:NO];
            }
        }
    }
}

//-----DEALLOC-----//

-(void) dealloc
{	
	delete m_debugDraw;
	m_debugDraw = NULL;
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        b->SetAwake(false);
    }
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        world->DestroyBody(b);
    }
    
    delete world;
	world = NULL;
	
	[super dealloc];
}

@end
