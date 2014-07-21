//
//  CHTapeCursor.h
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
