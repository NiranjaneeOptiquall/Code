//
//  DailyLog+CoreDataProperties.m
//  GoBoardPro
//
//  Created by E2M183 on 2/20/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DailyLog+CoreDataProperties.h"

@implementation DailyLog (CoreDataProperties)

@dynamic date;
@dynamic desc;
@dynamic includeInEndOfDayReport;
@dynamic shouldSync;
@dynamic userId;

@end
