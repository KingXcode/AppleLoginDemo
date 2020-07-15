//
//  HTAppleLoginManager.h
//  AppleLoginOCDemo
//
//  Created by mypc on 2020/7/15.
//  Copyright © 2020 niesiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, HTAppleLoginToolErrorCode) {
    HTAppleLoginToolErrorUnknown,     //授权请求失败未知原因
    HTAppleLoginToolErrorCanceled,    //用户取消了授权请求
    HTAppleLoginToolErrorInvalidResponse,//授权请求响应无效
    HTAppleLoginToolErrorNotHandled,  //未能处理授权请求
    HTAppleLoginToolErrorFailed       //授权请求失败
};


@interface HTAppleLoginInfo : NSObject

@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSPersonNameComponents *fullName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *authorizationCode;
@property (nonatomic, copy) NSString *identityToken;
@property (nonatomic, assign) ASUserDetectionStatus realUserStatus;

- (instancetype)initWithCredential:(ASAuthorizationAppleIDCredential *)credential API_AVAILABLE(ios(13.0));

@end


@interface HTAppleLoginTool : NSObject<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

-(void)toAppleLoginWithWindow:(UIWindow *)window
                  withSuccess:(void(^)(HTAppleLoginInfo *info))success
                      failure:(void(^)(NSError *error, HTAppleLoginToolErrorCode code))failure;

@end

NS_ASSUME_NONNULL_END
