//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI

struct VisitListView:View 
{

    @ObservedObject var visitListViewModel:VisitListViewModel = VisitListViewModel()
    
    var body:some View 
    {

        VStack
        {
            switch visitListViewModel.state 
            {
            case .idle:
                ProgressView()
                    .progressViewStyle(.circular)
            case .fetched:
                HStack
                {
                    Spacer()
                    Text("#(\(visitListViewModel.visits.count)) Visit(s)")
                    Spacer()
                }
                Table(of:VisitPresentationItem.self)
                {
                    TableColumn("VisitId", value:\.visitId)
                    //  .width(min:10, max:12)
                    TableColumn("PID",     value:\.patientId)
                    //  .width(min:6, max:10)
                    TableColumn("TID",     value:\.therapistId)
                    //  .width(min:6, max:10)
                    TableColumn("SID",     value:\.supervisorId)
                    //  .width(min:0, max:10)
                    TableColumn("Date",    value:\.visitDate)
                    //  .width(min:10, max:20)
                    TableColumn("Time",    value:\.visitTime)
                    //  .width(min:10, max:20)
                    TableColumn("Type",    value:\.visitType)
                    //  .width(min:6, max:10)
                    TableColumn("Billed",  value:\.visitBilled)
                    //  .width(min:6, max:10)
                }
                rows:
                {
                    ForEach(visitListViewModel.visits)
                    { visit in

                        TableRow(visit)

                    }
                }
                .font(.caption)

            //  List 
            //  {
            //      ForEach(visitListViewModel.visits)
            //      { visit in
            //
            //      //  HStack
            //      //  {
            //      //      Text("(\(visit.visitId)) - ")
            //      //          .font(.subheadline)
            //      //      Text("(\(visit.patientId)) - ")
            //      //          .font(.footnote)
            //      //      Text("(\(visit.therapistId)) - ")
            //      //          .font(.footnote)
            //      //      Text("(\(visit.supervisorId) - ")
            //      //          .font(.footnote)
            //      //      Text("[\(visit.visitDate)]/")
            //      //          .font(.footnote)
            //      //      Text("[\(visit.visitTime)] - ")
            //      //          .font(.footnote)
            //      //      Text("(\(visit.visitType)) - ")
            //      //          .font(.footnote)
            //      //      Text("(\(visit.visitBilled))...")
            //      //          .font(.footnote)
            //      //  }
            //
            //      }
            //      .onDelete 
            //      { indexSet in
            //
            //          try? visitListViewModel.delete(at: indexSet)
            //
            //      }
            //  }
            case .emptyList:
                Text("The list is empty")
            case .error(let message):
                Text(message)
            case .fetching:
                ProgressView()
            }
        }.onAppear 
        {
            visitListViewModel.configureData()
        }
        .toolbar 
        {
            ToolbarItemGroup(placement:.navigationBarTrailing) 
            {
                Button(action: 
                {
                    try? visitListViewModel.deleteAll()
                }, 
                label: 
                {
                    Label("", systemImage:"folder.badge.minus")
                })
                Button(action: 
                {
                    visitListViewModel.addRandomVisit()
                },
                label: 
                {
                    Label("", systemImage:"doc.badge.plus")
                })
            }
        }

    }

}

