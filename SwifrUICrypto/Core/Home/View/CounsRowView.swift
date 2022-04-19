//
//  CounsRowView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import SwiftUI

struct CounsRowView: View {
    let coun: CoinModel
    let showHoldingsColums: Bool
    var body: some View {
        HStack(spacing: 0){
            letfColum
            Spacer()
            if showHoldingsColums{
                centerColum
            }
            rightColum
        }
        .font(.subheadline)
    }
}

struct CounsRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CounsRowView(coun: dev.coin, showHoldingsColums: true)
                .previewLayout(.sizeThatFits)
            CounsRowView(coun: dev.coin, showHoldingsColums: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CounsRowView{
    private var letfColum: some View{
        HStack(spacing: 0){
            Text("\(coun.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coun.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var centerColum: some View{
        VStack(alignment: .trailing){
            Text(coun.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text("\((coun.currentHoldings ?? 0).asNumberString())")
        }
        .foregroundColor(Color.theme.accent)
    }
    private var rightColum: some View{
        VStack(alignment: .trailing){
            Text(coun.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coun.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor((coun.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
