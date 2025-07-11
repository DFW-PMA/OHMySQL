//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI

struct VisitListView:View 
{

    @ObservedObject var visitListViewModel:VisitListViewModel = VisitListViewModel()
    
    var body:some View 
    {

        Group 
        {
            switch visitListViewModel.state 
            {
            case .idle:
                ProgressView()
                    .progressViewStyle(.circular)
            case .fetched:
                List 
                {
                    ForEach(visitListViewModel.visits)
                    { visit in

                        VStack(alignment:.leading) 
                        {
                            Text(visit.name ?? "-").font(.headline)
                            Text(visit.visitDescription ?? "-").font(.subheadline)
                        }

                    }
                    .onDelete 
                    { indexSet in

                        try? visitListViewModel.delete(at: indexSet)

                    }
                }
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

