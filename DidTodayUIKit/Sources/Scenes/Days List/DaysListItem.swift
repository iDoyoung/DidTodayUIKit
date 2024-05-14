import Foundation
   
struct DaysListItem {
    var date: Date
    var dids: [Did]
    var count: Int {
        dids.count
    }
}
