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
     * Returns an AABB of size boxSize centered at the point specified in the constructor.
     */
    b2AABB getAABB(float boxSize);
    
    /* getm_object
     * Returns the body found at the point specified in the constructor.
     */
    b2Body* getm_object();
    
    
private:
    
    /* ReportFixture
     * Overwrites b2QueryCallback's ReportFixture to ignore censors.
     */
    bool ReportFixture(b2Fixture* fixture);
    
    b2Vec2  m_point;            // The center point for the query
    b2Body* m_object;           // The body found at or near m_point
};