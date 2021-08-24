//
//  Utilities.swift
//  EthereumKit
//
//  Created by Valentino Palomba on 31/07/21.
//

import Foundation
import web3swift
 
public class EtherCoordinator {
    static public let shared = EtherCoordinator()
    
    public var web3Instance : web3 {
        return Web3.InfuraMainnetWeb3()
    }
    
    let keystoreDirectoryName = "/keystore"
    let keystoreFileName = "/key.json"
    let mnemonicsKeystoreKey = "mnemonicsKeystoreKey"
    let defaultGasLimitForTokenTransfer = 100000
    
    public var transactionOptions: TransactionOptions = .defaultOptions
    
    public var keystoreCache: EthereumKeystoreV3?
}

enum defaultKey : String {
    case wallet = "Wallet"
    case mnemonics = "Mnemonics"
}

let defaults = UserDefaults.standard

