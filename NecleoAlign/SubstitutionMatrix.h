//
//  SubstitutionMatrix.h
//  NecleoAlign
//
//  Created by John Hervey on 29/07/12.
//  Copyright (c) 2012 John Hervey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubstitutionMatrix : NSObject
{
    NSArray *substitutionMatrix, *row0, *row1, *row2, *row3, *row4;
    NSNumber *plusOne, *plusTwo, *minusOne;
    NSString *a, *c, *g, *t;
    int gapPenalty;
}

@property int gapPenalty;

-(id) init;
-(int) getValueAtrow:(int) row col:(int) col;
-(int) getValueWhen:(const char) base isSubstitutedWith:(const char) otherBase;
-(void) dealloc;

@end
