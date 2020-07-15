//
//  HTAppleLoginManager.m
//  AppleLoginOCDemo
//
//  Created by mypc on 2020/7/15.
//  Copyright © 2020 niesiyang. All rights reserved.
//

#import "HTAppleLoginTool.h"

@implementation HTAppleLoginInfo

- (instancetype)initWithCredential:(ASAuthorizationAppleIDCredential *)credential API_AVAILABLE(ios(13.0))
{
    self = [super init];
    if (self) {
        _state = credential.state;
        _userID = credential.user;
        _fullName = credential.fullName;
        _email = credential.email;
        _authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        _identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
        _realUserStatus = credential.realUserStatus;
    }
    return self;
}

@end


@interface HTAppleLoginTool ()

@property (nonatomic, strong) ASPresentationAnchor window;
@property (nonatomic, copy) void(^loginFinishSuccess)(HTAppleLoginInfo *info);
@property (nonatomic, copy) void(^loginFinishError)(NSError *error, HTAppleLoginToolErrorCode code);

@end

@implementation HTAppleLoginTool

-(void)toAppleLoginWithWindow:(UIWindow *)window
                  withSuccess:(void(^)(HTAppleLoginInfo *info))success
                      failure:(void(^)(NSError *error, HTAppleLoginToolErrorCode code))failure
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        vc.delegate = self;
        vc.presentationContextProvider = self;
        [vc performRequests];
        self.window = window;
        self.loginFinishSuccess = success;
        self.loginFinishError = failure;
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0))
{
    return self.window;
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])       {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        HTAppleLoginInfo *info = [[HTAppleLoginInfo alloc] initWithCredential:credential];
        if (self.loginFinishSuccess) {
            self.loginFinishSuccess(info);
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0))
{
    if (self.loginFinishError) {
        self.loginFinishError(error, [self convertErrorCode:error.code]);
    }
}

-(HTAppleLoginToolErrorCode)convertErrorCode:(ASAuthorizationError)code
API_AVAILABLE(ios(13.0)){
    switch (code) {
        case ASAuthorizationErrorCanceled:
            return HTAppleLoginToolErrorCanceled;
        case ASAuthorizationErrorFailed:
            return HTAppleLoginToolErrorFailed;
        case ASAuthorizationErrorInvalidResponse:
            return HTAppleLoginToolErrorInvalidResponse;
        case ASAuthorizationErrorNotHandled:
            return HTAppleLoginToolErrorNotHandled;
        case ASAuthorizationErrorUnknown:
            return HTAppleLoginToolErrorUnknown;
    }
}


@end
