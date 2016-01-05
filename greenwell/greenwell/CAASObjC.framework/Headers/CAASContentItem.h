//
//  CAASContentItem.h
//  CAASObjC
//
//  Created by slizeray on 18/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#pragma clang assume_nonnull begin

/**
 A CAASContentItem instance represents a MACM/WCM content item
 */

@interface CAASContentItem : NSObject

/**
 The object id of thie content item
 */
@property (nonatomic,readonly,strong) NSString *oid;

/**
 All the properties of this content item
 */
@property (nonatomic,readonly,strong) NSDictionary *values;

@end

#pragma clang assume_nonnull end
