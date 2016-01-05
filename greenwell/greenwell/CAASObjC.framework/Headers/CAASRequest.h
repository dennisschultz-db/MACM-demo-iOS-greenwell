//
//  CAASRequest.h
//  CAASObjC
//
//  Created by slizeray on 23/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#pragma clang assume_nonnull begin

/**
  A CAASRequest instance represents an asynchronous request performed against an MACM server
 */
@interface CAASRequest : NSObject

/**
 Add a user defined key/param to the context
 */
- (void) addKeyParam:(NSString *) key valueParam:(NSString *) param;

/**
 Remove a user defined key
 */
- (void) removeKeyParam:(NSString *) key;


@end

#pragma clang assume_nonnull end
