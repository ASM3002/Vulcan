//
//  MainViewModel.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

import Foundation

enum DisplaySelection: String, CaseIterable {
    case general
    case fleet
    case fire
}

class MainViewModel: ObservableObject {
    @Published var panelDisplaySelection: DisplaySelection = .general
}
