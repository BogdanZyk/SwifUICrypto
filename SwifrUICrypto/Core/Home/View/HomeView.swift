//
//  HomeView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView(close: $showPortfolioView)
                        .environmentObject(vm)
                }
            VStack{
                homeHeader
                HomeStatView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitle
                if !showPortfolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(isActive: $showDetailView, destination: {
            DetailLoadingView(coin: $selectedCoin)
        }, label: {
            EmptyView()
        }))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}


extension HomeView{
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins) {coin in
                CounsRowView(coin: coin, showHoldingsColums: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View{
        List{
            ForEach(vm.portfolioCoins) {coin in
                CounsRowView(coin: coin, showHoldingsColums: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitle: some View{
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .rotationEffect(Angle(degrees: vm.sortOption == .rankReversed ? 180 : 0))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rankReversed ? .rank : .rankReversed
                }
            }
            
            Spacer()
            if showPortfolio{
                HStack(spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdingsReversed ? 180 : 0))
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdingsReversed ? .holdings : .holdingsReversed
                    }
                }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .rotationEffect(Angle(degrees: vm.sortOption == .priceRewersed ? 180 : 0))
            }
            .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .priceRewersed ? .price : .priceRewersed
                }
            }
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isReloading ? 300 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
