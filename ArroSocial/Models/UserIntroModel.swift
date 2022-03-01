//
//  UserIntroModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import Foundation
import SwiftUI

// new user walkthrough

struct NewUserPages: Identifiable {
    var id = UUID().uuidString
    var title: String
    var color: Color
}


var pages: [NewUserPages] = [
    NewUserPages(title: "username", color: Color(AppColors.blue)),
    NewUserPages(title: "name", color: Color(AppColors.lightBlue)),
    NewUserPages(title: "profile picture", color: Color(AppColors.purple)),
]
