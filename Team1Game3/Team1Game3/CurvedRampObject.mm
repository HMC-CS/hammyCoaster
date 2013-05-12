//
//  CurvedRampObject.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/5/13.
//
//

#import "CurvedRampObject.h"

@implementation CurvedRampObject
- (std::vector<b2Body*>)createBody:(CGPoint)location {
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *cRamp_Body = _world->CreateBody(&bodyDef);
    
    //---Add Polygons to make curved ramp---//
    
    // Fixture 1/14
    // ---
    b2Vec2 allVertices[30];
    allVertices[0].Set(130.0f / PTM_RATIO, 45.6f / PTM_RATIO);
    allVertices[1].Set(161.4f / PTM_RATIO, 39.3f / PTM_RATIO);
    allVertices[2].Set(117.6f / PTM_RATIO, 22.8f / PTM_RATIO);
    allVertices[3].Set(147.1f / PTM_RATIO, 8.1f / PTM_RATIO);
    allVertices[4].Set(101.0f / PTM_RATIO, 0.1f / PTM_RATIO);
    allVertices[5].Set(126.3f / PTM_RATIO, -16.1f / PTM_RATIO);
    allVertices[6].Set(78.1f / PTM_RATIO, -17.3f / PTM_RATIO);
    allVertices[7].Set(95.4f / PTM_RATIO, -43.2f / PTM_RATIO);
    allVertices[8].Set(53.0f / PTM_RATIO, -30.7f / PTM_RATIO);
    allVertices[9].Set(63.6f / PTM_RATIO, -58.1f / PTM_RATIO);
    allVertices[10].Set(29.4f / PTM_RATIO, -38.4f / PTM_RATIO);
    allVertices[11].Set(38.4f / PTM_RATIO, -67.5f / PTM_RATIO);
    allVertices[12].Set(0.6f / PTM_RATIO, -40.3f / PTM_RATIO);
    allVertices[13].Set(0.6f / PTM_RATIO, -68.5f / PTM_RATIO);
    allVertices[14].Set(-28.2f / PTM_RATIO, -36.9f / PTM_RATIO);
    allVertices[15].Set(-36.2f / PTM_RATIO, -65.5f / PTM_RATIO);
    allVertices[16].Set(-50.4f / PTM_RATIO, -28.9f / PTM_RATIO);
    allVertices[17].Set(-62.6f / PTM_RATIO, -58.1f / PTM_RATIO);
    allVertices[18].Set(-75.9f / PTM_RATIO, -14.9f / PTM_RATIO);
    allVertices[19].Set(-92.8f / PTM_RATIO, -44.5f / PTM_RATIO);
    allVertices[20].Set(-97.2f / PTM_RATIO, 2.7f / PTM_RATIO);
    allVertices[21].Set(-123.5f / PTM_RATIO, -17.1f / PTM_RATIO);
    allVertices[22].Set(-112.9f / PTM_RATIO, 21.6f / PTM_RATIO);
    allVertices[23].Set(-143.7f / PTM_RATIO, 6.9f / PTM_RATIO);
    allVertices[24].Set(-127.8f / PTM_RATIO, 43.3f / PTM_RATIO);
    allVertices[25].Set(-158.7f / PTM_RATIO, 37.7f / PTM_RATIO);
    
    int num = 4;
    b2Vec2 vertices[4];
    
    for(int v = 0; v<12; v++){
        vertices[0] = allVertices[(v*2)+1];
        vertices[1] = allVertices[(v*2)+0];
        vertices[2] = allVertices[(v*2)+2];
        vertices[3] = allVertices[(v*2)+3];
        
        b2PolygonShape cRampShape0;
        cRampShape0.Set(vertices, num);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &cRampShape0; // Set the line shape
        fixtureDef.density = 0.0f; // Set the density
        fixtureDef.friction = 0.5f; // Set the friction
        fixtureDef.restitution = 0.5f; // Set the restitution
        
        // Add shape to the body
        cRamp_Body->CreateFixture(&fixtureDef);
    }
        
        
    //---Done adding shapes---//
    cRamp_Body->SetUserData(self);
    
    _bodies.push_back(cRamp_Body);
    
    return _bodies;
}

@end
