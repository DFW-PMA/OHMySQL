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

        let visits = try visitRepository.fetch()
        
        return visits.map 
        {
            VisitPresentationItem(id:              $0.visitId?.stringValue ?? UUID().uuidString,
                                  name:            $0.name as? String,
                                  status:          $0.status as? Int,
                                  visitDescription:$0.visitDescription as? String)
        }

    }

}

