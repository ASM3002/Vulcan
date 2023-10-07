//
//  MainViewModel.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import Foundation

enum DisplaySelection: String, CaseIterable {
    case fire
    case alert
}

class MainViewModel: ObservableObject {
    @Published var panelDisplaySelection: DisplaySelection = .fire
}
