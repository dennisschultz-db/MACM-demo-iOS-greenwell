//
//  CAASImageRequestResult.h
//  CAASObjC
//
//  Created by slizeray on 30/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <CAASObjC/CAASObjC.h>

#pragma clang assume_nonnull begin

@interface CAASImageResult : CAASRequestResult

@property (nonatomic,readonly) UIImage * __nullable image;

@end

#pragma clang assume_nonnull end
