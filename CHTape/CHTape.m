//
//  CHTape.m
//
//  Created by Christian Huxtable on 2/20/2014.
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


#import "CHTape.h"

#import "CHTapeCursor.h"

@implementation CHTape


// Static Factories
#pragma mark Static Factories

+ (instancetype)tape
{
    return [[[self alloc] init] autorelease];
}

+ (instancetype)tapeWithTape:(CHTape *)aTape
{
    return [[[self alloc] initWithTape:aTape] autorelease];
}

+ (instancetype)tapeWithArray:(NSArray *)anArray
{
    return [[[self alloc] initWithArray:anArray] autorelease];
}

+ (instancetype)tapeWithObject:(id)anObject
{
    return [[[self alloc] initWithObject:anObject] autorelease];
}


// Initializers
#pragma mark Initializers

- (instancetype)init
{
	if ( (self = [super init]) )
	{
		count = 0;
		head = NULL;
		tail = NULL;
	}

    return self;
}

- (instancetype)initWithTape:(CHTape *)aTape
{
	if ( (self = [self init]) )
	{
		for (id anObject in aTape)
		{
			if (anObject == nil) continue;
			
			CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
			
			node->payload = [anObject retain];
			node->next = NULL;
			
			if (!count)
			{
				head = node;
				node->previous = NULL;
			}
			else
			{
				node->previous = tail;
				tail->next = node;
			}
			
			tail = node;
			
			count++;
		}
	}
	
    return self;
}

- (instancetype)initWithArray:(NSArray *)anArray
{
	if ( (self = [self init]) )
	{
		for (id anObject in anArray)
		{
			if (anObject == nil) continue;
			
			CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
			
			node->payload = [anObject retain];
			node->next = NULL;
			
			if (!count)
			{
				head = node;
				node->previous = NULL;
			}
			else
			{
				node->previous = tail;
				tail->next = node;
			}
			
			tail = node;
			
			count++;
		}
	}
	
    return self;
}

- (instancetype)initWithObject:(id)anObject
{
	if ( (self = [self init]) && anObject )
	{
		CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
			
		node->payload = [anObject retain];
		node->next = NULL;
			
		head = node;
		node->previous = NULL;
		tail = node;
			
		count = 1;
	}
	
    return self;
}

- (instancetype)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
{
	if ( (self = [self init]) )
	{
		va_list args;
		id anObject = firstObject;
		va_start(args, firstObject);
		while ( anObject )
		{
			CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
			
			node->payload = [anObject retain];
			node->next = NULL;
			
			if (!count)
			{
				head = node;
				node->previous = NULL;
			}
			else
			{
				node->previous = tail;
				tail->next = node;
			}
			
			tail = node;
			
			count++;
			
			anObject = va_arg(args, id);
		}
		va_end(args);
	}
	
    return self;
}


// Copier
#pragma mark Copier

- (instancetype)copyWithZone:(NSZone *)zone
{
	return [[CHTape allocWithZone:zone] initWithTape:self];
}


// Destructor
#pragma mark Destructor

- (void)dealloc
{
	count = 0;
	CHTapeNode *zombie;
	
	while ( head )
	{
		zombie = head;
		head = head->next;
		
		[zombie->payload release];
		zombie->payload = nil;
		
		free(zombie);
	}
	
	[super dealloc];
}


// Equality
#pragma mark Equality

- (BOOL)isEqual:(id)otherObject
{
	if ( [self class] == [otherObject class] )
	{
        return [self isEqualToTape:otherObject];
    }
	
	return [super isEqual:otherObject];
}

- (BOOL)isEqualToTape:(CHTape *)otherTape
{
	if ( self == otherTape)
	{
		return !!otherTape;
	}
	
	if ( [self count] != [otherTape count] )
	{
		return NO;
	}
	
	CHTapeNode *first = head;
	CHTapeNode *second = otherTape->head;
	
	while ( first && second )
	{
		if ( ![first->payload isEqualTo:second->payload] )
		{
			return NO;
		}
		
		first = first->next;
		second = second->next;
	}
	
	return YES;
}

- (NSUInteger)hash
{
	return count;
}


// Properties
#pragma mark Properties

@synthesize count;

- (id)firstObject
{
	if ( head )
	{
		return head->payload;
	}
	
	return nil;
}

- (id)lastObject
{
	if ( tail )
	{
		return tail->payload;
	}
	
	return nil;
}

- (NSArray *)allObjects
{
	CHTapeNode *node = head;
	NSMutableArray *array = [NSMutableArray array];
	
	while ( node )
	{
		[array addObject:node->payload];
		
		node = node->next;
	}
	
	return array;
}

- (NSString *)description
{
	CHTapeNode *cursor = head;
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"("];
	
	if ( cursor )
	{
		[string appendFormat:@"\n\t%@", cursor->payload];
		cursor = cursor->next;
	}
	
	while ( cursor )
	{
		[string appendFormat:@",\n\t%@", cursor->payload];
		cursor = cursor->next;
	}
	
	[string appendString:@"\n)"];
	
	return string;
}


// Enumerations
#pragma mark Enumerations

- (NSEnumerator *)objectEnumerator
{
	return [self cursor];
}

- (CHTapeCursor *)cursor
{
	return [CHTapeCursor cursorWithTape:self];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])stackBuffer count:(NSUInteger)len
{
	CHTapeNode *cursor;
	
    if (!state->state)
	{
		state->state++;
        state->mutationsPtr = &state->extra[1];
		cursor = head;
		state->itemsPtr = stackBuffer;
    }
	else
	{
		cursor = (CHTapeNode *)state->extra[0];
	}
	
	if ( !cursor )
	{
		return 0;
	}
	
	NSUInteger i = 0;
	
    while ( cursor && i < len )
	{
        stackBuffer[i] = cursor->payload;
        cursor = cursor->next;
		i++;
    }
    
	state->extra[0] = (unsigned long)cursor;
	
    return i;
}

- (void)enumerateObjectsUsingBlock:(CHTapeEnumerationBlock)block
{
	NSUInteger index = 0;
	CHTapeNode *cursor = head;
	
	while ( cursor )
	{
		block(cursor->payload, index);
		
		cursor = cursor->next;
		index++;
	}
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options usingBlock:(CHTapeEnumerationBlock)block
{
	if ( (options & NSEnumerationReverse) )
	{
		NSUInteger index = count - 1;
		CHTapeNode *cursor = tail;
		
		while ( cursor )
		{
			block(cursor->payload, index);
			
			cursor = cursor->previous;
			index--;
		}
	}
	else
	{
		[self enumerateObjectsUsingBlock:block];
	}
}


// Node Addition
#pragma mark Node Addition

- (void)appendObject:(id)anObject
{
	if (anObject == nil) return;
	
	CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
	
	node->payload = [anObject retain];
	node->next = NULL;
	
	if (!count)
	{
		head = node;
		node->previous = NULL;
	}
	else
	{
		node->previous = tail;
		tail->next = node;
	}
	
	tail = node;
	
	count++;
}

- (void)prependObject:(id)anObject
{
	if (anObject == nil) return;
	
	CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
	
	node->payload = [anObject retain];
	node->previous = NULL;
	
	if (!count)
	{
		tail = node;
		node->next = NULL;
	}
	else
	{
		node->next = head;
		head->previous = node;
	}
	
	head = node;
	
	count++;
}


// Node Removal
#pragma mark Node Removal

- (void)removeLastObject
{
	if ( tail )
	{
		CHTapeNode *zombie = tail;
		tail = tail->previous;
		tail->next = NULL;
		
		[zombie->payload release];
		zombie->payload = nil;
		
		free(zombie);
		
		count--;
	}
}

- (void)removeFirstObject
{
	if ( head )
	{
		CHTapeNode *zombie = head;
		head = head->next;
		head->previous = NULL;
		
		[zombie->payload release];
		zombie->payload = nil;
		
		free(zombie);
		
		count--;
	}
}

@end
