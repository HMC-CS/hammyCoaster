//
//  PhysicsLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//


// NOTES:
// CCTouchEnded: make sure to do bounds checking here so ball is not added in inventory

#import "PhysicsLayer.h"
#import "InventoryLayer.h"

#import "PhysicsSprite.h"
#import "QueryCallback.h"

#import "MathHelper.h"

@implementation PhysicsLayer

@synthesize objectTag;

//-----INITIALIZATION-----//

-(id) initWithObjects:(NSArray *)objects
{
    NSAssert1(objects, @"Objects array %@ given to PhysicsLayer is null.", objects);
    
	if( (self=[super init])) {
		
        
        _createdObjects = [NSMutableArray array];
        
		// enable events
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        _initialObjects = objects;
        
        _objectArray = NULL;
        
        _trash = NULL;
        
        _objectType = [[NSString alloc] initWithFormat:@"None"];
        
        [self addInitialObjects];
		
		[self scheduleUpdate];
        
        _editMode = YES;
        
        _moveableDynamicStatus = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) initPhysics
{
	
	CGSize size = [self contentSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	_world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	_world->SetAllowSleeping(true);
	
	_world->SetContinuousPhysics(true);
    
    // For collision callbacks
    _contactListener = new ContactListener();
    _world->SetContactListener(_contactListener);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    
    // NOTE: comment this line out to disable debug draw
	_world->SetDebugDraw(m_debugDraw);
	
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
	b2Body* groundBody = _world->CreateBody(&groundBodyDef);
	
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
    
    b2Body *rampBody = _world->CreateBody(&rampBodyDef);
    b2EdgeShape rampEdge;
    b2FixtureDef rampShapeDef;
    rampShapeDef.shape = &rampEdge;
    
    // ramp definitions
    rampEdge.Set(b2Vec2(0/PTM_RATIO,450/PTM_RATIO), b2Vec2(size.width/(5*PTM_RATIO), 410/PTM_RATIO));
    rampBody->CreateFixture(&rampShapeDef);
    
    _worldManager = [[WorldManager alloc] initWithWorld:_world];
    
}

- (void) addInitialObjects
{
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        CGFloat px = [[item objectAtIndex:1] floatValue];
        CGFloat py = [[item objectAtIndex:2] floatValue];
        CGFloat rotation = [[item objectAtIndex:3] floatValue];
        [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        if ([type isEqual: @"RedPortalObject"])
        {
            _ballStartingPoint = CGPointMake(px,py);
        }
    }
}


//-----GAME METHODS-----//

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation AsDefault:(bool)isDefault;
{
    if ([type isEqualToString:@"None"]) {
        return;
    }
    
    NSAssert1(NSClassFromString(type), @"Type %@ given to addNewSpriteOfType in PhysicsLayer is not a valid object type", type);
    
    // MULTI: add an if statement if there are multiple bodies in your object
    NSArray *spriteArray = [NSArray array];
    if ([type isEqualToString:@"SeesawObject"])
    {
        PhysicsSprite* sprite1 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Bottom.png", type]];
        PhysicsSprite* sprite2 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Top.png", type]];
        spriteArray = @[sprite1, sprite2];
    } else {
        PhysicsSprite* sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
        spriteArray = @[sprite];
    }
    //NSLog(@"finished adding sprites");
    
    //TODO:
    //read from the file to see how many objects should be added
    //Check how many sprites have been added
    //getBodylist() then loop through and for each body apperance you are looking for count 1 and if count
    // = the count in the file return
    
    
    AbstractGameObject *createdObj = [_objectFactory objectFromString:type ForWorld:_world AsDefault:isDefault WithSprites:[spriteArray mutableCopy]];
    
    [_createdObjects addObject:createdObj];
    std::vector<b2Body*> bodies = [createdObj createBodyAtLocation:p];
    
    //NSLog(@"finished getting bodies");
    
    int j = 0;
    for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b)
    {
        PhysicsSprite* s = [spriteArray objectAtIndex:j];
        b2Body* body = *b;
        [self addChild:s];
        [s setPhysicsBody:body];
        [s setPosition: ccp(body->GetPosition().x, body->GetPosition().y)];
        body->SetTransform(b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO), rotation);
        ++j;
        //[_objectArray addObject:((__bridge AbstractGameObject*)(body->GetUserData()))];
    }
    //NSLog(@"finished body loop");
    
//    b2Body* theBody = *(bodies.begin());
    // added bridge cast
    //if (![((__bridge AbstractGameObject*) static_cast<AbstractGameObject*>(theBody->GetUserData()))._tag isEqualToString:@"BallObject"])
//    if (![((__bridge AbstractGameObject*)(theBody->GetUserData())).type isEqualToString:@"BallObject"])
//    {
//        for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b)
//        {
//            b2Body* body = *b;
//            b2Fixture* f = body->GetFixtureList();
//            b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
//            int count = polygonShape->GetVertexCount();
//            
//            CGFloat offset = self.boundingBox.origin.x;
//            
//            for(int i = 0; i < count; i++)
//            {
//                CGFloat xCoordinate =(CGFloat) (&polygonShape->GetVertex(i))->x;
//                CGFloat yCoordinate = (CGFloat) (&polygonShape->GetVertex(i))->y;
//                CGPoint point = ccpMult(CGPointMake(xCoordinate, yCoordinate), PTM_RATIO);
//                CGPoint boundPoint = CGPointMake(point.x + p.x + offset, point.y + p.y);
//                boundPoint = [[CCDirector sharedDirector] convertToGL: boundPoint];
//                
//                if ( !CGRectContainsPoint(self.boundingBox, boundPoint))
//                {
//                    NSLog(@"Body destroy");
//                    [self deleteObjectWithBody:body];
//                    return;
//                }
//                
//            }
//        }
//    }
}

-(CGPoint)getBallStartingPoint
{
    NSLog(@"Physics Layer ball starting point x: %f y: %f", _ballStartingPoint.x, _ballStartingPoint.y);
    return _ballStartingPoint;
}

-(void)playLevel
{
    // NSLog(@"Physics PlayLevel");
    if (_editMode) { // So you can only do it once before resetting.
        _editMode = NO;
        [self addNewSpriteOfType:@"BallObject" AtPosition:_ballStartingPoint WithRotation:0 AsDefault:NO];
    }
}


// TODO: did not change this method for multi-body because BallObject and StarObject are single-body objects.  Change if necessary.
-(void) resetBall
{
    // Delete Ball and Stars
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()){
        // added bridge cast
        //if ([(__bridge AbstractGameObject*) static_cast<AbstractGameObject*>(b->GetUserData())._tag isEqualToString:@"BallObject"])
        if ([((__bridge AbstractGameObject*)(b->GetUserData())).type isEqualToString:@"BallObject"])
        {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CFBridgingRetain(a);
            CCSprite* sprite = [a.sprites objectAtIndex:0];
            [self removeChild: sprite cleanup:NO]; // cleanup removed
            [self deleteObjectWithBody:b];
        }
        
        if ([((__bridge AbstractGameObject*)(b->GetUserData())).type isEqualToString:@"StarObject"])
        {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CFBridgingRetain(a);
            CCSprite* sprite = [a.sprites objectAtIndex:0];
            [self removeChild: sprite cleanup:NO]; // cleanup removed
            [self deleteObjectWithBody:b];
        }
    }
    // put back all the stars from the JSON file
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        if ([type isEqualToString: @"StarObject"])
        {
            CGFloat px = [[item objectAtIndex:1] floatValue];
            CGFloat py = [[item objectAtIndex:2] floatValue];
            CGFloat rotation = [[item objectAtIndex:3] floatValue];
            [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        }
    }
    // make level editable again
    _editMode = YES;
    
}


// TODO: did not change this method for multi-body because StarObject is single-body object.  Change if necessary.
/* hitStar:
 * removes star from screen when it is hit
 */
-(void) hitStar:(b2Body*) starBody
{
    NSAssert(starBody, @"Star body in hitStar in Physics Layer is null.");
    
    [self deleteObjectWithBody:starBody];
    
    [self updateStarCount];
}


//// TODO: did not change this method for multi-body because BallObject and MagnetObject are single-body objects.  Change if changed.
///* applyMagnets:
// * helper function to apply magnet's forces to the ball
// */
-(void) applyMagnets
{
    int magnetConstant = 400000000;
    //find all the magnets
    for (b2Body* magnet = _world->GetBodyList(); magnet; magnet = magnet->GetNext()){
        if ([((__bridge AbstractGameObject*)(magnet->GetUserData())).type isEqualToString:@"MagnetObject"])
        {
            //get the ball's body
            for (b2Body* ball = _world->GetBodyList(); ball; ball = ball->GetNext()){
                if ([((__bridge AbstractGameObject*)(ball->GetUserData())).type isEqualToString:@"BallObject"])
                {
                    
                    // TODO: after making magnet into two fixtures (one north, one south), simulate point force for each one.  So it'll be like a dipole.
                    
                    b2Fixture* fixture1 = magnet->GetFixtureList();
                    b2PolygonShape* shape1 = static_cast<b2PolygonShape*>(fixture1->GetShape());
                    b2Vec2 shape1Position = shape1->m_centroid;
                    b2Vec2 shape1WorldPosition = magnet->GetWorldPoint(shape1Position);
                    double d11 = ball->GetPosition().x - shape1WorldPosition.x;
                    double d12 = ball->GetPosition().y - shape1WorldPosition.y;
                    double distance1 = sqrt(d11 * d11 + d12 * d12) * 1000;
                    float angleRadians1 = GetAngle(ball->GetPosition().x, ball->GetPosition().y, shape1WorldPosition.x, shape1WorldPosition.y);
                    float yComponent1 = sinf(angleRadians1);
                    float xComponent1 = cosf(angleRadians1);
                    b2Vec2 direction1 = b2Vec2((magnetConstant*xComponent1*-1)/(distance1*distance1), (magnetConstant*yComponent1*-1)/(distance1*distance1));
                    
                    
                    b2Fixture* fixture2 = fixture1->GetNext();
                    b2PolygonShape* shape2 = static_cast<b2PolygonShape*>(fixture2->GetShape());
                    b2Vec2 shape2Position = shape2->m_centroid;
                    b2Vec2 shape2WorldPosition = magnet->GetWorldPoint(shape2Position);
                    double d21 = ball->GetPosition().x - shape2WorldPosition.x;
                    double d22 = ball->GetPosition().y - shape2WorldPosition.y;
                    double distance2 = sqrt(d21 * d21 + d22 * d22) * 1000;
                    float angleRadians2 = GetAngle(ball->GetPosition().x, ball->GetPosition().y, shape2WorldPosition.x, shape2WorldPosition.y);
                    float yComponent2 = sinf(angleRadians2);
                    float xComponent2 = cosf(angleRadians2);
                    b2Vec2 direction2 = b2Vec2((magnetConstant*xComponent2*-1)/(distance2*distance2), (magnetConstant*yComponent2*-1)/(distance2*distance2));
                    
                    b2Vec2 force;
                    if ([(__bridge NSString*)(fixture1->GetUserData()) isEqualToString:@"NORTH"])
                    {
                        force = direction2 - direction1;
                        
                    } else {
                        
                        force = direction1 - direction2;
                        
                    }
                    ball->ApplyForce(force, ball->GetPosition());
                    
                    break;
                }
            }
            break;
        }
    }
}

-(void) setTarget:(id) sender AtAction:(SEL)action
{
    NSAssert1(sender, @"Sender %@ for PhysicsLayer setTarget is null.", sender);
    NSAssert(action, @"Selector for PhysicsLayer setTarget is null.");
    
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else if (!_selector2) {
        _selector2 = action;
    }
    else if (!_selector3)
    {
        _selector3 = action;
    }
    else if (!_selector4)
    {
        _selector4 = action;
    }
    else
    {
        _selector5 = action;
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
- (NSString*) getObjectTypeForAddingNewObject: (NSString*) isAddingNewObject
{
    return [_target performSelector:_selector1 withObject:isAddingNewObject];
}
-(void) objectDeletedOfType: (NSString*) type
{
    [_target performSelector:_selector4 withObject:type];
}


// DONE: changed for multi-body
/* deleteObjectWithBody:
 * deletes a physics body from the physics layer
 */

-(void) deleteObjectWithBody: (b2Body*) body
{    
    AbstractGameObject* object = (__bridge AbstractGameObject*)(body->GetUserData());
    
    CFBridgingRetain(object);
    
    
    NSString* objectType = object.type;
    [self objectDeletedOfType:objectType];
    std::vector<b2Body*> bodies = object.bodies;
    
    NSMutableArray* objectSprites = object.sprites;
    
    int j=0;
    for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b)
    {
        PhysicsSprite* s = [objectSprites objectAtIndex:j];
        b2Body* body = *b;
        [self removeChild:s cleanup:NO]; //cleanup removed
        //body->SetAwake(false);
        //_world->DestroyBody(body);
        //body = NULL;
        [_worldManager destroyBody:body];
        ++j;
    }
    //NSLog(@"bodies destroyed successfully");
    [_objectArray removeObject:object];
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
	
    //NOTE: can also comment this out to put back debug draw
	_world->DrawDebugData();
	
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
	_world->Step(dt, velocityIterations, positionIterations);
    
    if (_contactListener->IsLevelWon()) {
        _contactListener->SetLevelWonStatus(false);
        [self gameWon];
    }
    
    b2Body* contactStar = _contactListener->GetContactStar();
    if (contactStar) {
        [self hitStar:contactStar];
        _contactListener->EraseContactStar();    }
    
    //    for (std::vector<b2Body*>::iterator i = _bodiesToDestroy.begin(); i != _bodiesToDestroy.end(); ++i)
    //    {
    //        b2Body* body = *i;
    //        _world->DestroyBody(body);
    //    }
    //    _bodiesToDestroy.erase(_bodiesToDestroy.begin(), _bodiesToDestroy.end());
    
    //    [self applyMagnets];
    //
    //    for (b2Joint* joint = _world->GetJointList(); joint; joint = joint->GetNext())
    //    {
    //        AbstractGameObject* object = (__bridge AbstractGameObject*)(joint->GetUserData());
    //        CFBridgingRetain(object);
    //        NSString* type = object._tag;
    //        if ([type isEqualToString:@"SeesawObject"]) {
    //            const float springTorqForce = 1.0f;
    //            float jointAngle = joint->GetBodyA()->GetAngle(); // teeter body
    //            if ( jointAngle != 0 ) {
    //                float torque = fabs(jointAngle * springTorqForce * 50);
    //                if (jointAngle > 0.0)
    //                {
    //                    joint->GetBodyA()->ApplyTorque(-torque);
    //                } else {
    //                    joint->GetBodyA()->ApplyTorque(torque);
    //                }
    //            }
    //
    //        }
    //    }
    
    [_worldManager update];
}


//-----TOUCH HANDLING-----//

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_firstTouch == NULL) {
        _firstTouch = touch;
        
        // Get tap location and convert to cocos2d-box2d coordinates
        CGPoint touchLocation = [self getTouchLocation:touch];
        _initialTouchPosition = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
        
        // If the touch is in the inventory, add an object where the touch is
        if (touchLocation.x < 0) {
            NSString* type = [self getObjectTypeForAddingNewObject:@"YES"];
            CGPoint objectLocation = touchLocation;
            
            // We need to shift curved ramps up so part of the object overlaps with the touch
            if ([type isEqualToString:@"CurvedRampObject"]) {
                objectLocation.y += 50;
            }
            
            [self addNewSpriteOfType:type AtPosition:objectLocation WithRotation:0.0 AsDefault:false];
        }
        
        
        b2Body* body = [self getBodyAtLocation:_initialTouchPosition WithAABBSize:0.001f];
        
        // If there's a body where the touch is, set up for dragging
        if (body) {
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(body->GetUserData());
            CFBridgingRetain(bodyObject);
            
            // If the object is draggable, set up dragging for that object
            if (!bodyObject.isDefault && _editMode) {
                
                // Save the body and its location
                _initialBodyPosition = body->GetPosition();
                _currentMoveableBody = body;
                
                // Unless the touch is in the inventory, turn the inventory into the trash can
                if (![self pointInInventory:touchLocation]) {
                    [self addTrash];
                }
                
                // Save if each object body is dynamic or static
                [self storeMoveableDynamicStatusForBodies:bodyObject.bodies];
                
                // Clicking on the ball resets the ball
            } else if ([bodyObject.type isEqualToString:@"BallObject"]) {
                [self resetBall];
                [_target performSelector:_selector5];
            }
        }
        
        // If it's the second touch (and the first touch was on a body), set up for rotation
    } else if (_secondTouch == NULL && _currentMoveableBody != NULL) {
        NSString* currentMoveableBodyType = ((__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData())).type;
        if (![currentMoveableBodyType isEqualToString:@"SeesawObject"]) {
            _secondTouch = touch;
            _initialTouchAngle = [self calculateTouchAngle];
        }
    }
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_currentMoveableBody != NULL) {
        
        // If there's only one touch, drag
        if (touch == _firstTouch && _secondTouch == NULL) {
            
            // Calculate touch location
            CGPoint touchLocation = [self getTouchLocation:touch];
            b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
            
            // Move each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            std::vector<b2Body*> bodies = bodyObject.bodies;
            for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
            {
                b2Body* b = *i;
                b2Vec2 newPos = b->GetPosition() + (location - _initialTouchPosition);
                b->SetTransform(newPos,b->GetAngle());
            }
            
            _initialTouchPosition = location;
        }
        
        // If there are 2 touches, rotate
        if (_secondTouch != NULL && (touch == _firstTouch || touch == _secondTouch)) {
            
            float touchAngle = [self calculateTouchAngle];
            
            // Rotate each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            std::vector<b2Body*> bodies = bodyObject.bodies;
            for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
            {
                b2Body* b = *i;
                float newAngle = b->GetAngle() + (touchAngle - _initialTouchAngle);
                b->SetTransform(b->GetPosition(),newAngle);
            }
            
            _initialTouchAngle = touchAngle;
        }
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _firstTouch) {
        [self resetTouch];
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _firstTouch) {
        
        // If we were moving a body, maybe delete or bounce back
        if (_currentMoveableBody != NULL) {
            
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            
            [self finishedMovingObject:bodyObject];
        }
        
        [self resetTouch];
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}

//----TOUCH HELPER FUNCTIONS----//

-(CGPoint) getTouchLocation:(UITouch *) touch
{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    return touchLocation;
}

-(b2Body*) getBodyAtLocation:(b2Vec2) location WithAABBSize:(float) boxSize
{
    QueryCallback callback(location);
    b2AABB aabb = callback.getAABB(0.001f);
    _world->QueryAABB(&callback, aabb);
    
    return callback.getm_object();
}

-(void) addTrash
{
    _trash = [CCSprite spriteWithFile:@"trash2.png"];
    _trash.position = ccp(-self.boundingBox.size.width/5.9, self.boundingBox.size.height/2);
    [self addChild:_trash z:10000];
}

-(void) storeMoveableDynamicStatusForBodies:(std::vector<b2Body*>) bodies
{
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) {
        b2Body* loopBody = *i;
        
        if (loopBody->GetType() == b2_dynamicBody) {
            [_moveableDynamicStatus addObject:@"dynamic"];
            loopBody->SetType(b2_staticBody);
        } else {
            [_moveableDynamicStatus addObject:@"static"];
        }
        
        loopBody->SetActive(false);
    }
}

-(void) resetMoveableDynamicStatusForBodies:(std::vector<b2Body*>) bodies
{
    int statusCounter = 0;
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
    {
        b2Body* body = *i;
        if ([[_moveableDynamicStatus objectAtIndex:statusCounter] isEqualToString:@"dynamic"])
        {
            body->SetType(b2_dynamicBody);
        }
        body->SetActive(true);
        ++statusCounter;
    }
}

-(bool) pointInInventory:(CGPoint) point
{
    return point.x < 0;
}

-(bool) pointInTrash: (CGPoint) point
{
    return (point.x < self.boundingBox.origin.x &&
            point.y > self.boundingBox.size.height/5 &&
            point.y < self.boundingBox.size.height*4/5);
}

-(float) calculateTouchAngle
{
    CGPoint point = ccpSub([_secondTouch locationInView:[_secondTouch view]], [_firstTouch locationInView:[_firstTouch view]]);
    CGPoint xaxis = CGPointMake(-1, 0);
    float touchAngle;
    if (point.y >= 0) {
        touchAngle = ccpAngle(point, xaxis);
    } else {
        point = CGPointMake(point.x, -point.y);
        touchAngle = -ccpAngle(point, xaxis);
    }
    
    return touchAngle;
}

-(void) resetTouch
{
    _firstTouch = NULL;
    _secondTouch = NULL;
    [self removeChild:_trash cleanup:NO];
    [_moveableDynamicStatus removeAllObjects];
    _currentMoveableBody = NULL;
}

-(void) finishedMovingObject: (AbstractGameObject*) bodyObject
{
    std::vector<b2Body*> bodies = bodyObject.bodies;
    
    bool deleteObject = false;
    bool bounceBackObject = false;
    
    // Iterate through all the bodies in the object
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) {
        b2Body* body = *i;
        
        // Iterate through all the fixtures in each body
        for (b2Fixture* f = body->GetFixtureList(); f != NULL; f = f->GetNext()) {
            b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
            int count = polygonShape->GetVertexCount();
                        
            // Iterate through all the vertices in each fixture
            for (int i = 0; i < count; i++) {
                
                // Get the location of the vertex
                b2Vec2 vertexPoint = polygonShape->GetVertex(i) + body->GetPosition();
                CGPoint boundPoint = ccpMult(ccp(vertexPoint.x, vertexPoint.y), PTM_RATIO);
                boundPoint = ccpAdd(boundPoint, self.boundingBox.origin);
                
                // Check if the point is in the inventory
                if ( !CGRectContainsPoint(self.boundingBox, boundPoint)) {
                    if ([self pointInTrash:boundPoint]) {
                        deleteObject = true;
                        break;
                    } else {
                        bounceBackObject = true;
                        break;
                    }
                }
                
                // Check if the vertex is in another body
                b2Body* b = [self getBodyAtLocation:vertexPoint WithAABBSize:10.0f];
                if (b && (b != body)) {
                    
                    AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(b->GetUserData());
                    NSString* bodyType = bodyObject.type;
                    
                    // Allow overlap with stars
                    if (![bodyType isEqualToString:@"StarObject"]) {
                        bounceBackObject = true;
                        break;
                    }
                }
                
            }
            
            if (deleteObject || bounceBackObject) {
                break;
            }
        }
        if (deleteObject || bounceBackObject) {
            break;
        }
    }
    
    if (deleteObject) {
        [self deleteObjectWithBody:_currentMoveableBody];
    } else if (bounceBackObject) {
        [self bounceBackObjectWithBody:_currentMoveableBody];
    }
    
    [self resetMoveableDynamicStatusForBodies:bodies];
}

-(void) bounceBackObjectWithBody: (b2Body*) body
{
    if (_initialBodyPosition.x < 0) {
        [self deleteObjectWithBody:body];
    } else {
        b2Vec2 cmbPosition = _currentMoveableBody->GetPosition();
        std::vector<b2Body*> bodies = ((__bridge AbstractGameObject*)(body->GetUserData())).bodies;
        for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) {
            // TODO: THIS IS WRONG RIGHT NOW
            //NSLog(@"Body number %d", ++j);
            b2Body* body = *i;
            b2Vec2 bodyOffset = body->GetPosition() - cmbPosition;
            body->SetTransform(_initialBodyPosition + bodyOffset, body->GetAngle());
        }
    }
}


//-----DEALLOC-----//

-(void) dealloc
{
	delete m_debugDraw;
	m_debugDraw = NULL;
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()) {
        b->SetAwake(false);
    }
    
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()) {
        _world->DestroyBody(b);
    }
    
    delete _world;
	_world = NULL;
}


@end
