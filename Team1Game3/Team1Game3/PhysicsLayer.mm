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
    NSAssert1(objects, @"Objects array %@ given to PhysicsLayer is null.", objects);
    
	if( (self=[super init])) {
		
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
    rampEdge.Set(b2Vec2(0/PTM_RATIO,450/PTM_RATIO), b2Vec2(size.width/(5*PTM_RATIO), 410/PTM_RATIO));
    rampBody->CreateFixture(&rampShapeDef);
    
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
            ballStartingPoint = CGPointMake(px,py);
            NSLog(@"ball starting point is %f, %f", ballStartingPoint.x, ballStartingPoint.y);
        }
    }
}


//-----GAME METHODS-----//

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation AsDefault:(bool)isDefault;
{
    if([type isEqualToString:@"SeesawObject"])
        NSLog(@"SeesawObject");
    
    NSAssert1(NSClassFromString(type), @"Type %@ given to addNewSpriteOfType in PhysicsLayer is not a valid object type", type);
    
    // MULTI: add an if statement if there are multiple bodies in your object
    NSMutableArray* spriteArray;
    if ([type isEqualToString:@"SeesawObject"])
    {
        PhysicsSprite* sprite1 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Bottom.png", type]];
        PhysicsSprite* sprite2 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Top.png", type]];
        spriteArray = [[NSMutableArray alloc] initWithObjects:sprite1, sprite2, nil];
    } else {
        PhysicsSprite* sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
        spriteArray = [[NSMutableArray alloc] initWithObjects:sprite, nil];
    }
    NSLog(@"finished adding sprites");
    
    //TODO:
    //read from the file to see how many objects should be added
    //Check how many sprites have been added
    //getBodylist() then loop through and for each body apperance you are looking for count 1 and if count
    // = the count in the file return

    std::vector<b2Body*> bodies = [[_objectFactory objectFromString:type forWorld:world asDefault:isDefault withSprites:spriteArray] createBody:p];
    
    NSLog(@"finished getting bodies");
    
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
    }
    NSLog(@"finished body loop");
    
    b2Body* theBody = *(bodies.begin());
    // added bridge cast
    //if (![((__bridge AbstractGameObject*) static_cast<AbstractGameObject*>(theBody->GetUserData()))._tag isEqualToString:@"BallObject"])
    if (![((__bridge AbstractGameObject*)(theBody->GetUserData()))._tag isEqualToString:@"BallObject"])
    {
        for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b)
        {
            b2Body* body = *b;
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
                    NSLog(@"Body destroy");
                    [self deleteObjectWithBody:body];
                    return;
                }
                
            }
        }
    }
}

-(CGPoint)getBallStartingPoint
{
    NSLog(@"Physics Layer ball starting point x: %f y: %f", ballStartingPoint.x, ballStartingPoint.y);
    return ballStartingPoint;
}

-(void)playLevel
{
    // NSLog(@"Physics PlayLevel");
    if (_editMode) { // So you can only do it once before resetting.
        _editMode = NO;
        [self addNewSpriteOfType:@"BallObject" AtPosition:ballStartingPoint WithRotation:0 AsDefault:NO];
    }
}


// TODO: did not change this method for multi-body because BallObject and StarObject are single-body objects.  Change if necessary.
-(void) resetBall
{
    // Delete Ball and Stars
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()){
        // added bridge cast
        //if ([(__bridge AbstractGameObject*) static_cast<AbstractGameObject*>(b->GetUserData())._tag isEqualToString:@"BallObject"])
        if ([((__bridge AbstractGameObject*)(b->GetUserData()))._tag isEqualToString:@"BallObject"])
        {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CCSprite* sprite = [[a getSprites] objectAtIndex:0];
            [self removeChild: sprite cleanup:YES];
            [self deleteObjectWithBody:b];
        }
        
        if ([((__bridge AbstractGameObject*)(b->GetUserData()))._tag isEqualToString:@"StarObject"])
        {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CCSprite* sprite = [[a getSprites] objectAtIndex:0];
            [self removeChild: sprite cleanup:YES];
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
    
    // delete the star sprite
    AbstractGameObject* starBodyObject = (__bridge AbstractGameObject*)(starBody->GetUserData());
    CCSprite* sprite = [[starBodyObject getSprites] objectAtIndex:0];
    [self removeChild: sprite cleanup:YES];
    
    // delete the star body
    // (this doesn't actually happen 'till end of collision because
    //  hitStar is called inside the update function, but it doesn't seem to matter.)
    //world->DestroyBody(starBody);
    _bodiesToDestroy.push_back(starBody);
    
    [self updateStarCount];
}


-(void) trampolineDraggable
{
    for (b2Body* body = world->GetBodyList(); body; body = body->GetNext())
    {
        
        if ([((__bridge AbstractGameObject*)(body->GetUserData()))._tag isEqualToString:@"TrampolineObject"])
             {
                 for ( b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext() ) {
                     
                 }
             }
    }
}





// TODO: did not change this method for multi-body because BallObject and MagnetObject are single-body objects.  Change if changed.
/* applyMagnets:
 * helper function to apply magnet's forces to the ball
 */
-(void) applyMagnets
{
    int magnetConstant = 400000000;
    //find all the magnets
    for (b2Body* magnet = world->GetBodyList(); magnet; magnet = magnet->GetNext()){
        if ([((__bridge AbstractGameObject*)(magnet->GetUserData()))._tag isEqualToString:@"MagnetObject"])
        {
            //get the ball's body
            for (b2Body* ball = world->GetBodyList(); ball; ball = ball->GetNext()){
                if ([((__bridge AbstractGameObject*)(ball->GetUserData()))._tag isEqualToString:@"BallObject"])
                {
                    //AbstractGameObject* a = static_cast<AbstractGameObject*>(ball->GetUserData());
                    
                    // TODO: after making magnet into two fixtures (one north, one south), simulate point force for each one.  So it'll be like a dipole.
                    
                    b2Fixture* fixture1 = magnet->GetFixtureList();
                    b2Fixture* fixture2 = fixture1->GetNext();
                    
                    
                    b2PolygonShape* shape1 = static_cast<b2PolygonShape*>(fixture1->GetShape());
                    b2Vec2 shape1Position = shape1->m_centroid;
                    
                    b2PolygonShape* shape2 = static_cast<b2PolygonShape*>(fixture2->GetShape());
                    b2Vec2 shape2Position = shape2->m_centroid;
                    
//                    CGPoint point = ccpSub([_secondTouch locationInView:[touch view]], [_firstTouch locationInView:[touch view]]);
//                    CGPoint xaxis = CGPointMake(-1, 0);
//                    if (point.y >= 0) {
//                        _initialTouchAngle = ccpAngle(point, xaxis);
//                    } else {
//                        point = CGPointMake(point.x, -point.y);
//                        _initialTouchAngle = -ccpAngle(point, xaxis);
//                    }
                    
                    // Pole 1
                    double d11 = ball->GetPosition().x - (magnet->GetPosition().x + shape1Position.x);
                    double d12 = ball->GetPosition().y - (magnet->GetPosition().y + shape1Position.y);
                    double distance1 = sqrt(d11 * d11 + d12 * d12) * 1000;
                    // Determine angle to face
                    //float angleRadians1 = atanf((float)d12 / (float)d11);
                    
                    float angleRadians1;
                    if (d12 > 0)
                    {
                        angleRadians1 = atanf((float)d12 / (float)d11);
                    } else {
                        angleRadians1 = -1.0 * atanf((float)d12 / (float)d11);
                    }
                    
                    NSLog(@"angle 1: %f", angleRadians1);
                    
                    float yComponent1 = sinf(angleRadians1);
                    float xComponent1 = cosf(angleRadians1);
                    

                    
                    // Pole 2
                    double d21 = ball->GetPosition().x - (magnet->GetPosition().x + shape2Position.x);
                    double d22 = ball->GetPosition().y - (magnet->GetPosition().y + shape2Position.y);
                    double distance2 = sqrt(d21 * d21 + d22 * d22) * 1000;
                    
                    // Determine angle to face
                    //float angleRadians2 = atanf((float)d22 / (float)d21);
                    
                    float angleRadians2;
                    if (d22 > 0)
                    {
                        angleRadians2 = atanf((float)d22 / (float)d21);
                    } else {
                        angleRadians2 = -1.0 * atanf((float)d22 / (float)d21);
                    }
                    
                    NSLog(@"angle 2: %f", angleRadians2);
                    
                    
                    float yComponent2 = sinf(angleRadians2);
                    float xComponent2 = cosf(angleRadians2);
                    
                    b2Vec2 direction1 = b2Vec2((magnetConstant*xComponent1*-1)/(distance1*distance1), (magnetConstant*yComponent1*-1)/(distance1*distance1));
                    b2Vec2 direction2 = b2Vec2((magnetConstant*xComponent2*-1)/(distance2*distance2), (magnetConstant*yComponent2*-1)/(distance2*distance2));
                    
                    b2Vec2 force;
                    if ([(__bridge NSString*)(fixture1->GetUserData()) isEqualToString:@"NORTH"])
                    {
                        //NSLog(@"we're here");
                        
//                        if (distance2 > distance1)
//                        {
//                            force = direction2 - direction1;
//                        } else {
//                            force = direction1 - direction2;
//                        }
                        
                        force = direction2 - direction1;
                        
                    } else {
                        
                        //NSLog(@"we're here instead");
                        
//                        if (distance2 > distance1)
//                        {
//                            force = direction1 - direction2;
//                        } else {
//                            force = direction2 - direction1;
//                        }
                        
                        force = direction1 - direction2;
                        
                        
                    }
                    ball->ApplyForce(force, ball->GetPosition());
                    
                    break;
                }
            }
        }
    }
}

-(void) setTarget:(id) sender atAction:(SEL)action
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
    else if (!_selector5)
    {
        _selector5 = action;
    }
    else
    {
        _selector6 = action;
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
-(bool) isDeleteSelected
{
    return [_target performSelector:_selector4];
}
-(void) objectDeletedOfType: (NSString*) type
{
    [_target performSelector:_selector5 withObject:type];
}


// DONE: changed for multi-body
/* deleteObjectWithBody:
 * deletes a physics body from the physics layer
 */

-(void) deleteObjectWithBody: (b2Body*) body
{
    AbstractGameObject* object = (__bridge AbstractGameObject*)(body->GetUserData());
    
    NSString* objectType = object._tag;
    [self objectDeletedOfType:objectType];
    
    std::vector<b2Body*> bodies = object->_bodies;
    
    NSMutableArray* objectSprites = [object getSprites];
    
    int j=0;
    for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b)
    {
        PhysicsSprite* s = [objectSprites objectAtIndex:j];
        b2Body* body = *b;
        [self removeChild:s cleanup:YES];
        //body->SetAwake(false);
        //world->DestroyBody(body);
        //body = NULL;
        _bodiesToDestroy.push_back(body);
        ++j;
    }
    NSLog(@"bodies destroyed successfully");
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
    
    if (_contactListener->_gameWon) {
        _contactListener->_gameWon = false;
        [self gameWon];
    }
    if (_contactListener->_contactStar != NULL) {
        [self hitStar:(_contactListener->_contactStar)];
        _contactListener->_contactStar = NULL;
    }
    
    for (std::vector<b2Body*>::iterator i = _bodiesToDestroy.begin(); i != _bodiesToDestroy.end(); ++i)
    {
        b2Body* body = *i;
        world->DestroyBody(body);
    }
    _bodiesToDestroy.erase(_bodiesToDestroy.begin(), _bodiesToDestroy.end());
    
    [self applyMagnets];
    
    for (b2Joint* joint = world->GetJointList(); joint; joint = joint->GetNext())
    {
        AbstractGameObject* object = (__bridge AbstractGameObject*)(joint->GetUserData());
        NSString* type = object._tag;
        if ([type isEqualToString:@"SeesawObject"]) {
            const float springTorqForce = 1.0f;
            float jointAngle = joint->GetBodyA()->GetAngle(); // teeter body
            if ( jointAngle != 0 ) {
                float torque = fabs(jointAngle * springTorqForce * 50);
                if (jointAngle > 0.0)
                {
                    joint->GetBodyA()->ApplyTorque(-torque);
                } else {
                    joint->GetBodyA()->ApplyTorque(torque);
                }
            }
            
        }
    }
}


//-----TOUCHING WITH DRAGGING-----//

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_firstTouch == NULL) {
        _firstTouch = touch;
        
        //Get tap location and convert to cocos2d-box2d coordinates
        CGPoint touchLocation = [touch locationInView:[touch view]];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        _initialTouchPosition = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
        
        // Make a small box.
        b2AABB aabb;
        b2Vec2 d;
        d.Set(0.001f, 0.001f);
        aabb.lowerBound = _initialTouchPosition - d;
        aabb.upperBound = _initialTouchPosition + d;
        
        // Query the world for overlapping shapes.
        QueryCallback callback(_initialTouchPosition);
        world->QueryAABB(&callback, aabb);
        

        
        
        b2Body* body = callback.m_object;
        
        // Get the current info about the body
        if (body) {
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(body->GetUserData());
            
            if (!bodyObject->_isDefault && _editMode) {
                
                _initialBodyPosition = body->GetPosition();
                
                _currentMoveableBody = body;
                
                [_moveableDynamicStatus removeAllObjects];
                
                
                _trash = [CCSprite spriteWithFile:@"trash2.png"];
                _trash.position = ccp(-self.boundingBox.size.width/5.9, self.boundingBox.size.height/2);
                [self addChild:_trash z:10000];
                
                
                
                std::vector<b2Body*> bodies = bodyObject->_bodies;
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
                
            // Clicking on the ball resets the ball
            } else if ([bodyObject->_tag isEqualToString:@"BallObject"]) {
                [self resetBall];
                [_target performSelector:_selector6];
            }
        } else if (_editMode) {
            
            //Add a new body/atlas sprite at the touched location
            CGPoint location = [touch locationInView: [touch view]];
            if (CGRectContainsPoint(self.boundingBox, location)) {
                location = [[CCDirector sharedDirector] convertToGL: location];
                location = [self convertToNodeSpace:location];
                
                // get object type from inventory
                _objectType = [self getObjectType];
                if(_objectType && ![_objectType isEqualToString:@"None"] && ![_objectType isEqualToString:@"Delete"]){
                    [self addNewSpriteOfType:_objectType AtPosition:location WithRotation:0 AsDefault:NO];
                }
            }
        }
    } else if (_secondTouch == NULL && _currentMoveableBody != NULL) {
        _secondTouch = touch;
        CGPoint point = ccpSub([_secondTouch locationInView:[touch view]], [_firstTouch locationInView:[touch view]]);
        CGPoint xaxis = CGPointMake(-1, 0);
        if (point.y >= 0) {
            _initialTouchAngle = ccpAngle(point, xaxis);
        } else {
            point = CGPointMake(point.x, -point.y);
            _initialTouchAngle = -ccpAngle(point, xaxis);
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
            CGPoint touchLocation = [touch locationInView:[touch view]];
            touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
            touchLocation = [self convertToNodeSpace:touchLocation];
            b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
            
            // Move each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            std::vector<b2Body*> bodies = bodyObject->_bodies;
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
            // Calculate angle
            CGPoint point = ccpSub([_secondTouch locationInView:[touch view]], [_firstTouch locationInView:[touch view]]);
            CGPoint xaxis = CGPointMake(-1, 0);
            float touchAngle;
            if (point.y >= 0) {
                touchAngle = ccpAngle(point, xaxis);
            } else {
                point = CGPointMake(point.x, -point.y);
                touchAngle = -ccpAngle(point, xaxis);
            }
            
            // Rotate each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            std::vector<b2Body*> bodies = bodyObject->_bodies;
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
        _currentMoveableBody = NULL;
        _firstTouch = NULL;
        _secondTouch = NULL;
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _firstTouch) {
        _firstTouch = NULL;
        _secondTouch = NULL;
        [self removeChild:_trash cleanup:YES];
        CGPoint location = [touch locationInView: [touch view]];
        
        if (_currentMoveableBody != NULL) {
            location = [[CCDirector sharedDirector] convertToGL: location];
            location = [self convertToNodeSpace:location];
            
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            std::vector<b2Body*> bodies = bodyObject->_bodies;
            
            bool objectModified = false;
            for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
            {
                b2Body* body = *i;
                
                b2Fixture* f = body->GetFixtureList();
                for (f= body->GetFixtureList(); f != NULL; f = f->GetNext())
                {
                b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
                int count = polygonShape->GetVertexCount();
                
                CGFloat offset = self.boundingBox.origin.x;
            
                
                for(int i = 0; i < count; i++)
                {
                    CGFloat xCoordinate =(CGFloat) (&polygonShape->GetVertex(i))->x;
                    CGFloat yCoordinate = (CGFloat) (&polygonShape->GetVertex(i))->y;
                    CGPoint point = ccpMult(CGPointMake(xCoordinate, yCoordinate), PTM_RATIO);
                    CGPoint boundPoint = CGPointMake(point.x + location.x + offset, point.y + location.y);
                    boundPoint = [[CCDirector sharedDirector] convertToGL: boundPoint];
                    
                    if ( !CGRectContainsPoint(self.boundingBox, boundPoint))
                    {
                        if (boundPoint.x < self.boundingBox.origin.x && boundPoint.y > self.boundingBox.size.height/5 && boundPoint.y < self.boundingBox.size.height*4/5)
                        {
                            NSLog(@"bound point is %f", boundPoint.y);
                            NSLog(@"boundingBox height is %f", self.boundingBox.size.height);
                            [self deleteObjectWithBody:body];
                            objectModified = true;
                            break;
                        }else{
                            [self bounceBackObjectWithBody:body];
                            objectModified = true;
                            NSLog(@"bound point is %f", boundPoint.y);
                            NSLog(@"boundingBox height is %f", self.boundingBox.size.height);
                            break;
                            NSLog(@"Body dragged into walls");
                        }
                    }
                
                    
                    b2Vec2 vertex = b2Vec2(xCoordinate + location.x/PTM_RATIO, yCoordinate + location.y/PTM_RATIO);

                    // Make a small box.
                    b2AABB aabb;
                    b2Vec2 d;
                    // TODO: if want less overlap, make bounding box bigger
                    d.Set(10.0f, 10.0f);
                    aabb.lowerBound = vertex - d;
                    aabb.upperBound = vertex + d;
                    
                    QueryCallback callback(vertex);
                    world->QueryAABB(&callback, aabb);
                    
                    b2Body* b = callback.m_object;
                    
                    if (b && (b != body)) {
                        [self bounceBackObjectWithBody:body];
                        objectModified = true;
                    }
                    
                }
                
                if (objectModified) {
                    break;
                }
                
            }
            
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
            
            _currentMoveableBody = NULL;
        }
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}
}

-(void) bounceBackObjectWithBody: (b2Body*) body
{
    b2Vec2 cmbPosition = _currentMoveableBody->GetPosition();
    std::vector<b2Body*> bodies = ((__bridge AbstractGameObject*)(body->GetUserData()))->_bodies;
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
    {
        
        // TODO: THIS IS WRONG RIGHT NOW
        //NSLog(@"Body number %d", ++j);
        b2Body* body = *i;
        b2Vec2 bodyOffset = body->GetPosition() - cmbPosition;
        body->SetTransform(_initialBodyPosition + bodyOffset, body->GetAngle());
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
    
    [_objectType release];
	
	[super dealloc];
}

@end
