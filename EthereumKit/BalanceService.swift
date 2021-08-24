//
//  BalanceService.swift
//  EthereumKit
//
//  Created by Valentino Palomba on 23/08/21.
//

import Foundation
import web3swift
import BigInt
public protocol BalanceService {
    func etherBalanceSync() throws -> String
    func etherBalance(completion: @escaping (String?) -> ())
    func tokenBalanceSync(contractAddress: String) throws -> String
    func tokenBalance(contractAddress: String, completion: @escaping (String?) -> ())
}

extension EtherCoordinator: BalanceService {
    public func etherBalanceSync() throws -> String {
        guard let address = address else { throw WalletError.accountDoesNotExist }
        guard let ethereumAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }
        
        guard let balanceWei = try? web3Instance.eth.getBalance(address: ethereumAddress) else {
            throw WalletError.networkFailure
        }
        
        guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceWei, toUnits: Web3.Utils.Units.eth, decimals: 8, decimalSeparator: ".") else { throw WalletError.conversionFailure }
        
        return balanceInEtherUnitStr
    }
    
    public func etherBalance(completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let balance = try? self.etherBalanceSync()
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }
    
    public func tokenBalanceSync(contractAddress: String) throws -> String {
        let contractEthereumAddress = EthereumAddress(contractAddress)
        guard let contract = web3Instance.contract(Web3.Utils.erc20ABI, at: contractEthereumAddress) else {
            throw WalletError.invalidAddress
        }
        guard let address = address else { throw WalletError.accountDoesNotExist }
        let parameters = [address as AnyObject]
        let contractMethod = contract.method("balanceOf", parameters: parameters, extraData: Data(), transactionOptions: transactionOptions)
        guard let balanceInfo = try? contractMethod?.call(transactionOptions: nil), let balance = balanceInfo["0"] as? BigUInt else {
            throw WalletError.networkFailure
        }
        return "\(balance)"
    }
    
    public func tokenBalance(contractAddress: String, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let balance = try? self.tokenBalanceSync(contractAddress: contractAddress)
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }
    
    
}
