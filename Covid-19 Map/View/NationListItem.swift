//
//  NationListItem.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 16/06/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI

struct NationListItem: View {
    
    var nation: Nation
    
    var body: some View {
        HStack{
            Image(nation.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(nation.name)
                    .fontWeight(.bold)
                Text("Confirmed cases: \(nation.confirmedCases)")
            }
        }.padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
    
}

struct NationListItem_Previews: PreviewProvider {
    static var previews: some View {
        NationListItem(nation: Nation(name: "Italy", confirmedCases: "0", confirmedDeath: "0", image: "italy"))
    }
}
