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

@property (strong, nonatomic) NSString * dbPath;

@end

@implementation CVNPSqliteManager

@synthesize dbPath;

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
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * path = [doc stringByAppendingPathComponent:@"CVNPInfoGatherApp.sqlite"];
    self.dbPath = path;

    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            NSString * Localsql  = @"CREATE TABLE 'Location' ('ID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Title' VARCHAR(100), 'Longitude' VARCHAR(30), 'Latitude' VARCHAR(30), 'Description' VARCHAR(255), 'Createdate' VARCHAR(50), 'User_ID' VARCHAR(30))";
//            NSString * Remotesql = @"";
            BOOL res = [db executeUpdate:Localsql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
    NSLog(@"%@",dbPath);
}

- (BOOL)InsertLocal: (CVNPPointsModel *)Point
{
    static int idx = 1;
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString * sql = @"INSERT INTO Location (Title, Longitude, Latitude, Description, Createdate, User_ID) VALUES(?, ?, ?, ?, ?, ?) ";
        NSString * title = [NSString stringWithFormat:@"title%d", idx++];
        NSString * Longitude = @"-81.565639";
        NSString * Latitude = @"41.2854277";
        NSString * Description = @"***DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription***";
        
        // 获取系统当前时间
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        //设置时间输出格式：
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * Createdate = [df stringFromDate:currentDate];
        
        NSLog(@"系统当前时间为：%@",Createdate);
        
        NSString * User_ID = [NSString stringWithFormat:@"%d", idx];
        
        BOOL res = [db executeUpdate:sql, title, Longitude, Latitude, Description, Createdate, User_ID];
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
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
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
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString * sql = @"UPDATE Location SET Title = ? WHERE id = ?";
        NSNumber *updateid = [[NSNumber alloc] initWithInt:ID];
        
        BOOL res = [db executeUpdate:sql, @"test", updateid];
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
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *allLocalPoints = [[NSMutableArray alloc] init];
    if ([db open]) {
        NSString * sql = @"SELECT * FROM Location";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int ID = [rs intForColumn:@"ID"];
            NSString *Title = [rs stringForColumn:@"Title"];
            NSString *Longtitude = [rs stringForColumn:@"Longitude"];
            NSString *Latitude = [rs stringForColumn:@"Latitude"];
            NSString *Description = [rs stringForColumn:@"Description"];
            NSString *Date = [rs stringForColumn:@"CreateDate"];
            NSString *User_ID = [rs stringForColumn:@"User_ID"];
            NSString *Local_ID = [rs stringForColumn:@"ID"];
            CVNPPointsModel *point = [[CVNPPointsModel alloc] initWithLongitude:Longtitude Latitdue:Latitude Title:Title Description:Description User_ID:User_ID Server_ID:nil CreateDate:Date];
            [point setLocal_ID:Local_ID];
            [allLocalPoints addObject:point];
            NSLog(@"ID = %d, Title = %@, Longitude = %@, Latitude = %@, Description = %@, Date = %@, User_ID = %@", ID, Title, Longtitude, Latitude, Description, Date, User_ID);
        }
        [db close];
    }
    return allLocalPoints;
}
@end
