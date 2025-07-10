//
//  Copyright (c) 2022-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
// import OHMySQL

final class PersistentCoordinator 
{

    struct ClassInfo
    {
        static let sClsId        = "PersistentCoordinator"
        static let sClsVers      = "v1.0103"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
    }

    // App Data field(s):

            var mainQueryContext:MySQLQueryContext 
    {
        MySQLContainer.shared.mainQueryContext!
    }
    
    private var coordinator:MySQLStoreCoordinator
    
    private static func makeCoordinator(databaseName:String)->MySQLStoreCoordinator 
    {

    //  let configuration:MySQLConfiguration = MySQLConfiguration(user:      "root",
    //                                                            password:  "",
    //                                                            serverName:"localhost",
    //                                                            dbName:    databaseName,
    //                                                            port:      3306,
    //                                                            socket:    "/tmp/mysql.sock")

        let configuration:MySQLConfiguration = MySQLConfiguration(user:      "root",
                                                                  password:  "root@pts",
                                                                  serverName:"173.194.83.155",
                                                                  dbName:    databaseName,
                                                                  port:      3306,
                                                                  socket:    "/tmp/mysql.sock")

        configuration.writeTimeout           = 15
        configuration.readTimeout            = 5
        
        return MySQLStoreCoordinator(configuration:configuration)

    }
    
    init() 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.coordinator = Self.makeCoordinator(databaseName:"ptsdb")
    //  self.coordinator = Self.makeCoordinator(databaseName:"mysql")
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }
    
    private func xcgLogMsg(_ sMessage: String)
    {
        let dtFormatterDateStamp: DateFormatter = DateFormatter()
        dtFormatterDateStamp.locale = Locale(identifier: "en_US")
        dtFormatterDateStamp.timeZone = TimeZone.current
        dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"

        let dateStampNow: Date = .now
        let sDateStamp: String = ("\(dtFormatterDateStamp.string(from: dateStampNow)) >> ")

        print("\(sDateStamp)\(sMessage)")
    }

    func reconnect()->Bool 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        coordinator.disconnect()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return coordinator.connect()

    }
    
    func connect()->Bool 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        coordinator.encoding                   = .UTF8MB4
        let context                            = MySQLQueryContext()
        context.storeCoordinator               = coordinator
        MySQLContainer.shared.mainQueryContext = context
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return coordinator.connect()

    }
    
    func createDatabase(_ databaseName:String) throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        let request = MySQLQueryRequest(query:"CREATE DATABASE \(databaseName);")
        
        try mainQueryContext.execute(request)

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }
    
    func selectDatabase(_ databaseName:String)->Bool 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // TODO: For some reason `coordinator.selectDataBase()` doesn't work. Investigate

        self.coordinator = Self.makeCoordinator(databaseName:databaseName)

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return connect()

    }

}

