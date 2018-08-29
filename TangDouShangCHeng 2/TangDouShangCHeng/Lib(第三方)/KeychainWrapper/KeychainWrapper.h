//
//  KeychainWrapper.h
//  MillionaireMatch
//
//  Created by robyzhou on 14-4-19.
//  Copyright (c) 2014年 robyzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

@interface KeychainWrapper : NSObject

+ (NSString *)ServiceName;
+ (NSString *)UUID;

// Generic exposed method to search the keychain for a given value. Limit one result per search.
+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier;

// Calls searchKeychainCopyMatchingIdentifier: and converts to a string value.
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;

// Default initializer to store a value in the keychain.
// Associated properties are handled for you - setting Data Protection Access, Company Identifer (to uniquely identify string, etc).
+ (BOOL)createKeychainNSStringValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (BOOL)createKeychainDataValue:(NSData *)value forIdentifier:(NSString *)identifier;

// Updates a value in the keychain. If you try to set the value with createKeychainValue: and it already exists,
// this method is called instead to update the value in place.
+ (BOOL)updateKeychainNSStringValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (BOOL)updateKeychainDataValue:(NSData *)value forIdentifier:(NSString *)identifier;

// Delete a value in the keychain.
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

@end
