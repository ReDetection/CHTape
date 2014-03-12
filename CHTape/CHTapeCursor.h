//
//  CHTapeCursor.h
//
//  Created by Christian Huxtable on 2/21/2014.
//  Copyright (c) 2014 Christian Huxtable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHTape.h"

@interface CHTapeCursor : NSEnumerator
{
	NSUInteger index;
	
	CHTape *tape;
	CHTapeNode *next;
	CHTapeNode *previous;
}

// Static Factories
+ (instancetype)cursorWithTape:(CHTape *)aTape;

// Initializers
- (instancetype)init;
- (instancetype)initWithTape:(CHTape *)aTape;

// Properties
@property(readonly) NSUInteger index;
@property(readonly) NSUInteger count;
@property(readonly) NSArray *allObjects;
- (id)firstObject;
- (id)lastObject;

// Traversal
- (void)moveFirstObject;
- (void)moveToLastObject;
- (id)nextObject;
- (id)previousObject;
- (id)nextObjectPeek;
- (id)previousObjectPeek;

// Addition/Insertion
- (void)appendObject:(id)anObject;
- (void)prependObject:(id)anObject;

- (void)insertObjectAfterCursor:(id)anObject;
- (void)insertObjectBeforeCursor:(id)anObject;

// Removal
- (void)removeLastObject;
- (void)removeFirstObject;
- (void)removeObjectAfterCursor;
- (void)removeObjectBeforeCursor;
@end
