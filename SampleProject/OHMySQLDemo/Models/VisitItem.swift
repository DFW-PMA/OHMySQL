//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
// import OHMySQL

@objc
final class VisitItem:NSObject 
{

    @objc var visitId:NSNumber?
    @objc var name:NSString?
    @objc var visitDescription:NSString?
    @objc var status:NSNumber?
    @objc var decimalValue:NSNumber?
    @objc var visitData:NSData?

}

extension VisitItem:MySQLMappingProtocol 
{

    func mappingDictionary()->[AnyHashable:Any] 
    {

        [
            "visitId"          : "id",
            "name"             : "name",
            "visitDescription" : "description",
            "status"           : "status",
            "decimalValue"     : "preciseValue",
            "visitData"        : "data",
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

