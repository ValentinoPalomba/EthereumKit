{<p align="center">
<img src="https://user-images.githubusercontent.com/12425729/40763856-5f14764a-64e1-11e8-8684-2f1c8497abd5.png" alt="EthereumKit" height="300px">
</p>

EthereumWalletKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

```swift
// BIP39: Generate seed and mnemonic sentence.

let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)

// BIP32: Key derivation and address generation

let wallet = try! Wallet(seed: seed, network: .main)

// Send some ether

let rawTransaction = RawTransaction(
ether: try! Converter.toWei(ether: "0.00001"), 
to: address, 
gasPrice: Converter.toWei(GWei: 10), 
gasLimit: 21000, 
nonce: 0
)

let tx = try! wallet.signTransaction(rawTransaction)
geth.sendRawTransaction(rawTransaction: tx) { result in 
// Do something...
}
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
