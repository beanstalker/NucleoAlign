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

void *emalloc(size_t s) {
    void *result = malloc(s);
    if (NULL == result) {
        NSLog(@"Memory allocation failure!");
        exit(1);
    }
    return result;
}

void readFileToSequence(NSString *filepath, Sequence **seq)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *data;
    NSStringEncoding encoding;
    
    if ([fm isReadableFileAtPath:filepath] == NO) {
        NSLog(@"Can't read %@", filepath);
        *seq = nil;
        exit(3);
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
        exit(4);
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
    int **scores;
    
    if ([args count] != 3) {
        NSLog(@"Usage: %@ file1 file2", [process processName]);
        return 2;
    }
    
    readFileToSequence([args objectAtIndex:1], &seq1);
    readFileToSequence([args objectAtIndex:2], &seq2);
    
    scores = emalloc(([seq1 length] + 1) * sizeof scores[0]);
    for (int i = 0; i <= [seq1 length]; i++) {
        scores[i] = emalloc(([seq2 length] + 1) * sizeof scores[i][0]);
    }
    
    for (int i = 0; i <= [seq1 length]; i++) {
        free(scores[i]);
    }
    free(scores);
    [seq1 release];
    [seq2 release];
    [pool drain];
    return 0;
}
