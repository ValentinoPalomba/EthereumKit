//
//  WalletError.swift
//  EthereumKit
//
//  Created by Valentino Palomba on 23/08/21.
//

import Foundation

public enum WalletError: Error {
    case accountDoesNotExist
    case invalidPath
    case invalidKey
    case invalidMnemonics
    case invalidAddress
    case malformedKeystore
    case networkFailure
    case conversionFailure
    case notEnoughBalance
    case contractFailure
    case unexpectedResult
}
