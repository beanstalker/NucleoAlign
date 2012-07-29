//
//  SubstitutionMatrix.m
//  NecleoAlign
//
//  Created by John Hervey on 29/07/12.
//  Copyright (c) 2012 John Hervey. All rights reserved.
//

#import "SubstitutionMatrix.h"

@implementation SubstitutionMatrix

@synthesize gapPenalty;

-(id) init
{
    plusOne = [[NSNumber alloc] initWithInt:1];
    plusTwo = [[NSNumber alloc] initWithInt:2];
    minusOne = [[NSNumber alloc] initWithInt:-1];
    
    a = @"A";
    c = @"C";
    g = @"G";
    t = @"T";
    
    row0 = [[NSArray alloc] initWithObjects:nil, a, c, g, t, nil];
    row1 = [[NSArray alloc] initWithObjects:a, plusTwo, minusOne, plusOne, minusOne, nil];
    row2 = [[NSArray alloc] initWithObjects:c, minusOne, plusTwo, minusOne, plusOne, nil];
    row3 = [[NSArray alloc] initWithObjects:g, plusOne, minusOne, plusTwo, minusOne, nil];
    row4 = [[NSArray alloc] initWithObjects:t, minusOne, plusOne, minusOne, plusTwo, nil];
    
    substitutionMatrix =
    [[NSArray alloc] initWithObjects:row0, row1, row2, row3, row4, nil];
    
    return self;
}

-(int) getValueAtrow:(int)row col:(int)col
{
    return [[[substitutionMatrix objectAtIndex:row + 1] objectAtIndex:col + 1] intValue];
}

-(int) getValueWhen:(const char)base isSubstitutedWith:(const char)otherBase
{
    int row, col;
    
    switch (base) {
        case 'A':
            row = 0;
            break;
        case 'C':
            row = 1;
            break;
        case 'G':
            row = 2;
            break;
        default:
            row = 3;
            break;
    }
    switch (otherBase) {
        case 'A':
            col = 0;
            break;
        case 'C':
            col = 1;
            break;
        case 'G':
            col = 2;
            break;
        default:
            col = 3;
            break;
    }
    return [self getValueAtrow:row col:col];
}

-(void) dealloc
{
    [plusOne release];
    [plusTwo release];
    [minusOne release];
    [a release];
    [c release];
    [g release];
    [t release];
    [row0 release];
    [row1 release];
    [row2 release];
    [row3 release];
    [row4 release];
    [substitutionMatrix release];
    [super dealloc];
}

@end
