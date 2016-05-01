//
//  ViewController.m
//  SqliteDBDemo
//
//  Created by Dishant on 30/04/16.
//  Copyright © 2016 dishant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *docDir;
    NSArray *dirPaths;
    
    // 1.  Identifies the application’s Documents directory and constructs a path to the contacts.db database file.
    
        // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docDir = dirPaths[0];
    
        // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:@"EmployeeInfo.db"]];
    NSLog(@"database path = %@",_databasePath);
    // 2.  Creates an NSFileManager instance and subsequently uses it to detect if the database file already exists.
    
        NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
     
   // 3.  If the file does not yet exist the code converts the path to a UTF-8 string and creates the database via a call to the SQLite sqlite3_open() function, passing through a reference to the contactDB variable declared previously in the interface file.
        
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_EmployeeInfo) == SQLITE_OK)
        {
            char *errMsg;
    // 4.  Prepares a SQL statement to create the contacts table in the database.
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS EmployeeDB (EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT, EmployeeName TEXT, Email TEXT, PhoneNumber INTEGER)";
            
//            CREATE TABLE "EmployeeDB" (
//                                       `EmployeeID`	INTEGER,
//                                       `EmployeeName`	TEXT,
//                                       `Email`	TEXT,
//                                       `PhoneNumber`	INTEGER,
//                                       PRIMARY KEY(EmployeeID)
//                                       )
            
            if (sqlite3_exec(_EmployeeInfo, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Failed to create table" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

            }
            
       // 5.  Closes the database.
            sqlite3_close(_EmployeeInfo);
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Failed to open/create database" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open (dbpath,&_EmployeeInfo)== SQLITE_OK )
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO EmployeeDB (EmployeeID, EmployeeName, Email, PhoneNumber) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                               self.employeeID.text, self.employeeName.text, self.employeeEmail.text,self.employeeMobile.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_EmployeeInfo, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Contact Added" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];

            self.employeeID.text = @"";
            self.employeeName.text = @"";
            self.employeeEmail.text = @"";
            self.employeeMobile.text = @"";
            

        }

        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Failed to add contact" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:ok];
            
               [self presentViewController:alert animated:YES completion:nil];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_EmployeeInfo);
    }
}

- (IBAction)Find:(id)sender {
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_EmployeeInfo) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT EmployeeName, Email, PhoneNumber FROM EmployeeDB WHERE EmployeeID=\"%@\"",
                              _employeeID.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_EmployeeInfo,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 0)];
                _employeeName.text = addressField;
                NSString *Email = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                _employeeEmail.text = Email;
                
                NSString *Mobile = [[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 2)];
                _employeeMobile.text = Mobile;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Match found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Match not found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                _employeeName.text = @"";
                _employeeEmail.text = @"";
                _employeeMobile.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_EmployeeInfo);
    }
}


@end
