//
//  StarObject.m
//  Team1Game3
//
//  Created by William O'Brien on 3/20/13.
//
//

#import "StarObject.h"

@implementation StarObject

//stars have the same shape/size as a blue portal for now

- (b2Body *)createBody:(CGPoint)location {
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *star_Body = _world->CreateBody(&_bodyDef);
    
    b2Vec2 vertices[5];
    int num = 5;
    vertices[0].Set(0.0f / PTM_RATIO, 21.2f / PTM_RATIO);
    vertices[1].Set(-21.4f / PTM_RATIO, 3.7f / PTM_RATIO);
    vertices[2].Set(-12.9f / PTM_RATIO, -19.9f / PTM_RATIO);
    vertices[3].Set(14.1f / PTM_RATIO, -20.8f / PTM_RATIO);
    vertices[4].Set(22.4f / PTM_RATIO, 3.5f / PTM_RATIO);
    
    b2PolygonShape starShape;
    starShape.Set(vertices, num);
    
    //b2FixtureDef _fixtureDef;
    _fixtureDef.shape = &starShape; // Set the line shape
    _fixtureDef.isSensor = TRUE; // make the star a sensor (no interaction with other bodies)
    
    // Add the shape to the body
    star_Body->CreateFixture(&_fixtureDef);
    star_Body->SetUserData(self);
 
    return star_Body;
}

@end
