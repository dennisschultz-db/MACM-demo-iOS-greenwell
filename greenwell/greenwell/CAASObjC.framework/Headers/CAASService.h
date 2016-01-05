//
//  CAASService.h
//  CAASObjC
//
//  Created by slizeray on 12/03/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

@import Foundation;

#import "CAASContentItem.h"
#import "CAASRequest.h"
#import "CAASRequestResult.h"

#pragma clang assume_nonnull begin


/// CAAS errors

FOUNDATION_EXPORT NSString *const CAASErrorDomain;

FOUNDATION_EXPORT NSString *const CAASDidSignIn;

FOUNDATION_EXPORT NSString *const CAASDidStartRequest;
FOUNDATION_EXPORT NSString *const CAASDidEndRequest;

enum
{
    CAASNotSignedIn = -1
};


typedef void (^CAASSignInCompletionHandler)(NSError * __nullable error,NSInteger httpStatusCode);

/**
 CAASService is the central class to access a MACM server.
*/

@interface CAASService : NSObject

/**
 Initializes a CAASService object with the specified base URL. The context root is the default CAAS context root, that is wps
 
 @param url The base URL for the HTTP client. It is the URL of a Web Content Manager host
 
 @return The newly-initialized CAASService
 */
- (instancetype)initWithBaseURL:(NSURL *)url;

/**
 Initializes a CAASService object with the specified base URL. The context root is the default CAAS context root, that is wps
 
 @param url The base URL for the HTTP client. It is the URL of a Web Content Manager host
 @param contextRoot The CAAS context root
 
 @return The newly-initialized CAASService
 */
- (instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot;

/**
 Initializes a CAASService object with the specified base URL. The context root is the default CAAS context root, that is wps
 
 @param url The base URL for the HTTP client. It is the URL of a Web Content Manager host
 @param contextRoot The CAAS context root
 @param tenant The tenant/service instance name. The base portal is addressed when omitted.
 
 @return The newly-initialized CAASService
 */
- (instancetype)initWithBaseURL:(NSURL *)url contextRoot:(NSString *)contextRoot tenant:( NSString * __nullable )tenant;

/**
 Authenticates against a MACM server. If the authentication finished succesfully, the credentials are store in the keychain and can be used later with the silent sign method
 
 @param user user to authenticate
 @param password password of the given user
 @param completionHandler A block object to be executed when the operation finishes. This block has no return value and takes two arguments: an NSError which can be nil and an NSInteger which is the http status code of the HTTP response
 
 @return an NSOperation that executes the authentication
 */
- (NSOperation *) signIn:(NSString *) user password: (NSString *) password completionHandler:(CAASSignInCompletionHandler) completionHandler;

/**
 Remove the credentials from the key chain
 */
- (void) signOut;

/**
 
 @return true when a user has been already signed in successfully once.
 
 */
- (BOOL) isUserAlreadySignedIn;

/**
 Sign in with the credentials saved in the key chain
 */
- ( NSOperation * __nullable ) silentSignInWithCompletionHandler:(CAASSignInCompletionHandler) completionHandler;

/**
 Executes an asynchronous request against an MACM server
 @param request to be executed
 
 @return a future/promise of the result received in response to the given request  
 */
- (CAASRequestResult *) executeRequest: (CAASRequest *) request;

/**
 The time-out used in all the request against the CAAS server, default is 30 seconds.
 */
@property (nonatomic,assign) NSTimeInterval timeout;

/**
 The time-out used for sign in, default is 10 seconds.
 */
@property (nonatomic,assign) NSTimeInterval signInTimeout;

/**
 Maximum number of retries when a network error occurs, default is 3.
 */
@property (nonatomic,assign) NSInteger maxRetry;

/**
 Cancel all pending requests
 */
- (void) cancelAllPendingRequests;

/**
 Returns the NSURLSession used by the CAASService
 */
- (NSURLSession *) caasSession;
/**
 Returns the base URL of the MACM server, that is scheme ":" host [ ":" port ]
 */
@property (nonatomic,strong,readonly) NSURL *baseURL;

/**
 Context root of the MACM instance
 */
@property (nonatomic,strong,readonly) NSString *contextRoot;

/**
 Tenant of the MACM instance
 */
@property (nonatomic,strong,readonly) NSString *tenant;

/**
 true if untrusted certificates are allowed in DEBUG mode.
 In RELEASE mode, untrusted certificates are NEVER allowed, this
 property is ignored
 */
@property (nonatomic,assign) BOOL allowUntrustedCertificates;

@end

#pragma clang assume_nonnull end
