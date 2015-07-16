//
//  DataBaseManager.m
//  organizer App
//
//  Created by Romit on 18/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "DataBaseManager.h"
static DataBaseManager * dataBaseManager = nil;
@implementation DataBaseManager

#pragma mark - DataBaseManager initialization
-(id) init
{
    self = [super init];
    if (self)
    {
        // get full path of database in documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
        _dataBasePath = [path stringByAppendingPathComponent:@"premiumTiming.sqlite"];
        
        NSLog(@"data base path:%@",path);
        
        //		_database = nil;
        [self openDatabase];
    }
    return self;
    
}
+(DataBaseManager*)dataBaseManager
{
    static dispatch_once_t _singletonPredicate;
    dispatch_once(&_singletonPredicate, ^{
        if (!dataBaseManager)
        {
            dataBaseManager = [[super alloc]init];
        }
    });
    
    return dataBaseManager;
}

- (NSString *) getDBPath
{
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"premiumTiming.sqlite"];
    
}
-(void)openDatabase
{
    BOOL ok;
    NSError *error;
    
    /*
     * determine if database exists.
     * create a file manager object to test existence
     *
     */
    NSFileManager *fm = [NSFileManager defaultManager]; // file manager
    ok = [fm fileExistsAtPath:_dataBasePath];
    
    // if database not there, copy from resource to path
    if (!ok)
    {
        // location in resource bundle
        NSString *appPath = [[[NSBundle mainBundle] resourcePath]
                             stringByAppendingPathComponent:@"premiumTiming.sqlite"];
        if ([fm fileExistsAtPath:appPath])
        {
            // copy from resource to where it should be
            copyDb = [fm copyItemAtPath:appPath toPath:_dataBasePath error:&error];
            
            if (error!=nil)
            {
                copyDb = FALSE;
            }
            ok = copyDb;
        }
        
    }
    
    
    // open database
    if (sqlite3_open([_dataBasePath UTF8String], &_database) != SQLITE_OK)
    {
        sqlite3_close(_database); // in case partially opened
        _database = nil; // signal open error
    }
    
    if (!copyDb && !ok)
    { // first time and database not copied
        ok = [self createGeneralInfoTable]; // create empty database
        if (ok)
        {
            // Populating Table first time from the keys.plist
            /*	NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"ads" ofType:@"plist"];
             NSArray *contents = [NSArray arrayWithContentsOfFile:pListPath];
             for (NSDictionary* dictionary in contents) {
             
             NSArray* keys = [dictionary allKeys];
             [self execute:[NSString stringWithFormat:@"insert into ads values('%@','%@','%@')",[dictionary objectForKey:[keys objectAtIndex:0]], [dictionary objectForKey:[keys objectAtIndex:1]],[dictionary objectForKey:[keys objectAtIndex:2]]]];
             }*/
        }
    }
    
    if (!ok)
    {
        // problems creating database
        NSAssert1(0, @"Problem creating database [%@]",
                  [error localizedDescription]);
    }
    
}

#pragma mark - Insert Query
/*
 * Method to execute the simple queries
 */
-(BOOL)execute:(NSString*)sqlStatement
{
    sqlite3_stmt *statement = nil;
    status = FALSE;
    //NSLog(@"%@",sqlStatement);
    const char *sql = (const char*)[sqlStatement UTF8String];
    
    
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error while preparing  statement. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    }
    else
    {
        status = TRUE;
    }
    if (sqlite3_step(statement)!=SQLITE_DONE)
    {
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    }
    else
    {
        status = TRUE;
    }
    
    sqlite3_finalize(statement);
    return status;
}
#pragma mark - SQL query methods
/*
 * Method to get the data table from the database
 */
-(BOOL) execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable
{
    
    char** azResult = NULL;
    int nRows = 0;
    int nColumns = 0;
    querystatus = FALSE;
    char* errorMsg; //= malloc(255); // this is not required as sqlite do it itself
    const char* sql = [sqlQuery UTF8String];
    sqlite3_get_table(
                      _database,  /* An open database */
                      sql,     /* SQL to be evaluated */
                      &azResult,          /* Results of the query */
                      &nRows,                 /* Number of result rows written here */
                      &nColumns,              /* Number of result columns written here */
                      &errorMsg      /* Error msg written here */
                      );
    
    if(azResult != NULL)
    {
        nRows++; //because the header row is not account for in nRows
        
        for (int i = 1; i < nRows; i++)
        {
            NSMutableDictionary* row = [[NSMutableDictionary alloc]initWithCapacity:nColumns];
            for(int j = 0; j < nColumns; j++)
            {
                NSString*  value = nil;
                NSString* key = [NSString stringWithUTF8String:azResult[j]];
                if (azResult[(i*nColumns)+j]==NULL)
                {
                    value = [NSString stringWithUTF8String:[[NSString string] UTF8String]];
                }
                else
                {
                    value = [NSString stringWithUTF8String:azResult[(i*nColumns)+j]];
                }
                
                [row setValue:value forKey:key];
            }
            [dataTable addObject:row];
        }
        querystatus = TRUE;
        sqlite3_free_table(azResult);
    }
    else
    {
        NSAssert1(0,@"Failed to execute query with message '%s'.",errorMsg);
        querystatus = FALSE;
    }
    
    return 0;
}
-(NSInteger)getScalar:(NSString*)sqlStatement
{
    NSInteger count = -1;
    
    const char* sql= (const char *)[sqlStatement UTF8String];
    sqlite3_stmt *selectstmt;
    if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(selectstmt) == SQLITE_ROW)
        {
            count = sqlite3_column_int(selectstmt, 0);
        }
    }
    sqlite3_finalize(selectstmt);
    
    return count;
}

-(NSString*)getValue1:(NSString*)sqlStatement
{
    
    NSString* value = nil;
    const char* sql= (const char *)[sqlStatement UTF8String];
    sqlite3_stmt *selectstmt;
    if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(selectstmt) == SQLITE_ROW)
        {
            if ((char *)sqlite3_column_text(selectstmt, 0)!=nil)
            {
                value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
            }
        }
    }
    return value;
}

#pragma  mark Create Table Methods

-(BOOL)createMainTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Main_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'organiser_name' varchar(255) NOT NULL,'event_name' varchar(255) NOT NULL,'location' varchar(255) NOT NULL,'photo' varchar(255) NOT NULL,'start_time' varchar(255) NOT NULL,'end_time' varchar(255) NOT NULL,'event_date' varchar(255) NOT NULL)",nil];
    
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
}
-(BOOL)createGeneralInfoTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'GeneralInfo_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'event_name' varchar(255) NOT NULL,'cat_name' varchar(255) NOT NULL,'age_category' varchar(255) NOT NULL,'location' varchar(255) NOT NULL,'event_date' varchar(255) NOT NULL,'event_start_date' varchar(255) NOT NULL,'event_end_date' varchar(255) NOT NULL,'manual_start' varchar(255) NOT NULL,'race_description' varchar(255) NOT NULL,'competitors_count' varchar(255) NOT NULL,'sponser_count' varchar(255) NOT NULL,'website_url' varchar(255) NOT NULL,'start_method' varchar(255) NOT NULL,'race_name' varchar(255) NOT NULL,'updated_date' varchar(255) NOT NULL,'organiser_name' varchar(255) NOT NULL)",nil];//jam15-07-2015.
    
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
    }
    
    return ret;
    
}
-(BOOL)createStagesTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Stages_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'event_stage_id' varchar(255) NOT NULL,'stage_name' varchar(255) NOT NULL,'start_time' varchar(255) NOT NULL,'device_name' varchar(255) NOT NULL,'device_id' varchar(255) NOT NULL,'penalty_time' varchar(255) NOT NULL,'liason_time' varchar(255) NOT NULL,'rest_time' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'updated_date' varchar(255) NOT NULL,'split_count' varchar(255) NOT NULL,'stage_lat' varchar(255) NOT NULL,'stage_lon' varchar(255) NOT NULL)",nil];
    
    
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createSplitsTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Splits_Table'(id integer primary key autoincrement not null,'event_stage_id' varchar(255) NOT NULL,'stage_split_id' varchar(255) NOT NULL,'split_name' varchar(255) NOT NULL,'start_time' varchar(255) NOT NULL,'device_name' varchar(255) NOT NULL,'device_id' varchar(255) NOT NULL,'penalty_time' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'updated_date' varchar(255) NOT NULL,'split_lat' varchar(255) NOT NULL,'split_lon' varchar(255) NOT NULL)",nil];
    
    
    
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createImagesTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Images_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'event_photo1' varchar(255) NOT NULL,'event_photo2' varchar(255) NOT NULL,'event_photo3' varchar(255) NOT NULL)",nil];
    
    
 
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createMapTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Map_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'name' varchar(255) NOT NULL,'lat' varchar(255) NOT NULL,'long' varchar(255) NOT NULL)",nil];
    
    
    
  
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createEventParticipantsTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'EventParticipants_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'user_id' varchar(255) NOT NULL,'name' varchar(255) NOT NULL,'emailId' varchar(255) NOT NULL,'country' varchar(255) NOT NULL,'compititorNumber' varchar(255) NOT NULL,'verified' varchar(255) NOT NULL)",nil];
    
    
    
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createEventSponsorsTable
{
    int rc;
    
    // SQL to create new database
//    NSArray* queries = [NSArray arrayWithObjects:
//                        @"create table 'EventSponsors_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'name' varchar(255) NOT NULL,'website' varchar(255) NOT NULL)",nil];
    
  NSArray* queries=[NSArray arrayWithObjects:
                    @"create table 'EventSponsors_Table'(id integer primary key autoincrement not null,'event_id' varchar(255) NOT NULL,'sponser_id' varchar(255) NOT NULL,'sponser_name' varchar(255) NOT NULL,'address' varchar(255) NOT NULL,'contact_no' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'email' varchar(255) NOT NULL,'photo' varchar(255) NOT NULL,'website' varchar(255) NOT NULL)",nil];
    
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
    }
    
    return ret;
    
}

-(BOOL)createProfileDetailTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Profile_Table'(id integer primary key autoincrement not null,'user_id' varchar(255) NOT NULL,'firstName' varchar(255) NOT NULL,'lastName' varchar(255) NOT NULL,'emailId' varchar(255) NOT NULL,'contact' varchar(255) NOT NULL,'company' varchar(255) NOT NULL,'website' varchar(255) NOT NULL,'socialLink' varchar(255) NOT NULL,'eventCategory' varchar(255) NOT NULL,'photo' varchar(255) NOT NULL,'address' varchar(255) NOT NULL)",nil];
    
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

-(BOOL)createTotalSponsorsTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Sponsors_Table'(id integer primary key autoincrement not null,'sponser_id' varchar(255) NOT NULL,'sponser_name' varchar(255) NOT NULL,'address' varchar(255) NOT NULL,'contact_no' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'email' varchar(255) NOT NULL,'photo' varchar(255) NOT NULL,'website' varchar(255) NOT NULL)",nil];
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
    }
    
    return ret;
    
}

-(BOOL)createTotalParticipantsTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Participants_Table'(id integer primary key autoincrement not null,'user_id' varchar(255) NOT NULL,'name' varchar(255) NOT NULL,'emailId' varchar(255) NOT NULL,'country' varchar(255) NOT NULL,'compititorNumber' varchar(255) NOT NULL,'verified' varchar(255) NOT NULL)",nil];
    
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

-(BOOL)createRaceTypeTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'RaceType_Table'(id integer primary key autoincrement not null,'race_type_id' varchar(255) NOT NULL,'race_name' varchar(255) NOT NULL,'is_active' varchar(255) NOT NULL,'created_by' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'updated_by' varchar(255) NOT NULL,'updated_date' varchar(255) NOT NULL)",nil];
    
    
    
  
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

-(BOOL)createEventCategoryTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'EventCategory_Table'(id integer primary key autoincrement not null,'event_cat_id' varchar(255) NOT NULL,'cat_name' varchar(255) NOT NULL,'is_active' varchar(255) NOT NULL,'created_by' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL,'updated_by' varchar(255) NOT NULL,'updated_date' varchar(255) NOT NULL)",nil];
    
    
    

    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createDevicesListTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'EventDevices_Table'(id integer primary key autoincrement not null,'device_id' varchar(255) NOT NULL,'factory_id' varchar(255) NOT NULL,'name' varchar(255) NOT NULL,'created_date' varchar(255) NOT NULL)",nil];
    
    
    
   
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

#pragma mark Insert Methods

-(int)insertGeneralInfoDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            int returnValue;
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK) {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE) {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'GeneralInfo_Table'('event_id','event_name','cat_name','age_category','location','event_date','event_start_date','event_end_date','manual_start','race_description','competitors_count','sponser_count','website_url','start_method','race_name','updated_date','organiser_name') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];//jam15-07-2015.
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
          
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"event_name"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"cat_name"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"age_category"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"location"]];
                if (row5 && [row5 length] > 0) {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row6 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_date"]];
                if (row6 && [row6 length] > 0) {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row7 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_start_date"]];
                if (row7 && [row7 length] > 0) {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row8 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_end_date"]];
                if (row8 && [row8 length] > 0) {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row9 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"manual_start"]];
                if (row9 && [row9 length] > 0) {
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row10 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"race_description"]];
                if (row10 && [row10 length] > 0) {
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                
                NSString *row11 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"competitors_count"]];
                if (row11 && [row11 length] > 0)
                {
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row12 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"sponser_count"]];
                if (row12 && [row12 length] > 0)
                {
                    sqlite3_bind_text(statement, 12,[row12 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 12, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row13 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"website_url"]];
                if (row13 && [row13 length] > 0)
                {
                    sqlite3_bind_text(statement, 13,[row13 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 13, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row14 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"start_method"]];
                if (row14 && [row14 length] > 0)
                {
                    sqlite3_bind_text(statement, 14,[row14 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 14, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row15 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"race_name"]];
                if (row15 && [row15 length] > 0)
                {
                    sqlite3_bind_text(statement, 15,[row15 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 15, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

            
                NSString *row16 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"updated_date"]];
               if (row16 && [row16 length] > 0)
               {
                   sqlite3_bind_text(statement, 16,[row16 UTF8String] , -1, SQLITE_TRANSIENT);
               }
               else
               {
                  sqlite3_bind_text(statement, 16, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
               }
            
            NSString *row17 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"organiser_name"]];
            if (row17 && [row17 length] > 0)
            {
                sqlite3_bind_text(statement, 17,[row17 UTF8String] , -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(statement, 17, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
            }//jam15-07-2015.
            

            
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY){
                        //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
                
                
                statemt = @"COMMIT TRANSACTION";
                sqlite3_stmt *commitStatement;
                if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK)
                {
                    //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                    return -1;
                }
                if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                    // printf("db error: %s\n", sqlite3_errmsg(masterDB));
                    return -1;
                }
                
                sqlite3_finalize(statement);
                sqlite3_finalize(commitStatement);
                returnValue = sqlite3_last_insert_rowid(_database);
                return returnValue;
            }
            @catch (NSException *e)
            {
                NSLog(@":::: Exception : %@",e);
            }
            return -1;
    }
    
    
}

-(BOOL)insertImagesDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
           
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Images_Table'('event_id','event_photo1','event_photo2','event_photo3') values(?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo1"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo2"]];
                if (row3 && [row3 length] > 0) {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo3"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(int)insertMainDetail:(NSDictionary *)dictInfo
{
    {
            @try
            {
                    sqlite3_stmt *statement=nil;
                    sqlite3_stmt *init_statement =nil;
                    NSString  *sql=nil;
                    int returnValue;
                    NSString* statemt;
                    
                    statemt = @"BEGIN EXCLUSIVE TRANSACTION";
                    
                    if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK) {
                        return NO;
                    }
                    if (sqlite3_step(init_statement) != SQLITE_DONE) {
                        sqlite3_finalize(init_statement);
                        return NO;
                    }
               
                    
                    sql=[NSString stringWithFormat:@"insert into 'Main_Table'('event_id','organiser_name','event_name','location','photo','start_time','end_time','event_date') values(?,?,?,?,?,?,?,?)"];
                    
                    if(sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL)!=SQLITE_OK)
                    {
                        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
                    }
                    //=====
                    
                    
                    //=====
                    NSString *emptyString = @"";
                
                    
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row2 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"organiser_name"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"event_name"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"location"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                    
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"photo"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"start_time"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"end_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"event_date"]];
                
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                    
                    while(YES){
                        NSInteger result = sqlite3_step(statement);
                        if(result == SQLITE_DONE){
                            break;
                        }
                        else if(result != SQLITE_BUSY){
                            //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                            break;
                        }
                    }
                    sqlite3_reset(statement);
                    
                    
                    
                    statemt = @"COMMIT TRANSACTION";
                    sqlite3_stmt *commitStatement;
                    if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK)
                    {
                        //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                        return -1;
                    }
                    if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                        // printf("db error: %s\n", sqlite3_errmsg(masterDB));
                        return -1;
                    }
                    
                    sqlite3_finalize(statement);
                    sqlite3_finalize(commitStatement);
                    returnValue = sqlite3_last_insert_rowid(_database);
                    return returnValue;
                }
                @catch (NSException *e)
                {
                    NSLog(@":::: Exception : %@",e);
                }
                return -1;
            }
    
}

 
-(BOOL)insertEventSponsorsDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
         //   sqlQuery=[NSString stringWithFormat:@"insert into 'EventSponsors_Table'('event_id','name','website') values(?,?,?)"];
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'EventSponsors_Table'('event_id','sponser_id','sponser_name','address','contact_no','created_date','email','photo','website') values(?,?,?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"sponser_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"sponser_name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"address"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"contact_no"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"email"]];
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                if (row8 && [row8 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"website"]];
                if (row9 && [row9 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertEventParticipantsDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'EventParticipants_Table'('event_id','user_id','name','emailId','country','compititorNumber','verified') values(?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"user_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"name"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"emailId"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"country"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"compititorNumber"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"verified"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
}
-(BOOL)insertSplitsDetail:(NSDictionary *)dictInfo
{
    {
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Splits_Table'('event_stage_id','stage_split_id','split_name','start_time','device_name','device_id','penalty_time','created_date','updated_date','split_lat','split_lon') values(?,?,?,?,?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_stage_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"stage_split_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"split_name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"start_time"]];
                
                if (row4 && [row4 length] > 0)
                {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_name"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_id"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"penalty_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                
                if (row9 && [row9 length] > 0)
                {
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row10 = @"Lat";
                
                if (row10 && [row10 length] > 0)
                {
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row11 = @"Long";
                
                if (row11 && [row11 length] > 0)
                {
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}
-(int)insertStagesDetail:(NSMutableDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            int returnValue;
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK) {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE) {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Stages_Table'('event_id','event_stage_id','stage_name','start_time','device_name','device_id','penalty_time','liason_time','rest_time','created_date','updated_date','split_count','stage_lat','stage_lon') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_stage_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"stage_name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"start_time"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_name"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_id"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"penalty_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"liason_time"]];
                
                if (row8 && [row8 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"rest_time"]];
                
                if (row9 && [row9 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row10 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                
                if (row10 && [row10 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row11 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                
                if (row11 && [row11 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row12 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"split_count"]];
                
                
                if (row12 && [row12 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 12,[row12 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 12, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row13 = @"Lat";
                
                if (row13 && [row13 length] > 0)
                {
                    sqlite3_bind_text(statement, 13,[row13 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 13, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row14 = @"Long";
                
                if (row14 && [row14 length] > 0)
                {
                    sqlite3_bind_text(statement, 14,[row14 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 14, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK)
            {
                //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                return -1;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                // printf("db error: %s\n", sqlite3_errmsg(masterDB));
                return -1;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
            returnValue = sqlite3_last_insert_rowid(_database);
            return returnValue;
        }
        @catch (NSException *e)
        {
            NSLog(@":::: Exception : %@",e);
        }
        return -1;
    }
    
    
}
-(BOOL)insertProfileDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Profile_Table'('user_id','firstName','lastName','emailId','contact','company','website','socialLink','eventCategory','photo','address') values(?,?,?,?,?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"user_id"]];
                
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"firstName"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"lastName"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"emailId"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"contact"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"company"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"website"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                 NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"socialLink"]];
                
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                 NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"eventCategory"]];
                
                if (row9 && [row9 length] > 0)
                {
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                 NSString *row10 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                
                if (row10 && [row10 length] > 0)
                {
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row11 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"address"]];
                
                if (row11 && [row11 length] > 0)
                {
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}
-(BOOL)insertTotalParticipantsDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            // BY RAJU 9-7-2015
            
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
//            sqlQuery=[NSString stringWithFormat:@"insert into 'Participants_Table'('user_id','name','emailId','country','compititorNumber','verified') values(?,?,?,?,?,?)"];//kp12
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Participants_Table'('user_id','name','emailId','country','compititorNumber','verified') values(?,?,?,?,?,?)"];//kp12

            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"user_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"name"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"emailId"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"country"]];
                
                if (row4 && [row4 length] > 0)
                {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"compititorNumber"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"verified"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                

                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
}

-(BOOL)insertTotalSponsorsDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Sponsors_Table'('sponser_id','sponser_name','address','contact_no','created_date','email','photo','website') values(?,?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
               
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"sponser_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"sponser_name"]];
                if (row2 && [row2 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"address"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"contact_no"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"email"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"website"]];
                if (row8 && [row8 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertRaceTypeDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'RaceType_Table'('race_type_id','race_name','is_active','created_by','created_date','updated_by','updated_date') values(?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"race_type_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"race_name"]];
                if (row2 && [row2 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"is_active"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_by"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_by"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertEventCategoryDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'EventCategory_Table'('event_cat_id','cat_name','is_active','created_by','created_date','updated_by','updated_date') values(?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_cat_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"cat_name"]];
                if (row2 && [row2 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"is_active"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_by"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_by"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertEventDevicesDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'EventDevices_Table'('device_id','factory_id','name','created_date') values(?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                
                NSString *row1 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"factory_id"]];
                if (row2 && [row2 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
               
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

#pragma mark Update methods

-(BOOL)updateMainTable:(NSDictionary *)dictInfo with:(NSString *)mainId
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update Main_Table set event_id = ?,organiser_name = ?, event_name = ?, location = ?, photo = ?, start_time = ?, end_time = ?, event_date = ? where id ='%@'",mainId];
            
            //
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row2 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"organiser_name"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"event_name"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"location"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                    
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"photo"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"start_time"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"end_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@",[dictInfo valueForKey:@"event_date"]];
                
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
}

-(BOOL)updateGeneralInfo:(NSDictionary *)dictInfo with:(NSString *)mainId
{
    {
        
        @try
        {
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update GeneralInfo_Table set event_id = ?, event_name = ?, cat_name = ?, age_category = ?, location = ?,event_date = ?,event_start_date = ?,event_end_date = ?,manual_start = ?,race_description = ?,competitors_count = ?,sponser_count = ?,website_url = ?,start_method = ?,race_name = ?,updated_date = ?,organiser_name = ?  where event_id ='%@'",mainId];//jam15-07-2015.
            
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_name"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"cat_name"]];
                if (row3 && [row3 length] > 0)
                {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"age_category"]];
                if (row4 && [row4 length] > 0)
                {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"location"]];
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row6 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_date"]];
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_start_date"]];
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_end_date"]];
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row9 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"manual_start"]];
                if (row9 && [row9 length] > 0)
                {
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row10 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"race_description"]];
                if (row10 && [row10 length] > 0)
                {
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row11 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"competitors_count"]];
                if (row11 && [row11 length] > 0)
                {
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row12 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"sponser_count"]];
                if (row12 && [row12 length] > 0)
                {
                    sqlite3_bind_text(statement, 12,[row12 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 12, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row13 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"website_url"]];
                if (row13 && [row13 length] > 0)
                {
                    sqlite3_bind_text(statement, 13,[row13 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 13, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row14 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"start_method"]];
                if (row14 && [row14 length] > 0)
                {
                    sqlite3_bind_text(statement, 14,[row14 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 14, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row15 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"race_name"]];
                if (row15 && [row15 length] > 0)
                {
                    sqlite3_bind_text(statement, 15,[row15 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 15, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row16 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"updated_date"]];
                if (row16 && [row16 length] > 0)
                {
                    sqlite3_bind_text(statement, 16,[row16 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 16, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                NSString *row17 = [NSString stringWithFormat:@"%@", [dictInfo valueForKey:@"organiser_name"]];//jam15-07-2015.
                if (row17 && [row17 length] > 0)
                {
                    sqlite3_bind_text(statement, 17,[row17 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 17, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                

                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)updateImages:(NSDictionary *)dictInfo with:(NSString *)imageId
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update Images_Table set event_id = ?, event_photo1 = ?,event_photo2 = ?,event_photo3 = ? where id ='%@'",imageId];
            
            
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                    
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo1"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo2"]];
                if (row3 && [row3 length] > 0) {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_photo3"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }

                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(int)updateStages:(NSDictionary *)dictInfo with:(NSString *)mainId
{
    {
        
        @try
        {
            
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            int returnValue;
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK) {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE) {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update Stages_Table set event_id = ?, event_stage_id = ?,stage_name = ?,start_time = ?,device_name = ?, device_id = ?,penalty_time = ?,liason_time = ?,rest_time = ?,created_date = ?,updated_date = ?,split_count = ? where id ='%@'",mainId];
            
            
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"event_stage_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"stage_name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"start_time"]];
                if (row4 && [row4 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_name"]];
                if (row5 && [row5 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_id"]];
                if (row6 && [row6 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"penalty_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"liason_time"]];
                
                if (row8 && [row8 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"rest_time"]];
                
                if (row9 && [row9 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row10 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                
                if (row10 && [row10 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 10,[row10 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 10, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row11 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                
                if (row11 && [row11 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 11,[row11 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 11, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row12 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"split_count"]];
                
                
                if (row12 && [row12 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 12,[row12 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 12, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK)
            {
                //printf("db error: %s\n", sqlite3_errmsg(masterDB));
                return -1;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                // printf("db error: %s\n", sqlite3_errmsg(masterDB));
                return -1;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
            returnValue = sqlite3_last_insert_rowid(_database);
            return returnValue;
        }
        @catch (NSException *e)
        {
            NSLog(@":::: Exception : %@",e);
        }
        return -1;    }
    
    
}
-(BOOL)updateSplits:(NSDictionary *)dictInfo with:(NSString *)mainId
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            sqlQuery=[NSString stringWithFormat:@"update Splits_Table set event_stage_id = ?, stage_split_id = ?,split_name = ?,start_time = ?, device_name = ?,device_id = ?,penalty_time = ?,created_date = ?,updated_date = ? where id ='%@'",mainId];
            
            
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"event_stage_id"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"stage_split_id"]];
                if (row2 && [row2 length] > 0)
                {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"split_name"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"start_time"]];
                
                if (row4 && [row4 length] > 0)
                {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row5 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_name"]];
                
                if (row5 && [row5 length] > 0)
                {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row6 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"device_id"]];
                
                if (row6 && [row6 length] > 0)
                {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row7 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"penalty_time"]];
                
                if (row7 && [row7 length] > 0)
                {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row8 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_date"]];
                
                if (row8 && [row8 length] > 0)
                {
                    sqlite3_bind_text(statement, 8,[row8 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 8, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row9 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"updated_date"]];
                
                if (row9 && [row9 length] > 0)
                {
                    sqlite3_bind_text(statement, 9,[row9 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 9, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES)
                {
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE)
                    {
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}
@end
