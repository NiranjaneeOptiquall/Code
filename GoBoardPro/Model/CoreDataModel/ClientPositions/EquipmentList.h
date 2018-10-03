//
//  EquipmentList.h
//  GoBoardPro
//
//  Created by ind726 on 04/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo, IncidentReportInfo;

@interface EquipmentList : NSManagedObject

@property (nonatomic, retain) NSString * equipmentId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;
@property (nonatomic, retain) IncidentReportInfo *incidentType;

@end
