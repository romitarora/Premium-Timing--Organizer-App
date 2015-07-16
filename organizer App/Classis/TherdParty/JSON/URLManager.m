//
//  URLManager.m
//  Smiggle
//
//  Created by SPEC on 21/02/11.
//  Copyright 2011 ONE CLICK. All rights reserved.
//

#import "URLManager.h"
#import "JSON1.h"

URLManager *sharedObject = nil;

@implementation URLManager
@synthesize delegate;
@synthesize commandName;
@synthesize isString;

+(URLManager*)sharedManager
{
    if (sharedObject == nil)
    {
        sharedObject = [[URLManager alloc] init];
    }
    return sharedObject;
}
-(void)getUrl:(NSString*)path withArgs:(NSMutableDictionary*)parms onCallBack:(URLManagerDelegate)callBack
{
    NSString * urlStr = [NSString stringWithFormat:@"%@",path];
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease] ;
	
    NSURL *url=[NSURL URLWithString:urlStr];
    
	[theRequest setURL:url];
	if (parms!=nil) {
        
		NSString *requestStr = [self postStringFromDictionary:parms];
		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
		[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPBody:requestData];
	}
	
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:60];
    NSLog(@"request parama are %@",parms);
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection)
		receivedData = [[NSMutableData data] retain];
    
    _managerCallBack = callBack;

}
-(void)postUrl:(NSString*)path withArgs:(NSMutableDictionary*)parms onCallBack:(URLManagerDelegate)callBack
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",path];
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease] ;
	
    NSURL *url=[NSURL URLWithString:urlStr];
    
	[theRequest setURL:url];
	if (parms!=nil) {
        
		NSString *requestStr = [self postStringFromDictionary:parms];
		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
		[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPBody:requestData];
	}
	
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
    NSLog(@"request parama are %@",parms);
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection)
		receivedData = [[NSMutableData data] retain];
    
    _managerCallBack = callBack;

}
-(void) urlCall:(NSString *)path withParameters:(NSMutableDictionary *)dictionary oncallBack:(URLManagerDelegate)callBack
{
    NSString * urlStr = [NSString stringWithFormat:@"%@",path];
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease] ;
	
    NSURL *url=[NSURL URLWithString:urlStr];
	[theRequest setURL:url];
	if (dictionary!=nil) {
        
		NSString *requestStr = [self postStringFromDictionary:dictionary];
		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
		[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPBody:requestData];
	}
    //    application/x-www-form-urlencoded
	
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection)
		receivedData = [[NSMutableData data] retain];

    _managerCallBack = callBack;
}
#pragma mark -
#pragma mark Network Call Methods
#pragma mark -

- (void)urlCall:(NSString*)path
{
    NSString * urlStr = [NSString stringWithFormat:@"%@",path];
    NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease] ;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    [theRequest setURL:url];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPShouldHandleCookies:NO];
    [theRequest setTimeoutInterval:30];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection)
        receivedData = [[NSMutableData data] retain];
    
}
- (void)urlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary {
	
    NSString * urlStr = [NSString stringWithFormat:@"%@",path];
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease] ;
	
    NSURL *url=[NSURL URLWithString:urlStr];
	[theRequest setURL:url];
	if (dictionary!=nil) {

		NSString *requestStr = [self postStringFromDictionary:dictionary];
		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d", [requestData length]];
		[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPBody:requestData];
	}
//    application/x-www-form-urlencoded
	
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) 
		receivedData = [[NSMutableData data] retain];
}


- (void)getUrlCall:(NSString*)path withParameters:(NSMutableDictionary*)dictionary {
//    //NSLog(@"abc");
	
	NSString * urlStr = [NSString stringWithFormat:@"%@",path];
//	//NSLog(@"URL = %@",urlStr);
	NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	if (dictionary!=nil) {
        
		NSString *requestStr = [self getStringFromDictionary:dictionary];
        urlStr = [NSString stringWithFormat:@"%@?%@",path,requestStr];
//        //NSLog(@"the url string is %@",urlStr);
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	}
    
	[theRequest setURL:[NSURL URLWithString:urlStr]];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setHTTPShouldHandleCookies:NO];
	[theRequest setTimeoutInterval:30];
//	  //NSLog(@"the main connection is %@",theRequest);
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) 
		receivedData = [[NSMutableData data] retain];
}


- (NSString *)getStringFromDictionary:(NSMutableDictionary*)dictionary {
	NSString *argumentStr = @"";
	
	NSArray *myKeys = [dictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (int i=0 ; i<[sortedKeys count]; i++)  {
		if ( i != 0) 
			argumentStr = [argumentStr stringByAppendingString:@"&"];
        
		NSString *key = [sortedKeys objectAtIndex:i];
		NSString *value = [dictionary objectForKey:key];
		
		NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value];
		argumentStr = [argumentStr stringByAppendingString:formateStr];
	}
	
//	//NSLog(@"Request %@",argumentStr);
	return argumentStr;
}

- (NSString *)postStringFromDictionary:(NSMutableDictionary*)dictionary {
	NSString *argumentStr = @"";
	
	NSArray *myKeys = [dictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (int i=0 ; i<[sortedKeys count]; i++)  {
		if ( i != 0)
			argumentStr = [argumentStr stringByAppendingString:@"&"];
        
		NSString *key = [sortedKeys objectAtIndex:i];
		NSString *value = [dictionary objectForKey:key];
		
		if ([value isKindOfClass:[NSString class]]) {
			value = [value stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
			value = [value stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
			value = [value stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
			value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			value = [value stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			value = [value stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
			value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
			value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
			value = [value stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
            
		}
		
		NSString *formateStr = [NSString stringWithFormat:@"%@=%@",key,value];
		argumentStr = [argumentStr stringByAppendingString:formateStr];
	}
	
//	//NSLog(@"Request %@",argumentStr);
	return argumentStr;
}

#pragma mark -
#pragma mark NSURLConnection Methods
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
//    expectedBytes = [response expectedContentLength];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
//    float progressive = (float)[receivedData length] / (float)expectedBytes;
//    NSLog(@"progressive %f",progressive);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError %@",[error localizedDescription]);
    [connection release];
    [receivedData release];
	
	//with delegate
	[delegate onError:error];
    
    //with call back
    if(_managerCallBack)
        _managerCallBack(nil,error);
    _managerCallBack = nil;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString *responseString = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    
	[receivedData release];
	
	
	if (self.isString) {
        if (commandName!=nil && commandName!=NULL) {
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            [result setObject:responseString forKey:@"result"];
            [result setObject:commandName forKey:@"commandName"];
            
            if (delegate)
                [delegate onResult:result];
            
            //with call back
            if(_managerCallBack)
                _managerCallBack((NSDictionary*)responseString,nil);
            _managerCallBack = nil;

            [result release];
        }
        else {
            
            if (delegate)
                [delegate onResult:(NSDictionary*)responseString];
            
            
            //with call back
            if(_managerCallBack)
                _managerCallBack((NSDictionary*)responseString,nil);
            _managerCallBack = nil;
        }
		
	}
	else
    {
		NSError *error;
		SBJSON *json = [[SBJSON new] autorelease];
		
		NSDictionary *response = [json objectWithString:responseString error:&error];
		if (response == nil )
        {
			NSLog(@"response is nil");
		}
		else
        {
			if (commandName!=nil && commandName!=NULL) {
				NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
				[result setObject:response forKey:@"result"];
				[result setObject:commandName forKey:@"commandName"];
				
				if (delegate)
					[delegate onResult:result];
				
                
                if(_managerCallBack)
                    _managerCallBack((NSDictionary*)responseString,nil);
                _managerCallBack = nil;

				[result release];
			}
			else {
				
				if (delegate)
					[delegate onResult:response];
				
                
                if(_managerCallBack)
                    _managerCallBack((NSDictionary*)responseString,nil);
                _managerCallBack = nil;

			}
		}
		
	}
    
    
}

#pragma mark -
#pragma mark Cleanup Methods
#pragma mark -checkUserEmailRegister

- (void) dealloc
{
	[commandName release];
	[super dealloc];
    
    
}

@end
