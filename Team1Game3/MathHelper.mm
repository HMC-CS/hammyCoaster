//
//  MathHelper.c
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 5/9/13.
//
//

#include "MathHelper.h"

#import "Box2D.h"  // For M_PI

/* GetAngle
 * Gets the angle between two points with coordinates (x1, y1) and (x2,y2).
 * Returns the angle in radians.
 */
float GetAngle(float x1, float y1, float x2, float y2) {
    float dx, dy, res;
    
    dx = x1 - x2;
    dy = y1 - y2;
    
    //printf("dx=%f dy=%f   x1=%f, y1=%f,  x2=%f, y2=%f\n", dx, dy, x1, y1, x2, y2);
    if ( fabs(dx) < 0.0000001f && fabs(dy) < 0.0000001f ) {
        return 0;
    }
    
    if ( dx == 0 && y1 > y2 ) {   return 0;   }
    if ( dy == 0 && x1 < x2 ) {   return (0.5 * M_PI);  }
    if ( dx == 0 && y1 < y2 ) {   return M_PI; }
    if ( dy == 0 && x1 > x2 ) {   return (M_PI + (0.5 * M_PI)); }
    
    res = atanf( dy / dx );
    //printf("res angle=%f", res);
    if ( res < 0 ) {
        res = (0.5 * M_PI) + res;
    }
    
    if ( x1 > x2  && y1 < y2 ) {   	// 2nd quadrant
        res += 0.5 * M_PI;
    } else if ( x1 > x2 && y1 > y2 ) { 		// 3rd quadrant
        res += M_PI;
    } else if ( x1 < x2 && y1 > y2 ) {		// 4th quadrant
        res += M_PI + (0.5 * M_PI);
    }
    //printf("res angle after=%f", res);
    return res;
}