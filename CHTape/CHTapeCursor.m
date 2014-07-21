//
//  CHTapeCursor.m
//
//  Created by Christian Huxtable on 2/21/2014.
//

/*
	Copyright (c) 2014, Christian Huxtable. All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	 * Redistributions of source code must retain the above copyright
	   notice, this list of conditions and the following disclaimer.
	 * Redistributions in binary form must reproduce the above copyright
	   notice, this list of conditions and the following disclaimer in the
	   documentation and/or other materials provided with the distribution.
	 * Neither the name of the CHTapeCursor nor the names of its contributors
	   may be used to endorse or promote products derived from this software
	   without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL CHRISTIAN HUXTABLE BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

@end
