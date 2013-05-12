//
//  QueryCallback.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/24/13.
//
//

#import "cocos2d.h"
#import "Box2D.h"

class QueryCallback : public b2QueryCallback
{
public:
    
    /* QueryCallback
     * Constructor
     */
    QueryCallback(const b2Vec2& point);
    
    /* getAABB
     * (DESCRIPTION)
     */
    b2AABB getAABB(float boxSize);
    
    /* getm_object
     * (DESCRIPTION)
     */
    b2Body* getm_object();
    
    
private:
    
    /* ReportFixture
     * (DESCRIPTION)
     */
    bool ReportFixture(b2Fixture* fixture);
    
    b2Vec2  m_point;            // (DESCRIPTION)
    b2Body* m_object;           // (DESCRIPTION)
};