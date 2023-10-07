//
//  QuickFireInfo.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct QuickFireInfo: View {
    @EnvironmentObject var fireTD: FireTestData
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            NavigationBarItem(data: Double(fireTD.suspect.count), decimals: 0, label: "Suspect")
            NavigationBarItem(data: Double(fireTD.verified.count), decimals: 0, label: "Verified")
            NavigationBarItem(data: Double(fireTD.tending.count), decimals: 0, label: "Tending")
        }
    }
}

struct QuickFireInfo_Previews: PreviewProvider {
    static var previews: some View {
        QuickFireInfo()
    }
}
