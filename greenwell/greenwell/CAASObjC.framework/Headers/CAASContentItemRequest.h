//
//  CAASContentItemRequest.h
//  CAASObjC
//
//  Created by slizeray on 23/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#import "CAASRequest.h"

#pragma clang assume_nonnull begin

@class CAASContentItemResult;

/**
 Definition of the completion block to be executed when a CAASContentItemRequest is completed
 */

typedef void (^CAASContentItemCompletionBlock)(CAASContentItemResult *requestResult);

/**
 A CAASRequest instance retrieves a content item that matches a given object id
 */
@interface CAASContentItemRequest : CAASRequest

/**
 The designated initializer of a CAASContentItemRequest
 @param oid the object id of the content item
 @param completionBlock the block to be executed when the request completes
 */

- (instancetype) initWithOid:(NSString *) oid completionBlock:(CAASContentItemCompletionBlock) completionBlock;

/**
 A block object to be executed when the request is completed
 */
@property (nonatomic, copy, readonly) CAASContentItemCompletionBlock completionBlock;


/// The object id of the content item
@property (nonatomic,strong,readonly) NSString *oid;

/**
 Specifies a collection of property names that should be fetched. If this collection is empty, all properties will be retrieved
 */
@property (nonatomic, strong) NSArray * __nullable propertiesToFetch;

/**
 Sets/Returns a specific project scope. Setting the project scope allows to retrieve data for draft content.
 */
@property (nonatomic,strong) NSString *projectScope;

@end

#pragma clang assume_nonnull end
