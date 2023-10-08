//
//  QuickFireInfo.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct QuickFireInfo: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "suspect")) var suspectFires: FetchedResults<Fire>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "verified")) var verifiedFires: FetchedResults<Fire>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "resp")) var respondingFires: FetchedResults<Fire>
    @EnvironmentObject var fireTestData: FireTestData
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            NavigationBarItem(data: Double(fireTestData.suspect.count), decimals: 0, label: "Suspect")
            NavigationBarItem(data: Double(fireTestData.verified.count), decimals: 0, label: "Verified")
            NavigationBarItem(data: Double(fireTestData.tending.count), decimals: 0, label: "Resp")
        }
    }
}

struct QuickFireInfo_Previews: PreviewProvider {
    static var previews: some View {
        QuickFireInfo()
    }
}
