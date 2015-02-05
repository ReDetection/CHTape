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
	id payload;
	struct CHTapeNode *next;
	struct CHTapeNode *previous;
} CHTapeNode;


@class CHTapeCursor;

@interface CHTape : NSObject <NSCopying, NSMutableCopying, NSFastEnumeration>
{
    @public
    CHTapeNode *_head;
    CHTapeNode *_tail;
    
	NSUInteger _count;
}


// Constructors
#pragma mark - Constructors

+ (instancetype)tape;
+ (instancetype)tapeWithTape:(CHTape *)aTape;
+ (instancetype)tapeWithArray:(NSArray *)anArray;
+ (instancetype)tapeWithObject:(id)anObject;


// Initializers
#pragma mark - Initializers

- (instancetype)init;
- (instancetype)initWithTape:(CHTape *)aTape;
- (instancetype)initWithArray:(NSArray *)anArray;
- (instancetype)initWithObject:(id)anObject;
- (instancetype)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;


// Destructor
#pragma mark - Destructor

- (void)dealloc;


// Copying
#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone;


// Equality
#pragma mark - Equality

- (BOOL)isEqual:(id)object;
- (BOOL)isEqualToTape:(CHTape *)tape;

- (NSUInteger)hash;


// Properties
#pragma mark - Properties

@property(readonly, nonatomic) NSUInteger count;
@property(readonly, nonatomic) id firstObject;
@property(readonly, nonatomic) id lastObject;
@property(readonly, nonatomic) NSArray *allObjects;


// Emptyness
#pragma mark - Emptyness

@property(readonly, nonatomic) BOOL isEmpty;


// Description
#pragma mark - Description

- (NSString *)description;


// Enumerators
#pragma mark - Enumerators

- (NSEnumerator *)objectEnumerator;
- (CHTapeCursor *)cursor;


// Fast Enumeration
#pragma mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])stackBuffer count:(NSUInteger)length;


// Block Enumeration
#pragma mark - Block Enumeration

- (void)enumerateObjectsUsingBlock:(CHTapeEnumerationBlock)block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options usingBlock:(CHTapeEnumerationBlock)block;


// Tape Node Functions
#pragma mark - Tape Node Functions

CHTapeNode *CHMakeTapeNode(id payload, CHTapeNode *previous, CHTapeNode *next);
void CHReleaseTapeNode(CHTapeNode *node);

@end
