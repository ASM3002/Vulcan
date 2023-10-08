//
//  FirePanel.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct FirePanel: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var fireTestData: FireTestData
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "suspect")) var suspectFires: FetchedResults<Fire>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "verified")) var verifiedFires: FetchedResults<Fire>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)], predicate: NSPredicate(format: "responseStatus == %@", "resp")) var respondingFires: FetchedResults<Fire>
    var body: some View {
        VStack(spacing: 15) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Suspect")
                        .foregroundColor(.theme.white)
                        .fontWeight(.semibold)
                        .font(.title2)
                    Divider()
                    ForEach(fireTestData.suspect) { fire in
                        PanelFireDisplay(fire: fire)
                    }
                    Text("Verified")
                        .foregroundColor(.theme.white)
                        .fontWeight(.semibold)
                        .font(.title2)
                    Divider()
                    ForEach(fireTestData.verified) { fire in
                        PanelFireDisplay(fire: fire)
                    }
                    Text("Responding")
                        .foregroundColor(.theme.white)
                        .fontWeight(.semibold)
                        .font(.title2)
                    Divider()
                    ForEach(fireTestData.tending) { fire in
                        PanelFireDisplay(fire: fire)
                    }
                }
            }
        }
        .padding(5)
    }
}

struct PanelFireDisplay: View {
    var fire: Fire_Old
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(fire.longitude)N , \(fire.latitude)W")
                Spacer(minLength: 50)
                Text("H")
            }
            .font(.subheadline)
            .foregroundColor(.theme.white)
            HStack {
                Text("Butte County, CA")
                    .foregroundColor(.theme.white)
                Spacer()
                Text("Elapsed: ").foregroundColor(Color.theme.lightGray) +
                Text(fire.discoveryTS, style: .relative)
                    .foregroundColor(timeColor(fireStatus: fire.responseStatus))
            }
            .font(.caption)
            Divider()
        }
    }
    func timeColor(fireStatus: ResponseStatus) -> Color {
        if fireStatus == .suspect {
            return Color.yellow
        } else if fireStatus == .verified {
            return Color.red
        } else {
            return Color.green
        }
    }
}
