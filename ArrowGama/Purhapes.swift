//
//  Purhapes.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 28.07.2025.
//

import SwiftUI
import StoreKit


struct ContenView: View {
    @ObservedObject var storeKit = StorekitManager()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack{
            Button(action: {presentationMode.wrappedValue.dismiss()}){
                Image(systemName: "chevron.left")
                Text("Geri")
                    .font(.caption)
            }
            Spacer()
        }
        
        .padding()
        
        TabView{
            Tab("Satın Alımlar", systemImage: "wallet.bifold.fill"){
                Text("Satın Alımlar")
                    .font(.title)
            
                VStack(alignment: .leading){
                    ProductView(id: storeKit.productIds[0], prefersPromotionalIcon: true)
                        .productViewStyle(.automatic)
                    ProductView(id: storeKit.productIds[1], prefersPromotionalIcon: true)
                        .productViewStyle(.automatic)
                        
                }
            }
            Tab("Eski Satın Alımlar",systemImage: "clock.badge.fill"){
                Text("Eski Satın Alımlar")
                    .font(.title)
                List{
                    ForEach(storeKit.purhapseproducts, id: \.self){product in
                        Text(product.displayName + " - " + product.displayPrice)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}

#Preview {
    ContenView()
}
