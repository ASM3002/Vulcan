//
//  GeneralPanel.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct GeneralPanel: View {
    @EnvironmentObject var manTestData: ManagementTestData
    @State var fireDateRange: Int = 24
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(manTestData.testAccount.name)
                .foregroundColor(.theme.white)
                .font(.largeTitle)
                .fontWeight(.semibold)
            //Fire Dates Picker
            Picker("", selection: $fireDateRange) {
                Text("24 Hr") //24 Hr
                    .tag(24)
                Text("48 Hr") //48 Hr
                    .tag(48)
                Text("1 Wk") //168 Hr
                    .tag(168)
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 15)
        }
    }
}

struct GeneralPanel_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPanel()
    }
}
