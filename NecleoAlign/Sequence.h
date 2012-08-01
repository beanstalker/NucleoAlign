//
//  Sequence.h
//  NecleoAlign
//
//  Created by John Hervey on 29/07/12.
//  Copyright (c) 2012 John Hervey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {RNA, DNA} nucleicAcidType;

@interface Sequence : NSObject
{
    NSString *seq;
    double percentGC;
    nucleicAcidType type;
}

@property (copy, nonatomic) NSString *seq;

-(void) print;
-(BOOL) isEqual:(Sequence *)theSequence;
-(id) initWithSequence:(NSString *)theSequence;
-(double) percentGC;
-(int) length;
-(NSString *) dnaOrRNA;
-(const char) charAtPosition:(int) position;
-(void) dealloc;

@end
