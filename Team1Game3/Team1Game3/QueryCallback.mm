//
//  QueryCallback.mm
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/24/13.
//
//

#include "QueryCallback.h"

QueryCallback::QueryCallback(const b2Vec2& point)
{
    m_point = point;
    m_object = nil;
}


b2AABB QueryCallback::getAABB(float boxSize)
{
    b2AABB aabb;
    b2Vec2 d;
    d.Set(boxSize, boxSize);
    aabb.lowerBound = m_point - d;
    aabb.upperBound = m_point + d;
    
    return aabb;
}


b2Body* QueryCallback::getm_object()
{
    return m_object;
}


bool QueryCallback::ReportFixture(b2Fixture* fixture)
{    
    bool inside = fixture->TestPoint(m_point);
    if (inside)
    {
        // We are done, terminate the query.
        m_object = fixture->GetBody();
        return false;
    }
    
    // Continue the query.
    return true;
}
