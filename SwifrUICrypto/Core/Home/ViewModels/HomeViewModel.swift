//
//  HomeViewModel.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published  var statistics: [StatisticModel] = []
    private let coinDataService = CounDataService()
    private let marketDataService = MarketDataServices()
    private let portfolioCoinData = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
   private func addSubscribers(){
        //search coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] (returnCoin) in
                self?.allCoins = returnCoin
            }
            .store(in: &cancellables)
        //update portfolioCoins
        $allCoins
            .combineLatest(portfolioCoinData.$saveEntities)
            .map(mapAllCounsToPortfolioCoins)
            .sink { [weak self] (returnCoins) in
                self?.portfolioCoins = returnCoins
            }
            .store(in: &cancellables)
        
        //update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
            }
            .store(in: &cancellables)
       
       
   }
    
    public func updatePortfolio(coin: CoinModel, amoun: Double){
        portfolioCoinData.updatePortfolio(coin: coin, amoun: amoun)
    }
    public func reloadData(){
        coinDataService.getCoins()
        marketDataService.getData()
    }
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapAllCounsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinid == coin.id}) else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else{
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h volume", value: data.volume)
        let btcDominans = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previewsValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let persentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previewsValue = currentValue / (1 + persentChange)
                return previewsValue
            }
            .reduce(0, +)
        let percentageChange = (portfolioValue - previewsValue) / previewsValue
        let portfolio = StatisticModel(
            title: "Portfolio value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,volume, btcDominans, portfolio
        ])
        return stats
    }
}


