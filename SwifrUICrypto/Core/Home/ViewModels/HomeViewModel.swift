//
//  HomeViewModel.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//


import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    private let dataSevice = CounDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    func addSubscribers(){
        dataSevice.$allCoins
            .sink { [weak self] (retunCoins) in
                self?.allCoins = retunCoins
            }
            .store(in: &cancellables)
    }
}


