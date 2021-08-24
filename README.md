<p align="center">
<img src="https://i.pinimg.com/originals/67/dd/e5/67dde5ca7606d1aef2a9b3b9e519d457.png" alt="EthereumKit" height="300px">
</p>

EthereumWalletKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

```swift
 // Check if you had ever added an Account, if not you will need to generate your account, this method also generate your mnemonich phrase and save your keystore locally
       // password will be encrypted and saved to the device and it will be required to access the wallet.
if !EtherCoordinator.shared.hasAccount {
 try? EtherCoordinator.shared.generateAccount(password: "ABCDEFG")
 //You can check your mnemonics using this variable, and show them to your user
 print(EtherCoordinator.shared.mnemonics)
} else {
  // password will be encrypted and saved to the device and it will be required to access the wallet.
  // Import an existing account from its private key and set its new password.
  let privateKey = try? EtherCoordinator.shared.privateKey(password: "ABCDEFG")
  guard let key = privateKey else { return }
  try? EtherCoordinator.shared.importAccount(privateKey: key, password: "ABCDEFG")
        
}
        
// Import an existing account from its private key and set its new password.
try? EtherCoordinator.shared.importAccount(privateKey: "1dcbc1d6e0a4587a3a9095984cf051a1bc6ed975f15380a0ac97f01c0c045062", password: "ABCDEFG")

// Get your ether address
print(EtherCoordinator.shared.address)


// Get balance of Ether
EtherCoordinator.shared.etherBalance { balance in
    print(balance)
}

// Get balance of a token
EtherCoordinator.shared.tokenBalance(contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07") { balance in
    print(balance)
}

// send Ether to an address.
EtherCoordinator.shared.sendEther(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", amount: "1.5", password: "ABCDEFG") { txHash in
    print(txHash)
}

// send a token to an address.
EtherCoordinator.shared.sendToken(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07", amount: "20", password: "ABCDEFG", decimal: 18) { txHash in
    print(txHash)
 }
        
// Note: password should be eqaul to the password of wallet created. Also you can put gasPrice as an extra parameter to set gas price for the transcation.

```
## Features

- Sign transaction
- Get account balance
- Import Account from other platforms
- Generate recovery prhease
- ERC20 token transfer


## Requirements

- Swift 4.0 or later
- iOS 9.0 or later

## Installation

- Insert `pod EthereumWalletKit"` to your podfile.
- Run `pod install`.

## Dependency


- [web3swift](https://github.com/skywinder/web3swift/tree/master): web3swift is an iOS toolbelt for interaction with the Ethereum network.

## Author

Valentino Palomba, valentinopalomba2@gmail.com


## License
EthereumKit is released under the [Apache License 2.0](LICENSE.md).
