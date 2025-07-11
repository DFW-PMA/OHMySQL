//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
// import OHMySQL

final class VisitItemRepository 
{

    struct ClassInfo
    {
        static let sClsId        = "VisitItemRepository"
        static let sClsVers      = "v1.0101"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
    }

    // App Data field(s):

    let coordinator:PersistentCoordinator
    
    init(coordinator:PersistentCoordinator)
    {

        self.coordinator = coordinator

    }
    
    private func xcgLogMsg(_ sMessage: String)
    {

        let dtFormatterDateStamp:DateFormatter = DateFormatter()

        dtFormatterDateStamp.locale     = Locale(identifier: "en_US")
        dtFormatterDateStamp.timeZone   = TimeZone.current
        dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"

        let dateStampNow:Date = .now
        let sDateStamp:String = ("\(dtFormatterDateStamp.string(from: dateStampNow)) >> ")

        print("\(sDateStamp)\(sMessage)")

    }

    func createTable() throws 
    {
    //  let createTableString =
    //  """
    //      CREATE TABLE `visits` 
    //      (
    //        `id` int(11) NOT NULL,
    //        `name` varchar(255) DEFAULT NULL,
    //        `description` varchar(10000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    //        `status` bigint(11) DEFAULT NULL,
    //        `data` blob NOT NULL,
    //        `preciseValue` decimal(65,30) NOT NULL
    //      ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    //  """
    //
    //  let primaryKeyString   = "ALTER TABLE `visits` ADD PRIMARY KEY (`id`);"
    //  let incrementKeyString = "ALTER TABLE `visits` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;"
    //  
    //  for query in [createTableString, primaryKeyString, incrementKeyString] 
    //  {
    //
    //      let request = MySQLQueryRequest(query:query)
    //
    //      try coordinator.mainQueryContext.execute(request)
    //
    //  }
    //
    }
    
    func fetch() throws->[VisitItem] 
    {

        let sCurrMethod:String     = #function
        let sCurrMethodDisp:String = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
    //  let query  = MySQLQueryRequestFactory.select("visit", condition:nil)
    //  let visits = try MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        let mySqlQuery = MySQLQueryRequestFactory.select("visit", condition:"vdate >= '2025-07-11'")
        let visits     = try MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(mySqlQuery)

        self.xcgLogMsg("\(sCurrMethodDisp) 'visits' object is 'typeOf' [\(String(describing: type(of: visits)))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'visits' object contains #(\(String(describing: visits?.count))) object(s)...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'visits' object is [\(String(describing: visits))]...")
        
        return visits?
            .compactMap { $0 }
            .map 
            {
                let visit = VisitItem()
                visit.map(fromResponse:$0)
                return visit
            } ?? []

    }
    
    func addVisitItem(_ item:VisitItem, completion:@escaping(Result<Void, Error>)->()) 
    {

    //  coordinator.mainQueryContext.insertObject(item)
    //
    //  coordinator.mainQueryContext.save 
    //  { error in
    //
    //      completion(error != nil ? .failure(error!) : .success(()))
    //
    //  }

    }
    
    func deleteVisitItem(_ item:VisitItem, completion:@escaping(Result<Void, Error>)->()) 
    {

    //  coordinator.mainQueryContext.deleteObject(item)
    //  
    //  coordinator.mainQueryContext.save 
    //  { error in
    //
    //      completion(error != nil ? .failure(error!) : .success(()))
    //
    //  }

    }

}

