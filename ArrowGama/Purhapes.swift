//
//  Purhapes.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 28.07.2025.
//
//
//  Copyright 2025 Yusuf Erdem Ongun
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

import SwiftUI
import StoreKit
import Combine

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appUserData: UserData
    
    @StateObject var storeKit: StorekitManager
    
    let columns = [GridItem(.flexible()) , GridItem(.flexible())]
    init(appUserData: UserData) {
        self._storeKit = StateObject(wrappedValue: StorekitManager(userData: appUserData))
    }
    
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
            Tab("Kostümler", systemImage: "hat.cap.fill") {
                VStack(alignment: .leading) {
                    HStack{
                        Text("Kostümler")
                            .font(.title)
                            .padding(.horizontal)
                        Spacer()
                        Text("\(appUserData.para) 🟡")
                            .font(.title)
                            .padding(.horizontal)
                    }

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(appUserData.oklar, id: \.self) { (ok: String) in
                                let fiyat = appUserData.oklarınParaları[ok] ?? 0
                                KostumTile(
                                    ok: ok,
                                    fiyat: fiyat,
                                    appUserData: appUserData
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


struct KostumTile: View {
    let ok: String
    let fiyat: Int
    @ObservedObject var appUserData: UserData
    
    var sende: Bool {appUserData.sahipOlunanOklar.contains(ok)}
    

    var body: some View {
        var alinabilir: Bool { (appUserData.para >= fiyat) && sende == false}
        let fiyatText = "\(fiyat.formatted()) 🟡"
        let ad = yazilariBelirle(ok)
        
        VStack(spacing: 8) {
            Button(action: {sec(ok)}){
                Image(ok)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                Text(ad)
                    .font(.headline)
            }
            if sende {
                if(appUserData.secilenOk == ok){
                    Text("Seçili")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(fiyatText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                satinAl()
            } label: {
                Text(sende ? "Sende" : (alinabilir ? "Satın Al" : "Yetersiz"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!alinabilir)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    func satinAl() {
        if appUserData.para >= fiyat && appUserData.sahipOlunanOklar.contains(ok) == false {
            appUserData.para -= fiyat
            appUserData.sahipOlunanOklar.append(ok)
        }
        print(appUserData.sahipOlunanOklar)
    }
    func sec(_ ok:String){
        if sende{
            appUserData.secilenOk = ok
            print("seçildi")
        }
    }
}

func yazilariBelirle(_ ok: String) -> String {
    switch ok {
    case "ok1": return "Normal Ok"
    case "ok2": return "Buzlu Ok"
    case "ok3": return "Kürek"
    case "ok4": return "Kalem"
    case "ok5": return "Süpürge"
    case "ok6": return "Dondurma"
    default:    return "Bilinmeyen Ok"
    }
}
