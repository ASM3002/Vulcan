//
//  NavigationBarView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/19/23.
//

import SwiftUI

struct NavigationBarView: View {
    @EnvironmentObject var mainVM: MainViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            //QuickWeatherInfo()
            Capsule()
                .frame(width: 3, height: 30)
                .foregroundColor(.theme.white)
            QuickFireInfo()
        }
        .padding(5)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
