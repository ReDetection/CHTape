//
//  CHTapeCursor.m
//
//  Created by Christian Huxtable on 21/2/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import "CHTapeCursor.h"

@implementation CHTapeCursor


// Static Factories
#pragma mark Static Factories

+ (instancetype)cursorWithTape:(CHTape *)aTape;
{
	return [[[self alloc] initWithTape:aTape] autorelease];
}


// Initializers
#pragma mark Initializers

- (instancetype)init
{
	return self = nil;
}

- (instancetype)initWithTape:(CHTape *)aTape
{
	if (self = [super init])
	{
		index = 0;
		tape = [aTape retain];
		
		next = tape->head;
		previous = NULL;
	}
	
	return self;
}


// Destructor
#pragma mark Destructor

- (void)dealloc
{
	[tape release]; tape = nil;
	
	[super dealloc];
}


// Properties
#pragma mark Properties

@synthesize index;

- (NSArray *)allObjects
{
	return [tape allObjects];
}

- (NSUInteger)count
{
	return tape->count;
}

- (id)firstObject
{
	return tape->head->payload;
}

- (id)lastObject
{
	return tape->tail->payload;
}


// Traversal
#pragma mark Traversal

- (void)moveFirstObject
{
	index = 0;
	next = tape->head;
	previous = NULL;
}

- (void)moveToLastObject
{
	index = tape->count - 1;
	next = NULL;
	previous = tape->tail;
}

- (id)nextObject
{
	if ( next )
	{
		previous = next;
		next = next->next;
		
		index++;
		
		return previous->payload;
	}
	
	return nil;
}

- (id)previousObject
{
	if ( previous )
	{
		next = previous;
		previous = previous->previous;
		
		index--;
		
		return next->payload;
	}
	
	return nil;
}

- (id)nextObjectPeek
{
	return next->payload;
}

- (id)previousObjectPeek
{
	return previous->payload;
}


// Addition/Insertion
#pragma mark Addition/Insertion

- (void)appendObject:(id)anObject
{
	[tape appendObject:anObject];
}

- (void)prependObject:(id)anObject
{
	[tape prependObject:anObject];
}

- (void)insertObjectAfterCursor:(id)anObject
{
	if (anObject == nil) return;
	
	CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
	
	node->payload = [anObject retain];
	
	if ( tape->count )
	{
		node->next = next;
		node->previous = previous;
		
		node->next->previous = node;
		node->previous->next = node;
	}
	else
	{
		next = NULL;
		previous = NULL;
	}
	
	next = node;
	
	tape->count++;
}

- (void)insertObjectBeforeCursor:(id)anObject
{
	if (anObject == nil) return;
	
	CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
	
	if ( tape->count )
	{
		node->payload = [anObject retain];
		
		node->next = next;
		node->previous = previous;
		
		node->next->previous = node;
		node->previous->next = node;
	}
	else
	{
		next = NULL;
		previous = NULL;
	}
	
	previous = node;
	
	tape->count++;
}


// Removal
#pragma mark Removal

- (void)removeLastObject
{
	[tape removeLastObject];
}

- (void)removeFirstObject
{
	[tape removeFirstObject];
}

- (void)removeObjectAfterCursor
{
	// TODO
}

- (void)removeObjectBeforeCursor
{
	// TODO
}

@end
