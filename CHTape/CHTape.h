//
//  CHTape.h
//
//  Created by Christian Huxtable on 20/2/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import <Foundation/Foundation.h>

typedef void(^CHTapeEnumerationBlock)(id object, NSUInteger index);

typedef struct CHTapeNode {
	__unsafe_unretained id payload;
	struct CHTapeNode *next;
	struct CHTapeNode *previous;
} CHTapeNode;


@class CHTapeCursor;

@interface CHTape : NSObject <NSFastEnumeration, NSCopying>
{
	@public
	NSUInteger count;
	
	CHTapeNode *head;
	CHTapeNode *tail;
}

// Static Factories
+ (instancetype)tape;
+ (instancetype)tapeWithTape:(CHTape *)aTape;
+ (instancetype)tapeWithArray:(NSArray *)anArray;
+ (instancetype)tapeWithObject:(id)anObject;

// Initializers
- (instancetype)init;
- (instancetype)initWithTape:(CHTape *)aTape;
- (instancetype)initWithArray:(NSArray *)anArray;
- (instancetype)initWithObject:(id)anObject;
- (instancetype)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

// Destructor
- (void)dealloc;

// Equality
- (BOOL)isEqual:(id)otherObject;
- (BOOL)isEqualToTape:(CHTape *)otherTape;
- (NSUInteger)hash;

// Properties
@property(readonly) NSUInteger count;
@property(readonly) id firstObject;
@property(readonly) id lastObject;
@property(readonly) NSArray *allObjects;

// Enumerations
- (NSEnumerator *)objectEnumerator;
- (CHTapeCursor *)cursor;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])stackbuf count:(NSUInteger)stackbufLength;
- (void)enumerateObjectsUsingBlock:(CHTapeEnumerationBlock)block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options usingBlock:(CHTapeEnumerationBlock)block;

// Node Addition
- (void)appendObject:(id)anObject;
- (void)prependObject:(id)anObject;

// Node Removal
- (void)removeLastObject;
- (void)removeFirstObject;

@end
