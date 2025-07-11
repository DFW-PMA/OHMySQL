//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
// import OHMySQL

final class VisitListViewModel:ObservableObject 
{

    enum State 
    {
        case idle
        case fetching
        case fetched
        case emptyList
        case error(message:String)
    }
    
    private      let storeCoordinator:PersistentCoordinator = PersistentCoordinator()
    private lazy var visitRepository:VisitItemRepository    = VisitItemRepository(coordinator:self.storeCoordinator)
    
    private(set) var visits:[VisitPresentationItem]         = [VisitPresentationItem]()
    {
        didSet 
        {
            state = visits.isEmpty ? .emptyList : .fetched
        }
    }
    
    @Published   var state:State                            = .idle
//  @Published   var state:State                            = .emptyList
    
    func configureData()
    {

        self.state = .fetching
    //  self.state = .emptyList
        
        guard self.storeCoordinator.connect() 
        else 
        {
            self.state = .error(message:"Cannot connect to database")

            return
        }
        
        do 
        {
            self.visits = try self.fetchVisits()
        } 
        catch 
        {
            do 
            {
                try self.handleDatabaseSelection()
            //  self.handleTableCreation()
                
                self.visits = (try? self.fetchVisits()) ?? []
            } 
            catch 
            {
                self.state = .error(message:"Cannot fetch visits")
            }
        }

    }
    
    func addRandomVisit() 
    {

    //  self.state = .fetching
    //  let visit   = VisitItem()
    //
    //  visit.visitDescription = "description"
    //  visit.status          = 1
    //  visit.name            = "Hello"
    //  visit.decimalValue    = 3.14
    //  visit.visitData        = UIDevice.current.identifierForVendor?.uuidString.data(using:.utf8) as? NSData
    //  
    //  visitRepository.addVisitItem(visit) 
    //  { result in
    //
    //      DispatchQueue.main.async 
    //      {
    //          switch result 
    //          {
    //          case .success:
    //              self.visits = (try? self.fetchVisits()) ?? []
    //          case .failure:
    //              self.state = .error(message:"Cannot create a visit")
    //          }
    //      }
    //
    //  }

    }
    
    func deleteAll() throws 
    {

    //  guard let visits = try? visitRepository.fetch() 
    //  else { return }
    //
    //  try delete(at:IndexSet(integersIn:visits.startIndex...visits.endIndex - 1))

    }
    
    func delete(at indexSet:IndexSet) throws 
    {

    //  guard let visits = try? visitRepository.fetch() 
    //  else { return }
    //  
    //  let items   = indexSet.map { visits[$0] }
    //  var counter = 0
    //  
    //  items.forEach 
    //  { item in
    //
    //      visitRepository.deleteVisitItem(item) 
    //      { _ in 
    //
    //          DispatchQueue.main.async 
    //          {
    //              counter += 1
    //              
    //              if counter == items.count 
    //              {
    //                  self.visits = (try? self.fetchVisits()) ?? []
    //              }
    //          }
    //
    //      }
    //
    //  }

    }
    
    private func handleDatabaseSelection() throws
    {

        if storeCoordinator.selectDatabase("visit") 
        {
            return
        }
        
        try storeCoordinator.createDatabase("visit")
        
        if !storeCoordinator.selectDatabase("visit")
        {
            throw URLError(.badServerResponse)
        }

    }
    
    private func handleTableCreation() 
    {

    //  try? visitRepository.createTable()

    }
    
    private func fetchVisits() throws->[VisitPresentationItem] 
    {

        let dateNow:Date = Date()
        let visits       = try visitRepository.fetch()
        
        return visits.map 
        {
            VisitPresentationItem(id:              UUID(),
                                  visitId:         String(describing:$0.visitId).stripOptionalStringWrapper(),
                                  patientId:       String(describing:$0.patientId).stripOptionalStringWrapper(),
                                  therapistId:     String(describing:$0.therapistId).stripOptionalStringWrapper(),
                                  supervisorId:    String(describing:$0.supervisorId).stripOptionalStringWrapper(),
                                  visitDate:       String(describing:$0.visitDate).stripOptionalStringWrapper(),
                                  visitTime:       String(describing:$0.visitTime).stripOptionalStringWrapper(),
                                  visitType:       String(describing:$0.visitType).stripOptionalStringWrapper(),
                                  visitBilled:     String(describing:$0.visitBilled).stripOptionalStringWrapper())
        //  VisitPresentationItem(id:              UUID(),
        //                        visitId:         String(describing:($0.visitId      as? Int)),
        //                        patientId:       String(describing:($0.patientId    as? Int)),
        //                        therapistId:     String(describing:($0.therapistId  as? Int)),
        //                        supervisorId:    String(describing:($0.supervisorId as? Int)),
        //                        visitDate:       String(describing:dateNow),
        //                        visitTime:       String(describing:dateNow),
        //                        visitType:       String(describing:($0.visitType    as? Int)),
        //                        visitBilled:     String(describing:($0.visitBilled  as? Int)))
        //                    //  visitDate:       ($0.visitDate    as? Date)!,
        //                    //  visitTime:       ($0.visitTime    as? Date)!,
        }

    }

}

