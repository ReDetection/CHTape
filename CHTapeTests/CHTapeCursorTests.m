//
//  CHTapeCursorTests.m
//
//  Created by Christian Huxtable on 2014-02-27.
//  Copyright (c) 2014 Christian Huxtable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CHTape.h"
#import "CHTapeCursor.h"

@interface CHTapeCursorTests : XCTestCase
{
	CHTape *tape;
	
	CHTapeCursor *cursor;
}
@end

@implementation CHTapeCursorTests

- (void)setUp
{
    [super setUp];
    
	tape = [[CHTape alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
	cursor = [tape cursor];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEnumeration
{
	NSEnumerator *enumerator;
	NSString *payload;
	NSUInteger count;
	
	enumerator = [tape objectEnumerator];
	count = 0;
	while ((payload = [enumerator nextObject]))
	{
		XCTAssertNotNil(payload, @"Payload is nil during regular enumeration test in tape from args. It should be '%ld'.", count);
		NSString *correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape from args during regular enumeration. Is '%@', should be '%ld'.", payload, count);
		count++;
	}
	XCTAssertTrue((6 == count), @"Count of tape from args is incorrect during regular enumeration. Last index is '%ld', should be '0'.", count);
}

- (void)testTapeCursor
{
	NSString *payload;
	NSUInteger count;
	
	count = 0;
	while ((payload = [cursor nextObject]))
	{
		XCTAssertNotNil(payload, @"Payload is nil during cursor enumeration test in tape from args. It should be '%ld'.", count);
		NSString *correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape from args during cursor enumeration. Is '%@', should be '%ld'.", payload, count);
		count++;
	}
	XCTAssertTrue((6 == count), @"Count of tape from args is incorrect during cursor enumeration. Last index is '%ld', should be '0'.", count);
}

- (void)testTapeCursorReverse
{
	NSString *payload;
	NSUInteger count;
	
	[cursor moveToLastObject];
	count = 6;
	while ((payload = [cursor previousObject]))
	{
		count--;
		XCTAssertNotNil(payload, @"Payload is nil during reverse cursor enumeration test in tape from args. It should be '%ld'.", count);
		NSString *correct = [NSString stringWithFormat:@"%ld", count];
		XCTAssertTrue([payload isEqualToString:correct], @"Invalid payload object in tape from args during reverse cursor enumeration. Is '%@', should be '%ld'.", payload, count);
	}
	XCTAssertTrue((0 == count), @"Count of tape from args is incorrect during reverse cursor enumeration. Last index is '%ld', should be '0'.", count);
}

- (void)testAppendObject
{
	NSUInteger count;
	NSString *lastObject;
	
	[cursor appendObject:@"6"];
	
	count = [cursor count];
	XCTAssertTrue((count == 7), @"Count is incorrect after appending object to tape. Count is %ld, should be '7'.", count);
	
	lastObject = [cursor lastObject];
	XCTAssertTrue([lastObject isEqualToString:@"6"], @"Payload of last node is nil after appending object to tape. It is '%@', but should be '6'.", lastObject);
}

- (void)testPrependObject
{
	NSUInteger count;
	NSString *firstObject;
	
	[cursor prependObject:@"-1"];
	
	count = [cursor count];
	XCTAssertTrue((count == 7), @"Count is incorrect after appending object to tape. Count is %ld, should be '7'.", count);
	
	firstObject = [cursor firstObject];
	XCTAssertNotNil(firstObject , @"Payload of first node is nil after prepending object to tape. It should be '4'.");
	XCTAssertTrue([firstObject isEqualToString:@"-1"], @"Payload of first node is not correct after prepending object to tape. It is '%@', but should be '-1'.", firstObject);
}

- (void)testInsertObjectAfterCursor
{
	[cursor nextObject];
	[cursor nextObject];
	
	[cursor insertObjectAfterCursor:@"new"];
	
	NSString *object = [cursor nextObject];
	XCTAssertTrue([object isEqualToString:@"new"], @"Payload of inserted node is not correct after inserting object after cursor. It is '%@', but should be 'new'.", object);
	
}

- (void)testInsertObjectBeforeCursor
{
	[cursor nextObject];
	[cursor nextObject];
	
	[cursor insertObjectBeforeCursor:@"new"];
	
	NSString *object = [cursor previousObject];
	XCTAssertTrue([object isEqualToString:@"new"], @"Payload of inserted node is not correct after inserting object before cursor. It is '%@', but should be 'new'.", object);
}

- (void)testRemoveLastObject
{
	NSUInteger count;
	NSString *lastObject;
	
	[cursor removeLastObject];
	
	count = [cursor count];
	XCTAssertTrue((count == 5), @"Count is incorrect after appending object to tape. Count is %ld, should be '5'.", count);
	
	lastObject = [cursor lastObject];
	XCTAssertNotNil(lastObject , @"Payload of last node is nil after removing last object from tape. It should be '4'.");
	XCTAssertTrue([lastObject isEqualToString:@"4"], @"Payload of first node is not correct after removing last object from tape. It is '%@', but should be '4'.", lastObject);
}

- (void)testRemoveFirstObject
{
	NSUInteger count;
	NSString *firstObject;
	
	[cursor removeFirstObject];
	
	count = [cursor count];
	XCTAssertTrue((count == 5), @"Count is incorrect after appending object to tape. Count is %ld, should be '5'.", count);
	
	firstObject = [cursor firstObject];
	XCTAssertNotNil(firstObject , @"Payload of first node is nil after removing first object from tape. It should be '1'.");
	XCTAssertTrue([firstObject isEqualToString:@"1"], @"Payload of first node is not correct after removing first object from tape. It is '%@', but should be '1'.", firstObject);
}

@end
