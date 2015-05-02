//
//  CHTape.m
//
//  Created by Christian Huxtable on 20/2/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import "CHTape.h"
#import "CHMutableTape.h"

#import "CHTapeCursor.h"

@implementation CHTape


// Constructors
#pragma mark - Constructors

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
#pragma mark - Initializers

- (instancetype)init
{
	if ( (self = [super init]) )
	{
		_count = 0;
		_head = NULL;
		_tail = NULL;
	}

	return self;
}

- (instancetype)initWithTape:(CHTape *)aTape
{
	if ( (self = [self init]) )
	{
		_count = [aTape count];
		
		for (id object in aTape)
		{
			if (object == nil) continue;
			
			if ( _head == NULL )
			{
				_head = CHMakeTapeNode(object, NULL, NULL);
				_tail = _head;
			}
			else
			{
				_tail->next = CHMakeTapeNode(object, _tail, NULL);
				_tail = _tail->next;
			}
		}
	}
	
	return self;
}

- (instancetype)initWithArray:(NSArray *)anArray
{
	if ( (self = [self init]) )
	{
		_count = [anArray count];
		
		for (id object in anArray)
		{
			if ( _head == NULL )
			{
				_head = CHMakeTapeNode(object, NULL, NULL);
				_tail = _head;
			}
			else
			{
				_tail->next = CHMakeTapeNode(object, _tail, NULL);
				_tail = _tail->next;
			}
		}
	}
	
	return self;
}

- (instancetype)initWithObject:(id)object
{
	if ( (self = [self init]) && object )
	{
		_head = CHMakeTapeNode(object, NULL, NULL);
		_tail = _head;
			
		_count = 1;
	}
	
	return self;
}

- (instancetype)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
	if ( (self = [self init]) )
	{
		va_list args;
		id object = firstObject;
		
		va_start(args, firstObject);
		
		while ( object )
		{
			if ( _head == NULL )
			{
				_head = CHMakeTapeNode(object, NULL, NULL);
				_tail = _head;
			}
			else
			{
				_tail->next = CHMakeTapeNode(object, _tail, NULL);
				_tail = _tail->next;
			}
			
            _count++;
			
			object = va_arg(args, id);
		}
		
		va_end(args);
	}
	
	return self;
}


// Destructor
#pragma mark - Destructor

- (void)dealloc
{
	_count = 0;
	CHTapeNode *zombie;
	
	while ( _head )
	{
		zombie = _head;
		_head = _head->next;
		
		CHReleaseTapeNode(zombie);
	}
	
	[super dealloc];
}


// Copying
#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
    return [[CHTape allocWithZone:zone] initWithTape:self];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
	return [[CHMutableTape allocWithZone:zone] initWithTape:self];
}


// Equality
#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if ( self == object ) { return YES; }
    
    if ( ![object isKindOfClass:[CHTape class]] ) { return NO; }

	return [self isEqualToTape:(CHTape *)object];
}

- (BOOL)isEqualToTape:(CHTape *)tape
{
	if ( !tape || [self count] != [tape count] ) { return NO; }
	
	CHTapeNode *first = _head;
	CHTapeNode *second = tape->_head;
	
	while ( first && second )
	{
		if ( ![first->payload isEqual:second->payload] ) { return NO; }
		
		first = first->next;
		second = second->next;
	}
	
	return YES;
}

- (NSUInteger)hash
{
	return _count ^ [_head->payload hash] ^ [_tail->payload hash];
}


// Properties
#pragma mark - Properties

- (id)firstObject
{
    return ( _head == NULL ) ? nil : _head->payload;
}

- (id)lastObject
{
    return ( _tail == NULL ) ? nil : _tail->payload;
}

- (NSArray *)allObjects
{
	NSMutableArray *array = [NSMutableArray array];
	
	for (id node in self)
	{
		[array addObject:node];
	}
	
	return array;
}


// Emptyness
#pragma mark - Emptyness

- (BOOL)isEmpty
{
    return ( _head == NULL || _tail == NULL );
}


// Description
#pragma mark - Description

- (NSString *)description
{
    CHTapeNode *cursor = _head;
    NSMutableString *string = [[[NSMutableString alloc] initWithString:@"("] autorelease];
    
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


// Enumerators
#pragma mark - Enumerators

- (NSEnumerator *)objectEnumerator
{
	return [self cursor];
}

- (CHTapeCursor *)cursor
{
	return [CHTapeCursor cursorWithTape:self];
}


// Fast Enumeration
#pragma mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])stackBuffer count:(NSUInteger)length
{
    CHTapeNode *cursor = state->state ? (CHTapeNode *)state->extra[0] : _head;
	
    if ( cursor == NULL ) { return 0; }
    
    state->state++;
    state->mutationsPtr = &state->extra[1];
    state->itemsPtr = stackBuffer;
    
	NSUInteger i = 0;
	
	while ( cursor && i < length )
	{
		stackBuffer[i] = cursor->payload;
		cursor = cursor->next;
		i++;
	}
	
	state->extra[0] = (unsigned long)cursor;
	
	return i;
}


// Block Enumeration
#pragma mark - Block Enumeration

- (void)enumerateObjectsUsingBlock:(CHTapeEnumerationBlock)block
{
	NSUInteger index = 0;
	CHTapeNode *cursor = _head;
	
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
		NSUInteger index = _count - 1;
		CHTapeNode *cursor = _tail;
		
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


// Tape Node Functions
#pragma mark - Tape Node Functions

inline CHTapeNode *CHMakeTapeNode(id payload, CHTapeNode *previous, CHTapeNode *next)
{
	CHTapeNode *node = (CHTapeNode *)malloc(sizeof(CHTapeNode));
	
	node->payload = [payload retain];
	node->previous = previous;
	node->next = next;
	
	return node;
}

inline void CHReleaseTapeNode(CHTapeNode *node)
{
	[node->payload release];
	node->payload = nil;
	
	free(node);
}

@end
