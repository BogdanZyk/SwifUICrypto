//
//  CoinImageServices.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 20.04.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageServices{
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
       getCounImage()
    }
//https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579
    private func getCounImage(){
        guard let url = URL(string: coin.image) else {return}
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnImage) in
                self?.image = returnImage
                self?.imageSubscription?.cancel()
            })
    }
}
