//
//  CAASIncrementalStore.h
//  CAASObjC
//
//  Created by slizeray on 22/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import CoreData;


FOUNDATION_EXPORT NSString *const CAASUserStoreOption;
FOUNDATION_EXPORT NSString *const CAASPasswordStoreOption;

@interface CAASStore : NSIncrementalStore

+ (NSString *) storeType;

@end
