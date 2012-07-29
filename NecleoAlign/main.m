//
//  main.m
//  NecleoAlign
//
//  Created by John Hervey on 29/07/12.
//  Copyright (c) 2012 John Hervey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubstitutionMatrix.h"
#import "Sequence.h"

void readFileToSequence(NSString *filepath, Sequence **seq)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *data;
    NSStringEncoding encoding;
    
    if ([fm isReadableFileAtPath:filepath] == NO) {
        NSLog(@"Can't read %@", filepath);
        *seq = nil;
        exit(2);
    }
    data = [NSString stringWithContentsOfFile:filepath
                                 usedEncoding:&encoding
                                        error:nil];
    if (data == nil) {
        data = [NSString stringWithContentsOfFile:filepath
                                         encoding:NSUTF8StringEncoding
                                            error:nil];
        encoding = NSUTF8StringEncoding;
    }
    if (data == nil) {
        NSLog(@"Can't read %@. Check encoding (Try UTF8).", filepath);
        exit(3);
    }
    NSLog(@"Encoding of %@ was %lu", filepath, encoding);
    
    *seq = [[Sequence alloc] initWithSequence:data];
    
    [pool drain];
}

int main(int argc, const char * argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    SubstitutionMatrix *subMat = [[SubstitutionMatrix alloc] init];
    NSProcessInfo *process = [NSProcessInfo processInfo];
    NSArray *args = [process arguments];
    Sequence *seq1, *seq2;
    
    if ([args count] != 3) {
        NSLog(@"Usage: %@ file1 file2", [process processName]);
        return 1;
    }
    
    readFileToSequence([args objectAtIndex:1], &seq1);
    readFileToSequence([args objectAtIndex:2], &seq2);
    
    [pool drain];
    return 0;
}
