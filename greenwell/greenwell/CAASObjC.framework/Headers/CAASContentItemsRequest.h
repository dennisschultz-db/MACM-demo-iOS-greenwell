//
//  CAASContentItemsRequest.h
//  CAASObjC
//
//  Created by slizeray on 23/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#import "CAASRequest.h"

#pragma clang assume_nonnull begin

@class CAASContentItemsResult;

/**
 Definition of the completion block to be executed when a CAASContentItemsRequest is completed
 */

typedef void (^CAASContentItemsCompletionBlock)(CAASContentItemsResult *requestResult);


/**
 A CAASContentItemsRequest instance represents a request to get a list of content items
 */

@interface CAASContentItemsRequest : CAASRequest

/**
 @param contentPath path of the content items
 @param completionBlock block to be executed when the request is completed
 
 @return the newly-created CAASContentItemsRequest instance
 */

- (instancetype) initWithContentPath:(NSString *) contentPath completionBlock:(CAASContentItemsCompletionBlock) completionBlock;

/**
 A block object to be executed when the request is completed
 */
@property (nonatomic, copy, readonly) CAASContentItemsCompletionBlock completionBlock;


/**
 Path of the content items
 */
@property (nonatomic,strong,readonly) NSString *contentPath;

/**
 An array of sort descriptor objects
 */
@property (nonatomic, strong) NSArray * __nullable sortDescriptors;

/**
 Page number of the request
 */
@property (nonatomic) NSInteger pageNumber;

/**
 Size of the page of the request
 */
@property (nonatomic) NSInteger pageSize;

/**
 Filtering creteria
 */
@property (nonatomic, strong) NSArray *filteringCriterias;

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
