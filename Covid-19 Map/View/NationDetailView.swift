//
//  NationDetailView.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 02/03/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI

struct NationDetailView: View {
        
    var nation: Nation
    
    var body: some View {
        VStack {
            Spacer()
            Image(nation.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            Spacer()
            HStack{
                Spacer()
                Text("Country: ")
                    .font(.title)
                Text(nation.name)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            
            HStack{
                Spacer()
                Text("Confirmed cases: ")
                    .font(.title)
                Text(nation.confirmedCases)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            
            HStack{
                Spacer()
                Text("Confirmed death: ")
                    .font(.title)
                Text(nation.confirmedDeath.isEmpty ? "0" : nation.confirmedDeath)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            Spacer()
            Spacer()
        }
            .navigationBarTitle(nation.name)
            .lineLimit(nil)
    }
}

#if DEBUG
struct NationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NationDetailView(nation: Nation(name: "Italy", confirmedCases: "350", confirmedDeath: "0", image: "italy"))
    }
}
#endif
