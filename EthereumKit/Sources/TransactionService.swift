//
//  TransactionService.swift
//  EthereumKit
//
//  Created by Valentino Palomba on 23/08/21.
//

import Foundation
import web3swift
import BigInt
public protocol TransactionService {
    func sendEtherSync(to address: String, amount: String, password: String) throws -> String
    func sendEtherSync(to address: String, amount: String, password: String, gasPrice: String?) throws -> String
    func sendEther(to address: String, amount: String, password: String, completion: @escaping (String?) -> ())
    func sendEther(to address: String, amount: String, password: String, gasPrice : String?, completion: @escaping (String?) -> ())
    func sendTokenSync(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int) throws -> String
    func sendTokenSync(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int, gasPrice: String?) throws -> String
    func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal:Int, completion: @escaping (String?) -> ())
    func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal:Int, gasPrice: String?, completion: @escaping (String?) -> ())
}

extension EtherCoordinator: TransactionService {
    public func sendEtherSync(to address: String, amount: String, password: String) throws -> String {
        return try sendEtherSync(to: address, amount: amount, password: password, gasPrice: nil)
    }
    
    func sendEtherSync(to address: String, amount: String, password: String, gasPrice: String?) throws -> String {
        guard let toAddress = EthereumAddress(address) else {return ""}
        let keyStore = try loadKeystore()
        let etherBalance = try etherBalanceSync()
        
        guard let etherBalanceInDouble = Double(etherBalance) else { throw WalletError.conversionFailure }
        guard let amountInDouble = Double(amount) else { throw WalletError.conversionFailure }
        guard etherBalanceInDouble >= amountInDouble else { throw WalletError.notEnoughBalance }
        
        let keystoreManager = KeystoreManager([keyStore])
        web3Instance.addKeystoreManager(keystoreManager)
        
        if let gasPrice = gasPrice, let bigGasPrice = BigUInt(gasPrice) {
            transactionOptions.gasPrice = .manual(bigGasPrice)
        }
        transactionOptions.value = Web3.Utils.parseToBigUInt(amount, units: .eth)
        guard let contract = web3Instance.contract(Web3.Utils.coldWalletABI, at: toAddress) else {
            throw WalletError.contractFailure
        }
        contract.transactionOptions = transactionOptions
        
        guard let intermediateSend = contract.method() else { throw WalletError.contractFailure }
        guard let sendResult = try? intermediateSend.send(password: password) else { throw WalletError.networkFailure }
        
        return sendResult.hash
    }
    
    func sendEther(to address: String, amount: String, password: String, completion: @escaping (String?) -> ()) {
        sendEther(to: address, amount: amount, password: password, gasPrice: nil, completion: completion)
    }
    
    func sendEther(to address: String, amount: String, password: String, gasPrice: String?, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendEtherSync(to: address, amount: amount, password: password, gasPrice: gasPrice)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
    
    func sendTokenSync(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int) throws -> String {
        return try sendTokenSync(to: toAddress, contractAddress: contractAddress, amount: amount, password: password, decimal: decimal, gasPrice: nil)
    }
    
    func sendTokenSync(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int, gasPrice: String?) throws -> String {
        guard let tokenAddress = EthereumAddress(contractAddress) else { throw WalletError.invalidAddress }
        guard let fromAddress = address else { throw WalletError.accountDoesNotExist }
        guard let fromEthereumAddress = EthereumAddress(fromAddress) else { throw WalletError.invalidAddress }
        guard let toEthereumAddress = EthereumAddress(toAddress) else { throw WalletError.invalidAddress }
        let keystore = try loadKeystore()
        let keystoreManager = KeystoreManager([keystore])
        web3Instance.addKeystoreManager(keystoreManager)
        
        var options = transactionOptions
        options.from = fromEthereumAddress
        
        if let gasPrice = gasPrice, let bigGasPrice = BigUInt(gasPrice) {
            options.gasPrice = .manual(bigGasPrice)
        }
        options.gasLimit = .automatic
        
        guard let tokenAmount = Web3.Utils.parseToBigUInt(amount, decimals: decimal) else { throw WalletError.conversionFailure }
        let parameters = [toEthereumAddress, tokenAmount] as [AnyObject]
        guard let contract = web3Instance.contract(Web3.Utils.erc20ABI, at: tokenAddress, abiVersion: 2) else { throw WalletError.contractFailure }
        guard let contractMethod = contract.method("transfer", parameters: parameters, extraData: Data(), transactionOptions: transactionOptions) else { throw WalletError.contractFailure }
        
        var newTransactionOptions = transactionOptions
        newTransactionOptions.callOnBlock = .latest
        
        guard let contractCall = try? contractMethod.send(password: password, transactionOptions: newTransactionOptions) else {
            throw WalletError.networkFailure
        }
        
        return contractCall.hash
    }
    
    func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int, completion: @escaping (String?) -> ()) {
        sendToken(to: toAddress, contractAddress: contractAddress, amount: amount, password: password, decimal: decimal, gasPrice: nil, completion: completion)
    }
    
    func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int, gasPrice: String?, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendTokenSync(to: toAddress, contractAddress: contractAddress, amount: amount, password: password, decimal: decimal, gasPrice: gasPrice)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
    
    
}
