//
//  CHAppDelegate.m
//
//  Created by Christian Huxtable on 12/3/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import "CHAppDelegate.h"

#import "CHTapeCursor.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

@implementation CHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//[outputString release];
	
	//[self testSpeed];
	//[self testAccuracy];
	//[self testRemoval];
	
	//[self testPrinting];
}

- (void)testSpeed
{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	CHTape *tape = [[CHTape alloc] init];
	unsigned long long start;
	
	unsigned long long tapeDur;
	unsigned long long arrayDur;
	
	unsigned long long tapeAverage = 0;
	unsigned long long arrayAverage = 0;
	
	NSMutableString * tapeAccessResult = [NSMutableString stringWithString:@"tapeAccessData = {"];
	NSMutableString * arrayAccessResult = [NSMutableString stringWithString:@"arrayAccessData = {"];
	
	NSMutableString * tapeIterationResult = [NSMutableString stringWithString:@"tapeIterationData = {"];
	NSMutableString * arrayIterationResult = [NSMutableString stringWithString:@"arrayIterationData = {"];
	
	NSString *string;
	
	NSUInteger iterations = 10000;
	unsigned long long average = 0;
	
	for (NSUInteger i = 1; i <= iterations; i++)
	{
		[tape appendObject:@""];
		[array addObject:@""];
		
		// CHTape
		
		start = mach_absolute_time();
		for (string in tape)
		{
			
		}
		tapeDur = mach_absolute_time() - start;
		
		
		// NSArray
		
		start = mach_absolute_time();
		for (string in array)
		{
			
		}
		arrayDur = mach_absolute_time() - start;
		
		
		// Results
		
		average = tapeDur/[tape count];
		[tapeAccessResult appendFormat:@"{%ld,%lld}", i, average];
		[tapeIterationResult appendFormat:@"{%ld,%lld}", i, tapeDur];
		
		average = arrayDur/[array count];
		[arrayAccessResult appendFormat:@"{%ld,%lld}", i, average];
		[arrayIterationResult appendFormat:@"{%ld,%lld}", i, (arrayDur)];
		
		tapeAverage += (tapeDur/[tape count]);
		arrayAverage += (arrayDur/[array count]);
		
		if ( i != iterations)
		{
			[tapeAccessResult appendString:@","];
			[arrayAccessResult appendString:@","];
			
			[tapeIterationResult appendString:@","];
			[arrayIterationResult appendString:@","];
		}
		
	}
	
	[tapeAccessResult appendString:@"};\n"];
	[arrayAccessResult appendString:@"};\n"];
	[tapeIterationResult appendString:@"};\n"];
	[arrayIterationResult appendString:@"};\n"];
	
	NSMutableString *plot = [[NSMutableString alloc] init];
	
	[plot appendString:tapeAccessResult];
	[plot appendString:arrayAccessResult];
	[plot appendString:tapeIterationResult];
	[plot appendString:arrayIterationResult];
	
	[plot appendString:@"ListPlot[{tapeAccessData, arrayAccessData}, ImageSize -> {1280, 720}, AxesLabel -> {Elements,Nanoseconds}, PlotLabel -> \"Access Speeds to Individual Elements\", Joined -> False, PlotLegends -> {\"CHTape\", \"NSArray\"}]\n"];
	[plot appendString:@"ListPlot[{tapeIterationData, arrayIterationData}, ImageSize -> {1280, 720}, AxesLabel -> {Elements,Nanoseconds}, PlotLabel -> \"Time to Iterate Over All Elements\", Joined -> True, PlotLegends -> {\"CHTape\", \"NSArray\"}]"];
	
	[plot writeToFile:[@"~/Desktop/results.txt" stringByExpandingTildeInPath] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	
	//NSLog(@"%@", plot);
	
	NSLog(@"Tape Average : %lld", tapeAverage/iterations);
	NSLog(@"Array Average: %lld", arrayAverage/iterations);
}

- (void)testAccuracy
{
	CHTape *tape = [[CHTape alloc] init];
	
	[tape appendObject:@"This"];
	[tape appendObject:@"Is"];
	[tape appendObject:@"A"];
	[tape appendObject:@"Linked"];
	[tape appendObject:@"List"];
	
	NSMutableString * result = [NSMutableString string];
	
	// NSEnumerator
	
	NSEnumerator *enumerator = [tape objectEnumerator];
	NSString *string;
	
	unsigned long long start = mach_absolute_time();
	while ((string = [enumerator nextObject]))
	{
		[result appendFormat:@" %@", string];
	}
	unsigned long long evalDuration = mach_absolute_time() - start;
	
	NSLog(@"NSEnumerator(%lld):%@", evalDuration/[tape count], result);
	result = [NSMutableString string];
	
	// CHTapeCursor
	
	CHTapeCursor *cursor = [tape cursor];
	start = mach_absolute_time();
	while ((string = [cursor nextObject]))
	{
		[result appendFormat:@" %@", string];
	}
	evalDuration = mach_absolute_time() - start;
	
	NSLog(@"CHCursor(%lld):%@", evalDuration/[tape count], result);
	result = [NSMutableString string];
	
	// NSFastEnumeration
	
	start = mach_absolute_time();
	for (NSString *string in tape)
	{
		[result appendFormat:@" %@", string];
	}
	evalDuration = mach_absolute_time() - start;
	
	NSLog(@"NSFastEnumerator(%lld):%@", evalDuration/[tape count], result);
	result = [NSMutableString string];
	
	// Block Enumeration
	
	start = mach_absolute_time();
	
	[tape enumerateObjectsUsingBlock:^(id object, NSUInteger index){
		[result appendFormat:@" %@", object];
	} ];
	
	evalDuration = mach_absolute_time() - start;
	
	NSLog(@"Block Enumeration(%lld):%@", evalDuration/[tape count], result);
	result = [NSMutableString string];
	
	// Block Enumeration with Options (unset)
	
	start = mach_absolute_time();
	
	[tape enumerateObjectsWithOptions:0 usingBlock:^(id object, NSUInteger index){
		[result appendFormat:@" %@", object];
	} ];
	
	evalDuration = mach_absolute_time() - start;
	
	NSLog(@"Block Enumeration with Options (unset)(%lld):%@", evalDuration/[tape count], result);
	result = [NSMutableString string];
	
	// Block Enumeration with Options (reversed)
	
	start = mach_absolute_time();
	
	[tape enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger index){
		[result appendFormat:@" %@", object];
	} ];
	
	evalDuration = mach_absolute_time() - start;
	
	NSLog(@"Block Enumeration with Options (reversed)(%lld):%@", evalDuration/[tape count], result);
}

- (void)testRemoval
{
	CHTape *tape = [[CHTape alloc] init];
	
	[tape appendObject:@"This"];
	[tape appendObject:@"Is"];
	[tape appendObject:@"A"];
	[tape appendObject:@"Linked"];
	[tape appendObject:@"List"];
	
	//NSMutableString * result = [NSMutableString string];
}

- (void)testPrinting
{
	CHTape *tape = [[CHTape alloc] init];
	
	[tape appendObject:@"This"];
	[tape appendObject:@"Is"];
	[tape appendObject:@"A"];
	[tape appendObject:@"Test"];
	[tape appendObject:@"Tape"];
	
	NSLog(@"Tape: %@", tape);
	
	NSArray *array = [@"This is a Test Array" componentsSeparatedByString:@" "];
	NSLog(@"Array: %@", array);
}

@end
