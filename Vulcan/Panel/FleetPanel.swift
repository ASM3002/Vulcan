//
//  FleetPanel.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct FleetPanel: View {
    var body: some View {
        VStack(spacing: 25) {
            ForEach(0..<5, id: \.self) { d in
                HStack {
                    Text("Drone \(d)")
                    Spacer(minLength: 50)
                    Text(d % 2 == 0 ? "Enroute" : "Standby")
                }
            }
        }
        .padding(5)
    }
}

struct FleetPanel_Previews: PreviewProvider {
    static var previews: some View {
        FleetPanel()
    }
}
