//
//  CHTapeTests.m
//
//  Created by Christian Huxtable on 23/2/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "CHTape.h"

@interface CHTapeTests : XCTestCase
{
	CHTape *tape;
	CHTape *secondTape;
	
	NSArray *array;
}
@end

@implementation CHTapeTests

- (void)setUp
{
	[super setUp];
	
	tape = [[CHTape alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
	
	secondTape = [[CHTape alloc] initWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5"]];
	
	array = [@"0 1 2 3 4 5" componentsSeparatedByString:@" "];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testInitialization
{
	XCTAssertNotNil(tape, @"tape is nil. Initialization Failed.");
	XCTAssertNotNil(secondTape, @"tape is nil. Initialization Failed.");
}

- (void)testCount
{
	NSUInteger count = [tape count];
    
	XCTAssertTrue((count == 6), @"Count of tape is incorrect. Is '%ld', should be '6'.", count);
}

- (void)testHash
{
	NSUInteger hash = [tape hash];
    NSUInteger check = ([tape count] ^ [[tape firstObject] hash] ^ [[tape lastObject] hash]);
    
    XCTAssertTrue(hash == check, @"Hash of tape is incorrect. Is '%ld', should be '%ld'.", hash, check);
}

- (void)testCopy
{
	CHTape *copy;
	NSMutableString *stringRep;
	
	copy = [tape copy];
	stringRep = [[NSMutableString alloc] initWithString:@"@["];
	for (NSString *string in copy)
	{
		[stringRep appendFormat:@"@\"%@\",", string];
	}
	[stringRep deleteCharactersInRange:NSMakeRange([stringRep length] - 1, 1)];
	[stringRep appendString:@"]"];
	
	XCTAssertTrue(([tape isEqualTo:copy]), @"Copy of tape is incorrect. Is %@, should be @[@\"0\",@\"1\",@\"2\",@\"3\",@\"4\",@\"5\"]", stringRep);
	XCTAssertFalse((tape == copy), @"Copy of tape is incorrect. It is a pointer to the same object.");
}

- (void)testDescription
{
	NSString *description;
	NSString *correct = @"(\n\t0,\n\t1,\n\t2,\n\t3,\n\t4,\n\t5\n)";
	
	description = [tape description];
	XCTAssertTrue([correct isEqualToString:description], @"Description of tape is incorrect. Is '%@', should be '0'.", description);
}

- (void)testFirstObject
{
	NSString *payload;
	
	payload = [tape firstObject];
	XCTAssertTrue([@"0" isEqualToString:payload], @"First object in tape is incorrect. Is '%@', should be '0'.", payload);
}

- (void)testLastObject
{
	NSString *payload;
	
	payload = [tape lastObject];
	XCTAssertTrue([@"5" isEqualToString:payload], @"First object in tape is incorrect. Is '%@', should be '5'.", payload);
}

- (void)testAllObjects
{
	XCTAssertTrue([[tape allObjects] isEqualToArray:array], @"Some Objects are Incorrect");
}

- (void)testFastEnumeration
{
	NSString *payload;
	NSString *correct;
	NSUInteger count;
	
	count = 0;
	for (payload in tape)
	{
		XCTAssertNotNil(payload, @"Payload is nil during fast enumeration test in tape. It should be '%ld'.", count);
		correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape during fast enumeration. Is '%@', should be '%ld'.", payload, count);
		count++;
	}
	XCTAssertTrue((6 == count), @"Count of tape is incorrect during fast enumeration. Is '%ld', should be '6'.", count);
}

- (void)testBlockEnumeration
{
	NSUInteger __block count;
	
	count = 0;
	[tape enumerateObjectsUsingBlock:^(NSString *payload, NSUInteger index) {
		XCTAssertNotNil(payload, @"Payload is nil during block enumeration test in tape. It should be '%ld'.", count);
		NSString *correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape during block enumeration. Is '%@', should be '%ld'.", payload, count);
		XCTAssertTrue((index == count), @"Invalid index in tape during block enumeration. Is '%ld', should be '%ld'.", index, count);
		count++;
	} ];
	XCTAssertTrue((6 == count), @"Count of tape is incorrect during block enumeration. Is '%ld', should be '6'.", count);
}

- (void)testBlockEnumerationReverse
{
	NSUInteger __block count;
	count = 6;
	
	[tape enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *payload, NSUInteger index) {
		count--;
		XCTAssertNotNil(payload, @"Payload is nil during reverse block enumeration test in tape. It should be '%ld'.", count);
		NSString *correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape during reverse block enumeration. Is '%@', should be '%ld'.", payload, count);
		XCTAssertTrue((index == count), @"Invalid index in tape during reverse block enumeration. Is '%ld', should be '%ld'.", index, count);
	} ];
	XCTAssertTrue((0 == count), @"Count of tape is incorrect during reverse block enumeration. Last index is '%ld', should be '0'.", count);
}

- (void)testEquity
{
	// Valid
	
	NSMutableString *argsToString = [[NSMutableString alloc] initWithString:@"@["];
	
	for (NSString *string in tape)
	{
		[argsToString appendFormat:@"@\"%@\",", string];
	}
	[argsToString deleteCharactersInRange:NSMakeRange([argsToString length] - 1, 1)];
	[argsToString appendString:@"]"];
	
	NSMutableString *arrayToString = [[NSMutableString alloc] initWithString:@"@["];
	
	for (NSString *string in secondTape)
	{
		[arrayToString appendFormat:@"@\"%@\",", string];
	}
	[arrayToString deleteCharactersInRange:NSMakeRange([argsToString length] - 1, 1)];
	[arrayToString appendString:@"]"];
	
	XCTAssertTrue([tape isEqual:secondTape], @"tape should be equal to tape from array. tape = %@, tape from array = %@", argsToString, arrayToString);
	
	// Too Short
	
	CHTape *incorrectTape = [[CHTape alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
	
	NSMutableString *incorrectTapeToString = [[NSMutableString alloc] initWithString:@"@["];
	
	for (NSString *string in incorrectTape)
	{
		[incorrectTapeToString appendFormat:@"@\"%@\",", string];
	}
	[incorrectTapeToString deleteCharactersInRange:NSMakeRange([incorrectTapeToString length] - 1, 1)];
	[incorrectTapeToString appendString:@"]"];
	
	XCTAssertFalse([tape isEqual:incorrectTape], @"Tape should not be equal to tape from array. tape = %@, tape from array = %@", argsToString, incorrectTapeToString);
	
	// Wrong Element
	
	incorrectTape = [[CHTape alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"6", nil];
	
	incorrectTapeToString = [[NSMutableString alloc] initWithString:@"@["];
	
	for (NSString *string in incorrectTape)
	{
		[incorrectTapeToString appendFormat:@"@\"%@\",", string];
	}
	[incorrectTapeToString deleteCharactersInRange:NSMakeRange([incorrectTapeToString length] - 1, 1)];
	[incorrectTapeToString appendString:@"]"];
	
	XCTAssertFalse([tape isEqualTo:incorrectTape], @"Tape should be equal to tape from array. Tape = %@, tape from array = %@", argsToString, incorrectTapeToString);
	
	// tape == (CHTape *)nil Case Case
	
	XCTAssertFalse([tape isEqualTo:(CHTape *)nil], @"tape should not be equal to nil. Tape = %@", argsToString);
	
	// (CHTape *)nil == (CHTape *)nil Case
	
	XCTAssertFalse([(CHTape *)nil isEqualTo:(CHTape *)nil], @"(CHTape *)nil should not be equal to nil.");
	
	// tape == tape Case
	
	XCTAssertTrue([tape isEqualTo:tape], @"tape should be equal to it self. Tape = %@", argsToString);
	
}

- (void)testAppendObject
{
	NSUInteger count;
	NSString *lastObject;
	
	[tape appendObject:@"6"];
	
	count = [tape count];
	XCTAssertTrue((count == 7), @"Count is incorrect after appending object to tape. Count is %ld, should be '7'.", count);
	
	lastObject = [tape lastObject];
	XCTAssertTrue([lastObject isEqualToString:@"6"], @"Payload of last node is nil after appending object to tape. It is '%@', but should be '6'.", lastObject);
}

- (void)testPrependObject
{
	NSUInteger count;
	NSString *firstObject;
	
	[tape prependObject:@"-1"];
	
	count = [tape count];
	XCTAssertTrue((count == 7), @"Count is incorrect after appending object to tape. Count is %ld, should be '7'.", count);
	
	firstObject = [tape firstObject];
	XCTAssertNotNil(firstObject , @"Payload of first node is nil after prepending object to tape. It should be '4'.");
	XCTAssertTrue([firstObject isEqualToString:@"-1"], @"Payload of first node is  not correct after prepending object to tape. It is '%@', but should be '-1'.", firstObject);
}


- (void)testRemoveLastObject
{
	NSUInteger count;
	NSString *lastObject;
	
	[tape removeLastObject];
	
	count = [tape count];
	XCTAssertTrue((count == 5), @"Count is incorrect after appending object to tape. Count is %ld, should be '5'.", count);
	
	lastObject = [tape lastObject];
	XCTAssertNotNil(lastObject , @"Payload of last node is nil after removing last object from tape. It should be '4'.");
	XCTAssertTrue([lastObject isEqualToString:@"4"], @"Payload of first node is not correct after removing last object from tape. It is '%@', but should be '4'.", lastObject);
}

- (void)testRemoveFirstObject
{
	NSUInteger count;
	NSString *firstObject;
	
	[tape removeFirstObject];
	
	count = [tape count];
	XCTAssertTrue((count == 5), @"Count is incorrect after appending object to tape. Count is %ld, should be '5'.", count);
	
	firstObject = [tape firstObject];
	XCTAssertNotNil(firstObject , @"Payload of first node is nil after removing first object from tape. It should be '1'.");
	XCTAssertTrue([firstObject isEqualToString:@"1"], @"Payload of first node is not correct after removing first object from tape. It is '%@', but should be '1'.", firstObject);
}

@end
