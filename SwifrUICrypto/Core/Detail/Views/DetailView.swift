//
//  DetailView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import SwiftUI

struct DetailLoadingView: View{
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack{
            if let coin = coin{
               DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    private let spacing: CGFloat = 30
    var body: some View {
        
        ScrollView{
            VStack(spacing: 24){
                Text("")
                    .frame(height: 150)
                overViewTitle
                Divider()
                overviewGrid
                additionalTitle
                Divider()
                additionalGrid
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    
    }
}

extension DetailView{
    private var overViewTitle: some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalTitle: some View{
        Text("Addition Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) {stat in
                    StatisticView(stat: stat)
                }
            }
    }
    private var additionalGrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) {stat in
                    StatisticView(stat: stat)
                }
            }
    }
}
