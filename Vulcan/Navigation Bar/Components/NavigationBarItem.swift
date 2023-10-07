//
//  NavigationBarItem.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI

struct NavigationBarItem: View {
    var data: Double
    var decimals: Int
    var label: String
    var unit: String?
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(label): ")
                .font(.caption)
            Text("\(String(format: "%.\(decimals)f", data))")
                .font(.title3)
                .fontWeight(.semibold)
            Text(unit ?? "")
                .font(.caption)
        }
        .foregroundColor(.theme.darkGray)
        .padding(5)
        .frame(width: 90)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.theme.white)
        }
    }
}

struct NavigationBarItem_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
