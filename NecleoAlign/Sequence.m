//
//  Sequence.m
//  NecleoAlign
//
//  Created by John Hervey on 29/07/12.
//  Copyright (c) 2012 John Hervey. All rights reserved.
//

#import "Sequence.h"

@implementation Sequence

@synthesize seq;

-(void) calculateAndSetGCContent
{
    if (seq != nil) {
        int numberGC = 0;
        for (int i = 0; i < [seq length]; i++) {
            if ([seq characterAtIndex:i] == 'G' ||
                [seq characterAtIndex:i] == 'C') {
                numberGC++;
            }
        }
        percentGC = numberGC / [seq length] * 100;
    }
}
-(void) calculateNucleicAcidType
{
    if (seq != nil) {
        for (int i = 0; i < [seq length]; i++) {
            if ([seq characterAtIndex:i] == 'U') {
                type = RNA;
                return;
            }
            if ([seq characterAtIndex:i] == 'T') {
                type = DNA;
                return;
            }
        }
    }
}

-(void) print
{
    NSLog(@"Sequence: %@", seq);
    NSLog(@"Type of nucleic acid: %@", [self dnaOrRNA]);
    NSLog(@"Percent G/C content: %f", percentGC);
}

-(BOOL) isEqual:(Sequence *)theSequence
{
    if ([seq isEqualToString:theSequence.seq]) {
        return YES;
    } else {
        return NO;
    }
}

-(id) initWithSequence:(NSString *)theSequence
{
    self = [super init];
    seq = [[NSString alloc] initWithString:theSequence];
    [self calculateAndSetGCContent];
    [self calculateNucleicAcidType];
    return self;
}

-(double) percentGC
{
    return percentGC;
}

-(NSString *) dnaOrRNA
{
    if (type == RNA) {
        return @"RNA";
    } else {
        return @"DNA";
    }
}

-(void) dealloc
{
    [seq release];
    [super dealloc];
}

@end
