//
//  CAASRequestResult.h
//  CAASObjC
//
//  Created by slizeray on 24/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#pragma clang assume_nonnull begin

@class CAASRequest;

/**
 A CAASRequestResult represents a futur result of a CAASRequest
 */

@interface CAASRequestResult : NSObject

/// Cancel the CAASRequest associated to this CAASRequestResult
- (void) cancel;

/// The error, if any, that happened when performing the CAASRequest
@property (strong, readonly) NSError* __nullable  error;

/// The http status code, if the NSError is nil
@property (assign, readonly) NSInteger httpStatusCode;

@property (strong, readonly) CAASRequest* caasRequest;

@end


#pragma clang assume_nonnull end
