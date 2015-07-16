//
//  URLManager.h
//  Smiggle
//
//  Created by SPEC on 21/02/11.
//  Copyright 2011 ONE CLICK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^URLManagerDelegate)(NSDictionary *result, NSError *error);

NSString *responseString;
@protocol URLManagerDelegate

- (void)onResult:(NSDictionary *)result;
- (void)onError:(NSError *)error;

@end

@interface URLManager : NSObject  {
	NSMutableData *receivedData;
	id<URLManagerDelegate> delegate;
	NSString *commandName;
	BOOL isString;
    
    float expectedBytes;
}

@property (nonatomic, retain) id<URLManagerDelegate> delegate;
@property (nonatomic, retain) NSString *commandName;
@property (nonatomic, assign) BOOL isString;
@property (nonatomic, assign) URLManagerDelegate managerCallBack;
- (void)urlCall:(NSString*)path;
- (void)urlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary;
- (NSString *)postStringFromDictionary:(NSMutableDictionary*)dictionary;
- (void)getUrlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary;
- (NSString *)getStringFromDictionary:(NSMutableDictionary*)dictionary;

+(URLManager*)sharedManager;
-(void) urlCall:(NSString *)path withParameters:(NSMutableDictionary *)dictionary oncallBack:(URLManagerDelegate)callBack;
-(void)postUrl:(NSString*)path withArgs:(NSMutableDictionary*)parms onCallBack:(URLManagerDelegate)callBack;
-(void)getUrl:(NSString*)path withArgs:(NSMutableDictionary*)parms onCallBack:(URLManagerDelegate)callBack;
@end
