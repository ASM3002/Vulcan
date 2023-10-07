//
//  PanelView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import SwiftUI


struct PanelView: View {
    @EnvironmentObject var mainVM: MainViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("Name")
                .resizable()
                .scaledToFit()
                .frame(height: 75)
            
            Picker("", selection: $mainVM.panelDisplaySelection) {
                ForEach(DisplaySelection.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 15)
            //DISPLAYED FROM PICKER
            switch mainVM.panelDisplaySelection {
            case .general:
                GeneralPanel()
            case .fleet:
                FleetPanel()
            case .fire:
                FirePanel()
            }
            Spacer(minLength: 0.0)
            Text("Powered by NASA LANDSAT")
                .italic()
                .foregroundColor(.theme.white)
                .font(.headline)
        }
        .padding(.horizontal, 5)
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
