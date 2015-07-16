//
//  DataBaseManager.h
//  organizer App
//
//  Created by Romit on 18/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <sqlite3.h>
@interface DataBaseManager : NSObject
{
    NSString *path;
    NSString* _dataBasePath;
    sqlite3 *_database;
    BOOL copyDb;
    BOOL ret;
    BOOL status;
    BOOL querystatus;
}
+(DataBaseManager*)dataBaseManager;
-(NSString*) getDBPath;
-(void)openDatabase;

#pragma mark Create Database Methods

-(BOOL)createMainTable;
-(BOOL)createStagesTable;
-(BOOL)createSplitsTable;
-(BOOL)createGeneralInfoTable;
-(BOOL)createImagesTable;
-(BOOL)createEventSponsorsTable;
-(BOOL)createEventParticipantsTable;
-(BOOL)createMapTable;
-(BOOL)createProfileDetailTable;
-(BOOL)createTotalParticipantsTable;
-(BOOL)createTotalSponsorsTable;
-(BOOL)createRaceTypeTable;
-(BOOL)createEventCategoryTable;
-(BOOL)createDevicesListTable;



-(BOOL)execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable;
-(BOOL)execute:(NSString*)sqlStatement;

#pragma mark- ***************
-(NSInteger)getScalar:(NSString*)sqlStatement;
-(NSString*)getValue1:(NSString*)sqlStatement;

#pragma mark Insert Methods

-(int)insertStagesDetail:(NSMutableDictionary *)dictInfo;
-(BOOL)insertSplitsDetail:(NSDictionary *)dictInfo;
-(int)insertMainDetail:(NSDictionary *)dictInfo;
-(int)insertGeneralInfoDetail:(NSDictionary *)dictInfo;
-(BOOL)insertImagesDetail:(NSDictionary *)dictInfo;
-(BOOL)insertEventSponsorsDetail:(NSDictionary *)dictInfo;
-(BOOL)insertEventParticipantsDetail:(NSDictionary *)dictInfo;
-(BOOL)insertMapDetail:(NSDictionary *)dictInfo;
-(BOOL)insertProfileDetail:(NSDictionary *)dictInfo;
-(BOOL)insertTotalParticipantsDetail:(NSDictionary *)dictInfo;
-(BOOL)insertTotalSponsorsDetail:(NSDictionary *)dictInfo;
-(BOOL)insertRaceTypeDetail:(NSDictionary *)dictInfo;
-(BOOL)insertEventCategoryDetail:(NSDictionary *)dictInfo;
-(BOOL)insertEventDevicesDetail:(NSDictionary *)dictInfo;

#pragma mark UPDATE methods

-(BOOL)updateMainTable:(NSDictionary *)dictInfo with:(NSString *)mainId;
-(BOOL)updateGeneralInfo:(NSDictionary *)dictInfo with:(NSString *)mainId;
-(BOOL)updateImages:(NSDictionary *)dictInfo with:(NSString *)mainId;
-(int)updateStages:(NSDictionary *)dictInfo with:(NSString *)mainId;
-(BOOL)updateSplits:(NSDictionary *)dictInfo with:(NSString *)mainId;
@end
