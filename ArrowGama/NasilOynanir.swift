//
//  NasilOynanir.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 2.08.2025.
//

import SwiftUI
import StoreKit
import Combine

struct OynanisMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appUserData: UserData
    
    var body: some View {
        HStack{
            Text("  ")
                .font(.caption)
            Button(action: {presentationMode.wrappedValue.dismiss()}){
                Image(systemName: "chevron.left")
                Text("Geri")
                    .font(.caption)
            }
            Spacer()
        }
        Spacer()
        Text("Nasıl Oynanır?")
            .font(.title)
        Text("Bu oyunun amacı okları doğru zamanlama ile hedefe fırlatarak puan kazanmaktır. Ekrana tıkladığınız anda eğer 0.5 saniye önce tekrar tıklamadıysanız ok yaydan fırlayacak ve hedefe doğru yol kat edecektir. Eğer oklar birbirlerine değerse can kaybedersiniz. Ama eğer art arda 5 kere hedefe oku tutturursanız 1 can kazanırsınız. Oyunda bazı kontrol noktaları vardır bu noktalar size avantajlar sağlar: 15 puan noktası +3 can, 30 puan noktası +10 can, 40 puan ise +5 can ve tüm okların silinmesini sağlar. Canınız bittiğinde oyun biter. Puanınızın iki katı kadar para kazanırsınız. Bu puanları biriktirerek oklarınız görünümlerini mağazanın kostümler kategorisinden değiştirebilirsiniz.")
            .font(.headline)
            .padding()
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
        HStack{
            Spacer()
            Text(">Yusuf Erdem Ongun      ")
                .font(.title2)
            
        }
        Spacer()
        Spacer()
    }
}
