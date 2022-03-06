//
//  CustomErrors.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/6/22.
//

import Foundation

enum CustomError: Error {
    // Throw when an invalid password is entered
    case invalidPassword

    // Throw when an expected resource is not found
    case notFound
    
    // Throw when failed to set user defaults
    case userDefaultsNotSet

    // Throw in all other cases
    case unexpected(code: Int)
}
