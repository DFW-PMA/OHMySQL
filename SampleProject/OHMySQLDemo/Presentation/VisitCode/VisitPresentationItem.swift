//
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation

struct VisitPresentationItem:Identifiable 
{

    var id:UUID

    var visitId:String
    var patientId:String
    var therapistId:String
    var supervisorId:String

    var visitDate:String
    var visitTime:String
    var visitType:String
    var visitBilled:String

}
