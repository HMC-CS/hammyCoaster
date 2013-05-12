//
//  MagnetObject.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/16/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import "MagnetObject.h"


@implementation MagnetObject

- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = self->_world->CreateBody(&bodyDef);
    
    // TODO: magnet with north and south poles
    NSLog(@"trying to get sprite bounding box");
    
    CCSprite* sprite = [_sprites objectAtIndex:0];
    
    float objectWidth = 100;//sprite.contentSize.width;
    float objectHeight = 32;//sprite.contentSize.height;
    
    NSLog(@"starting north shape");
    b2PolygonShape northShape;
    b2Vec2 northCenter = b2Vec2(objectWidth/PTM_RATIO/4, 0);
    northShape.SetAsBox(objectWidth/PTM_RATIO/4, objectHeight/PTM_RATIO/2, northCenter, 0);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &northShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.3f;
    fixtureDef.userData = @"NORTH";
    body->CreateFixture(&fixtureDef);
    
    NSLog(@"starting south shape");
    b2PolygonShape southShape;
    b2Vec2 southCenter = b2Vec2(-1.0 * objectWidth/PTM_RATIO/4, 0);
    southShape.SetAsBox(objectWidth/PTM_RATIO/4, objectHeight/PTM_RATIO/2, southCenter, 0);
    fixtureDef.shape = &southShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.3f;
    fixtureDef.userData = @"SOUTH";
    body->CreateFixture(&fixtureDef);
    
    body->SetUserData(self);
    
    _bodies.push_back(body);
    
    return _bodies;
}

@end
