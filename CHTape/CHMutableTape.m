//
//  CHMutableTape.m
//
//  Created by Christian Huxtable on 30/12/2014.
//

/*
Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#import "CHMutableTape.h"

@implementation CHMutableTape

// Adding Nodes
#pragma mark - Adding Nodes

- (void)appendObject:(id)object
{
	if ( object == nil ) return;
	
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
}

- (void)prependObject:(id)object
{
	if ( object == nil ) return;
	
	if ( _head == NULL )
	{
		_head = CHMakeTapeNode(object, NULL, NULL);
		_tail = _head;
	}
	else
	{
		_head->previous = CHMakeTapeNode(object, NULL, _head);
		_head = _head->previous;
	}
	
	_count++;
}


// Removing Nodes
#pragma mark - Removing Nodes

- (void)removeLastObject
{
	if ( _tail == NULL ) { return; }
	
	CHTapeNode *zombie = _tail;
	
	_tail = _tail->previous;
	_tail->next = NULL;
	
	CHReleaseTapeNode(zombie);
	
	_count--;
}

- (void)removeFirstObject
{
	if ( _head == NULL ) { return; }
	
	CHTapeNode *zombie = _head;
	
	_head = _head->next;
	_head->previous = NULL;
	
	CHReleaseTapeNode(zombie);
	
	_count--;
}


@end
