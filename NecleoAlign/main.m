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

//C style memory allocation function with basic error check
void *emalloc(size_t s) {
    void *result = malloc(s);
    if (NULL == result) {
        NSLog(@"Memory allocation failure!");
        exit(1);
    }
    return result;
}

//Read input files to a Sequence class
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

int maxOfThree(int diagonal, int below, int above)
{
    int max;
    max = diagonal > below ? diagonal : below;
    max = max > above ? max : above;
    return max;
}

int main(int argc, const char * argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    SubstitutionMatrix *subMat = [[SubstitutionMatrix alloc] init];
    NSProcessInfo *process = [NSProcessInfo processInfo];
    NSArray *args = [process arguments];
    Sequence *seq1, *seq2;
    int **scores;
    typedef enum {done, diag, left, up} trace;
    trace **traceback;
    
    [subMat setGapPenalty:-2];
    
    //Read sequences from input files given as aruments
    if ([args count] != 3) {
        NSLog(@"Usage: %@ file1 file2", [process processName]);
        return 2;
    }
    readFileToSequence([args objectAtIndex:1], &seq1);
    readFileToSequence([args objectAtIndex:2], &seq2);
    [seq1 print];
    [seq2 print];
    
    //Allocate memory for scores and traceback arrays based on sequence length
    scores = emalloc(([seq1 length] + 1) * sizeof scores[0]);
    traceback = emalloc(([seq1 length] + 1) * sizeof traceback[0]);
    for (int i = 0; i <= [seq1 length]; i++) {
        scores[i] = emalloc(([seq2 length] + 1) * sizeof scores[i][0]);
        traceback[i] = emalloc(([seq2 length] + 1) * sizeof traceback[i][0]);
    }
    
    //Initialise scores and traceback matrices
    scores[0][0] = 0;
    traceback[0][0] = done;
    //Going down
    for (int j = 1; j <= [seq1 length]; j++) {
        scores[j][0] = [subMat gapPenalty] * j;
        traceback[j][0] = up;
    }
    //Going accross
    for (int i = 1; i <= [seq2 length]; i++) {
        scores[0][i] = [subMat gapPenalty] * i;
        traceback[0][i] = left;
    }
    
    //Calculate scores and traceback
    for (int j = 1; j <= [seq1 length]; j++) {
        for (int i = 1; i <= [seq2 length]; i++) {
            scores[j][i] = maxOfThree(scores[j - 1][i - 1] + [subMat getValueWhen:[seq1 charAtPosition:(j - 1)] isSubstitutedWith:[seq2 charAtPosition:(i - 1)]],
                                      scores[j][i - 1] + [subMat gapPenalty],
                                      scores[j - 1][i] + [subMat gapPenalty]);
            
            if (scores[j][i] == scores[j - 1][i - 1] + [subMat getValueWhen:[seq1 charAtPosition:(j - 1)] isSubstitutedWith:[seq2 charAtPosition:(i - 1)]]) {
                traceback[j][i] = diag;
            } else if (scores[j][i] == scores[j][i - 1] + [subMat gapPenalty]) {
                traceback[j][i] = left;
            } else {
                traceback[j][i] = up;
            }
        }
    }
    //Print scores matrix
    for (int j = 0; j <= [seq1 length]; j++) {
        for (int i = 0; i <= [seq2 length]; i++) {
            printf("%3i ", scores[j][i]);
        }
        printf("\n");
    }
    printf("\n");
    //Print traceback matrix
    for (int j = 0; j <= [seq1 length]; j++) {
        for (int i = 0; i <= [seq2 length]; i++) {
            if (traceback[j][i] == done) {
                printf(" done ");
            } else if (traceback[j][i] == diag) {
                printf(" diag ");
            } else if (traceback[j][i] == left) {
                printf(" left ");
            } else {
                printf("   up ");
            }
        }
        printf("\n");
    }
    printf("\n");
    
    //Print maximum score
    NSLog(@"Maximum score is: %i", scores[[seq1 length]][[seq2 length]]);
    
    //Follow traceback
    int i = [seq2 length];
    int j = [seq1 length];
    int count = 0;
    //trace tracer = traceback[[seq2 length]][[seq1 length]];
    int maxLength = [seq2 length] * [seq1 length];
    char *reverseAlign1, *reverseAlign2;
    reverseAlign1 = emalloc(maxLength * sizeof(reverseAlign1[0]));
    reverseAlign2 = emalloc(maxLength * sizeof(reverseAlign2[0]));
    
    do {
        //or while (trace != done) {
        if (traceback[j][i] == diag) {
            reverseAlign1[count] = [seq1 charAtPosition:(j - 1)];
            reverseAlign2[count] = [seq2 charAtPosition:(i - 1)];
            count++;
            i--;
            j--;
        } else if (traceback[j][i] == left) {
            reverseAlign1[count] = '-';
            reverseAlign2[count] = [seq2 charAtPosition:(i - 1)];
            count++;
            i--;
        } else if (traceback[j][i] == up) {
            reverseAlign1[count] = [seq1 charAtPosition:(j - 1)];
            reverseAlign2[count] = '-';
            count++;
            j--;
        } else {
            break;
        }
    } while (j != 0 && i != 0);
    
    //Print in reverse
    for (int k = count - 1; k >= 0; k--) {
        printf("%c", reverseAlign1[k]);
    }
    printf("\n");
    for (int k = count - 1; k >= 0; k--) {
        printf("%c", reverseAlign2[k]);
    }
    printf("\n");
    
    
    //Deallocate memory
    for (int i = 0; i < [seq1 length]; i++) {
        free(scores[i]);
        free(traceback[i]);
    }
    free(scores);
    free(traceback);
    free(reverseAlign2);
    free(reverseAlign1);
    [seq1 release];
    [seq2 release];
    [subMat release];
    [pool drain];
    return 0;
}
