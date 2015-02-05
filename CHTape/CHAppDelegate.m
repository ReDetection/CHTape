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

#import "CHMutableTape.h"
#import "CHTapeCursor.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

@implementation CHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//[outputString release];
	
	[self testSpeed];
	//[self testAccuracy];
	//[self testRemoval];
	
	//[self testPrinting];
}

- (void)testSpeed
{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	CHMutableTape *tape = [[CHMutableTape alloc] init];
	unsigned long long start;
	
	unsigned long long tapeDur;
	unsigned long long arrayDur;
	
	unsigned long long tapeAccessAverage = 0;
	unsigned long long arrayAccessAverage = 0;
	
	unsigned long long tapeInsertionAverage = 0;
	unsigned long long arrayInsertionAverage = 0;
	
	NSUInteger iterations = 10000;
	
	
	// Insertion
	{
		start = mach_absolute_time();
		for (NSUInteger i = 0; i <= iterations; i++)
		{
			[tape appendObject:[NSString stringWithFormat:@"%lu", i]];
		}
		tapeDur = mach_absolute_time() - start;
		
		start = mach_absolute_time();
		for (NSUInteger i = 0; i <= iterations; i++)
		{
			[array addObject:[NSString stringWithFormat:@"%lu", i]];
		}
		arrayDur = mach_absolute_time() - start;
		
		
		// Results
		
		tapeInsertionAverage += (tapeDur/[tape count]);
		arrayInsertionAverage += (arrayDur/[array count]);
	}
	
	
	// Access
	{
		NSInteger value = 0;
		
		// CHTape
		
		start = mach_absolute_time();
		for (NSString *string in tape)
		{
			// Do some work so optimizer doesn't remove loop.
			value += [string integerValue];
		}
		tapeDur = mach_absolute_time() - start;
		
		
		// NSArray
		
		start = mach_absolute_time();
		for (NSString *string in array)
		{
			// Do some work so optimizer doesn't remove loop.
			value += [string integerValue];
		}
		arrayDur = mach_absolute_time() - start;
			
			
		// Results
		
		tapeAccessAverage = (tapeDur/[tape count]);
		arrayAccessAverage = (arrayDur/[array count]);
	}

	NSLog(@"Tape Average Access Time (ns): %lld", tapeAccessAverage);
	NSLog(@"Array Average Access Time (ns): %lld", arrayAccessAverage);
	
	NSLog(@"Tape Average Insertion Time (ns): %lld", tapeInsertionAverage);
	NSLog(@"Array Average Insertion Time (ns): %lld", arrayInsertionAverage);
}

- (void)testAccuracy
{
	CHMutableTape *tape = [[CHMutableTape alloc] init];
	
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
	CHMutableTape *tape = [[CHMutableTape alloc] init];
	
	[tape appendObject:@"This"];
	[tape appendObject:@"Is"];
	[tape appendObject:@"A"];
	[tape appendObject:@"Linked"];
	[tape appendObject:@"List"];
	
	//NSMutableString * result = [NSMutableString string];
}

- (void)testPrinting
{
	CHMutableTape *tape = [[CHMutableTape alloc] init];
	
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
