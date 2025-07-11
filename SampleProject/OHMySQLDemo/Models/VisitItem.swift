//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
// import OHMySQL

@objc
final class VisitItem:NSObject 
{

    @objc var visitId:NSNumber?
    @objc var patientId:NSNumber?
    @objc var therapistId:NSNumber?
    @objc var supervisorId:NSNumber?
    @objc var visitDate:NSDate?
    @objc var visitTime:NSDate?
    @objc var visitType:NSNumber?
    @objc var visitBilled:NSNumber?

}

extension VisitItem:MySQLMappingProtocol 
{

    func mappingDictionary()->[AnyHashable:Any] 
    {

        [
            "visitId"      : "vid",
            "patientId"    : "pid",
            "therapistId"  : "tid",
            "supervisorId" : "superid",
            "visitDate"    : "vdate",
            "visitTime"    : "vstime",
            "visitType"    : "type",
            "visitBilled"  : "billed",
        ]

    }
    
    func mySQLTable()->String 
    {

        "visit"

    }
    
    func primaryKey()->String 
    {

        "visitId"

    }

}

