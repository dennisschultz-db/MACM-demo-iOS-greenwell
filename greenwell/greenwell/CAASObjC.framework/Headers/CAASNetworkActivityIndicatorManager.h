//
//  CAASNetworkActivityIndicatorManager.h
//  CAASObjC
//
//  Created by slizeray on 27/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

/**
 
 CAASNetworkActivityIndicatorManager is singleton which manages the Network Activity Indicator
 It listens to all the requests of the CAASService
 
 */

@interface CAASNetworkActivityIndicatorManager : NSObject

/**
 Returns the singleton instance
 */
+ (instancetype)sharedInstance;

/**
 Enables/Disables the CAAS Network ActivityIndicator
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
