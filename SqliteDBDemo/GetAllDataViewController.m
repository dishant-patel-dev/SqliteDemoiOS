//
//  GetAllDataViewController.m
//  SqliteDBDemo
//
//  Created by Dishant on 01/05/16.
//  Copyright © 2016 dishant. All rights reserved.
//

#import "GetAllDataViewController.h"
#import <sqlite3.h>
@interface GetAllDataViewController ()

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *myDatabase;
@property (strong, nonatomic) NSString *statusOfGettingDataFromDB;
@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation GetAllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self GetAllData];
    [_dataTableView reloadData];
}
-(void)GetAllData
{
    // Get the documents directory

    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:
                                     @"EmployeeInfo.db"]];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM EmployeeDB";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [_list removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 1)];
                NSString *mobile = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 3)];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:name forKey:@"employeename"];
                [dic setObject:mobile forKey:@"mobile"];
                [_list addObject:dic];
                
                _statusOfGettingDataFromDB = @"Found!";
                NSLog(@"count: %lu", (unsigned long)[_list count]);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    NSLog(@"DATA: %@", [_list description]);

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       
    }
    
    // Configure the cell...
    cell.textLabel.text = [[_list objectAtIndex:indexPath.row] valueForKey:@"employeename"];
    cell.detailTextLabel.text = [[_list objectAtIndex:indexPath.row] valueForKey:@"mobile"];
    //cell.textLabel.textColor = [UIColor redColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
