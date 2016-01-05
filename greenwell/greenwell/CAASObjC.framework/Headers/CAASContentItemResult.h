//
//  CAASContentItemResult.h
//  CAASObjC
//
//  Created by slizeray on 27/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <CAASObjC/CAASObjC.h>

#pragma clang assume_nonnull begin

@interface CAASContentItemResult : CAASRequestResult

@property (readonly) CAASContentItem * __nullable contentItem;

@end

#pragma clang assume_nonnull end
