//
//  CAASImageRequest.h
//  CAASObjC
//
//  Created by slizeray on 30/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <CAASObjC/CAASObjC.h>

@class CAASImageResult;

/**
 Definition of the completion block to be executed when a CAASImageRequest is completed
 */

typedef void (^CAASImageCompletionBlock)(CAASImageResult *requestResult);

/**
 A CAASImageRequest instance represents a request to get an image from a MACM instance
 */

@interface CAASImageRequest : CAASRequest

/**
 @param imageURL URL of the image to be downloaded
 @param completionBlock block to be executed when the request is completed
 
 @return the newly-created CAASImageRequest instance
 */

- (instancetype) initWithImageURL:(NSURL *) imageURL completionBlock:(CAASImageCompletionBlock) completionBlock;

@property (nonatomic,copy,readonly) NSURL *imageURL;

@property (nonatomic, copy, readonly) CAASImageCompletionBlock completionBlock;

@end
