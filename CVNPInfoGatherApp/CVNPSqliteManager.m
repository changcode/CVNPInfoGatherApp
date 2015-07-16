//
//  CVNPSqliteManager.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPSqliteManager.h"

#import "FMDatabase.h"

@interface CVNPSqliteManager()

@property (strong, nonatomic) NSString * dbFilePath;

@end

@implementation CVNPSqliteManager

static CVNPSqliteManager *CVNPSqliteDao = nil;

+ (CVNPSqliteManager *)sharedCVNPSqliteManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CVNPSqliteDao = [[self alloc] init];
        [CVNPSqliteDao CreateTable];
    });
    return CVNPSqliteDao;
}

- (void)CreateTable{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * DBpath = [doc stringByAppendingPathComponent:@"CVNPDB"];
    
    if (![fileManager fileExistsAtPath:DBpath]) {
        [fileManager createDirectoryAtPath:DBpath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    self.dbFilePath = [DBpath stringByAppendingPathComponent:@"CVNPInfoGatherApp.sqlite"];
    
    NSLog(@"DBPath = %@", DBpath);
    
    if (![fileManager fileExistsAtPath:self.dbFilePath]) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
        if ([db open]) {
            NSString * Localsql  = @"CREATE TABLE 'Location' ('ID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Title' VARCHAR(100), 'Longitude' VARCHAR(30), 'Latitude' VARCHAR(30), 'Description' VARCHAR(255), 'Createdate' VARCHAR(50), 'User_ID' VARCHAR(30), 'Categories_ID' VARCHAR(30), 'Photo_ID' INTEGER, 'isUploaded' INTEGER, 'Server_ID' VARCHAR(30))";
            NSString * CategorySQL = @"CREATE TABLE 'Category' ('ID' INTEGER PRIMARY KEY, 'Name' VARCHAR(100), 'Description' VARCHAR(255), 'ParentID' INTEGER, 'User_ID' VARCHAR(30) )";
            NSString * PhotoSQL = @"CREATE TABLE 'Photo' ('ID' INTEGER PRIMARY KEY, 'FileName' VARCHAR(30), 'User_ID' INTEGER)";
            BOOL location_res = [db executeUpdate:Localsql];
            BOOL category_res = [db executeUpdate:CategorySQL];
            BOOL photo_res = [db executeUpdate:PhotoSQL];
            if (location_res && category_res && photo_res) {
                NSLog(@"succ to creating db table");
            } else {
                NSLog(@"error when creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
    NSLog(@"%@",self.dbFilePath);
}

#pragma mark - Location Method

- (BOOL)InsertLocal: (CVNPPointsModel *)Point
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * sql = @"INSERT INTO Location (Title, Longitude, Latitude, Description, Createdate, User_ID, Categories_ID, Photo_ID, isUploaded, Server_ID) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        NSString * title = Point.Title;
        NSString * Longitude = Point.Longitude;
        NSString * Latitude = Point.Latitude;
        NSString * Description = Point.Description;
        NSString * Createdate = Point.CreateDate;
        NSString * User_ID = Point.User_ID ? Point.User_ID : @"-1";
        NSString * Category_ID = Point.Category ? Point.Category : @"-1";
        NSNumber * Photo_ID = Point.Photo_ID ? Point.Photo_ID : [NSNumber numberWithInt:-1];
        NSNumber * isUploaded = [NSNumber numberWithInteger:(Point.isUpdated ? (NSInteger)1 :(NSInteger)0)];
        NSString * Server_ID = Point.Server_ID ? Point.Server_ID : @"-1";
        
        BOOL res = [db executeUpdate:sql, title, Longitude, Latitude, Description, Createdate, User_ID, Category_ID, Photo_ID, isUploaded, Server_ID];
        [db close];
        if (!res) {
            NSLog(@"error to insert data");
            return false;
        } else {
            NSLog(@"succ to insert data");
            return true;
        }
    }
    return false;
}

- (BOOL)DeleteLocalById: (int)ID
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * sql = @"DELETE FROM Location WHERE id = ?";
        NSNumber *delid = [[NSNumber alloc] initWithInt:ID];
        
        BOOL res = [db executeUpdate:sql, delid];
        [db close];
        if (!res) {
            NSLog(@"error to delete data");
            return false;
        } else {
            NSLog(@"succ to delete data");
            return true;
        }
        
    }
    return false;
}

- (BOOL)DeleteLocalByIds:(NSArray *)IDs
{
    for (NSString *ID in IDs) {
        [self DeleteLocalById:[ID intValue]];
    }
    return true;
}

- (BOOL)UpdateLocalById: (int)ID newPoint:(CVNPPointsModel *)Point
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * sql = @"UPDATE Location SET Title = ?, Description = ?, Categories_ID = ?, isUploaded = ?, Server_ID = ? WHERE ID = ?";
        NSNumber *updateid = [[NSNumber alloc] initWithInt:ID];
        NSNumber *isUpdated = [NSNumber numberWithInteger:Point.isUpdated ? (NSInteger)1 : (NSInteger)0];
        BOOL res = [db executeUpdate:sql, Point.Title, Point.Description, Point.Category, isUpdated, Point.Server_ID, updateid];
        [db close];
        if (!res) {
            NSLog(@"error to update data");
            return false;
        } else {
            NSLog(@"succ to update data");
            return true;
        }
    }
    return false;
}

- (NSArray *)QueryAllLocal
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    NSMutableArray *allLocalPoints = [[NSMutableArray alloc] init];
    if ([db open]) {
        NSString * sql = @"SELECT * FROM Location";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *Title = [rs stringForColumn:@"Title"];
            NSString *Longtitude = [rs stringForColumn:@"Longitude"];
            NSString *Latitude = [rs stringForColumn:@"Latitude"];
            NSString *Description = [rs stringForColumn:@"Description"];
            NSString *Date = [rs stringForColumn:@"CreateDate"];
            NSString *User_ID = [rs stringForColumn:@"User_ID"];
            NSString *Categories_ID = [rs stringForColumn:@"Categories_ID"];
            NSNumber *Photo_ID = [[NSNumber alloc] initWithInt:[[rs stringForColumn:@"Photo_ID"] intValue]];
            NSString *Local_ID = [rs stringForColumn:@"ID"];
            BOOL isUploaded = [[rs stringForColumn:@"isUploaded"] isEqualToString:@"1"] ? YES : NO;
            CVNPPointsModel *point = [[CVNPPointsModel alloc] initWithLongitude:Longtitude Latitdue:Latitude Title:Title Description:Description User_ID:User_ID Server_ID:nil CreateDate:Date];
            [point setCategory:Categories_ID];
            [point setPhoto_ID:Photo_ID];
            [point setIsUpdated:isUploaded];
            [point setLocal_ID:Local_ID];
            [allLocalPoints addObject:point];
        }
        [db close];
    }
    return allLocalPoints;
}

- (BOOL)SyncFromRemote:(CVNPPointsModel *)Point
{
    NSString * title = Point.Title;
    NSString * Longitude = Point.Longitude;
    NSString * Latitude = Point.Latitude;
    NSString * Description = Point.Description;
    NSString * Createdate = Point.CreateDate;
    NSString * User_ID = Point.User_ID;
    NSNumber * isUploaded = [NSNumber numberWithInt:1];
    NSString * Server_ID = Point.Server_ID ? Point.Server_ID : @"0";
    
    BOOL exists;
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * selectsql = @"SELECT * FROM Location WHERE Server_ID = ?";
        NSString * insertsql = @"INSERT INTO Location (Title, Longitude, Latitude, Description, Createdate, User_ID, isUploaded, Server_ID) VALUES(?, ?, ?, ?, ?, ?, ?, ?) ";
        
        FMResultSet * qryres = [db executeQuery:selectsql, Server_ID];
        if ([qryres next]) {
            NSLog(@"rej insert already existed");
            exists = FALSE;
            [db close];
            return FALSE;
        }
        else
        {
            BOOL insres = [db executeUpdate:insertsql, title, Longitude, Latitude, Description, Createdate, User_ID, isUploaded, Server_ID];
            if (!insres) {
                NSLog(@"error to sync data");
                return false;
            } else {
                NSLog(@"succe to sync data");
                return true;
            }
        }
    }
    return TRUE;
}

#pragma mark - Category Method

- (BOOL)InsterALLCategoriesFrom:(NSArray *)Categories
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * sql = @"INSERT INTO Category (ID, Name, Description, ParentID) VALUES(?, ?, ?, ?) ";
        for (CVNPCategoryModel *cate in Categories) {
            NSNumber * ID = [NSNumber numberWithInt:[cate.Cat_ID intValue]];
            NSString * Name = cate.Cat_Name ? cate.Cat_Name : @"";
            NSString * Description = cate.Cat_Description ? cate.Cat_Description : @"";
            NSNumber * parent_ID = [NSNumber numberWithInt:[cate.Cat_Parent_ID intValue]];
            
            BOOL res = [db executeUpdate:sql, ID, Name, Description, parent_ID];
            if (!res) {
                NSLog(@"error when insert to category db table");
            } else {
                NSLog(@"succ to insert to category db table");
            }
        }
        [db close];
        return TRUE;
    } else {
        NSLog(@"error when open db");
        return FALSE;
    }
}

- (BOOL)DeleteALLCategories
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString * sql = @"DELETE FROM Category";
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"succ delete all category");
        } else {
            NSLog(@"error delete all category");
        }
        [db close];
        return TRUE;
    } else {
        NSLog(@"error when open db");
        return FALSE;
    }
}

- (CVNPCategoryModel *)QueryCategoryInfoById:(NSString *)ID
{
    CVNPCategoryModel *result = [CVNPCategoryModel new];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString *sql = @"SELECT * FROM Category WHERE ID = ?";
        FMResultSet *rs = [db executeQuery:sql, ID];
        while ([rs next]) {
            NSDictionary *dict = @{
                                   @"id" : [rs stringForColumn:@"ID"],
                                   @"name" : [rs stringForColumn:@"Name"],
                                   @"description" : [rs stringForColumn:@"Description"],
                                   @"parentID" : [rs stringForColumn:@"ParentID"],
                                   };
            CVNPCategoryModel *cate = [[CVNPCategoryModel alloc] initWithAttributes:dict];
            return cate;
        }
        [db close];
        return result;
    }
    else {
        NSLog(@"error when open db");
        return nil;
    }
}

- (NSArray *)QueryAllCategories
{
    NSMutableArray *result = [NSMutableArray new];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString *sql = @"SELECT * FROM Category WHERE ParentID != 0";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dict = @{
                                   @"id" : [rs stringForColumn:@"ID"],
                                   @"name" : [rs stringForColumn:@"Name"],
                                   @"description" : [rs stringForColumn:@"Description"],
                                   @"parentID" : [rs stringForColumn:@"ParentID"],
                                   };
            CVNPCategoryModel *cate = [[CVNPCategoryModel alloc] initWithAttributes:dict];
            [result addObject:cate];
        }
        [db close];
        return result;
    }
    else {
        NSLog(@"error when open db");
        return nil;
    }
}

- (NSArray *)QueryChildCategoriesByCate:(CVNPCategoryModel *)cate
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSNumber * ID = [NSNumber numberWithInt:[cate.Cat_ID intValue]];
        NSString *sql = @"SELECT * FROM Category WHERE ParentID = ?";
        FMResultSet *rs = [db executeQuery:sql, ID];
        while ([rs next]) {
            NSDictionary *dict = @{
                                   @"id" : [rs stringForColumn:@"ID"],
                                   @"name" : [rs stringForColumn:@"Name"],
                                   @"description" : [rs stringForColumn:@"Description"],
                                   @"parentID" : [rs stringForColumn:@"ParentID"],
                                   };
            CVNPCategoryModel *cate = [[CVNPCategoryModel alloc] initWithAttributes:dict];
            [result addObject:cate];
        }
        [db close];
        return result;
    }
    else {
        NSLog(@"error when open db");
        return nil;
    }
}

- (BOOL)JudgeCategriesHasChildren:(CVNPCategoryModel *)cate
{
    int result = 0;
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSNumber * ID = [NSNumber numberWithInt:[cate.Cat_ID intValue]];
        NSString *sql = @"SELECT COUNT(ID) FROM Category WHERE ParentID = ?";
        FMResultSet *rs = [db executeQuery:sql, ID];
        while ([rs next]) {
            result = [rs intForColumnIndex:0];
        }
        [db close];
        if (result > 0) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
    else {
        NSLog(@"error when open db");
    }
    return FALSE;
}

#pragma mark - Photo Method

- (BOOL)InsertPhotoRecordswithFileName:(NSString *)PhotoFileName andUser_ID:(NSString *)User_ID
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString *sql = @"INSERT INTO Photo (FileName, User_ID) VALUES(?, ?)";
        BOOL rs = [db executeUpdate:sql, PhotoFileName, [NSNumber numberWithInt:[User_ID intValue]]];
        if (!rs) {
            NSLog(@"error when insert to photo db table");
        } else {
            NSLog(@"succ to insert to photo db table");
        }
        [db close];
        return TRUE;
    }else {
        NSLog(@"error when open db");
        return FALSE;
    }
}

- (NSString *)QueryFileNameByPhotoID:(NSNumber *)Photo_ID
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString *sql = @"SELECT FileName FROM Photo WHERE ID = ? LIMIT 1";
        FMResultSet *rs = [db executeQuery:sql, Photo_ID];
        while ([rs next]) {
            NSString *result= [rs stringForColumn:@"FileName"];
            return result;
        }
        [db close];
        return nil;
    } else {
        NSLog(@"Error when open db!");
        return nil;
    }
}

- (NSNumber *)QueryIdByPhotoFileName:(NSString *)PhotoFileName
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbFilePath];
    if ([db open]) {
        NSString *sql = @"SELECT ID FROM Photo WHERE FileName = ? LIMIT 1";
        FMResultSet *rs = [db executeQuery:sql, PhotoFileName];
        while ([rs next]) {
            NSNumber *result= [[NSNumber alloc] initWithInt:[rs intForColumn:@"ID"]];
            return result;
        }
        [db close];
        return [[NSNumber alloc] initWithInt:-1];
    } else {
        NSLog(@"Error when open db!");
        return [[NSNumber alloc] initWithInt:-1];
    }
}

@end
