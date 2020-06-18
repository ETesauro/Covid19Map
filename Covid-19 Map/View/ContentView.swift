//
//  ContentView.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 02/03/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //Array di nazioni
    @State var nazioni: [Nation] = [Nation]()
    
    //Stringa che mostra l'orario dell'ultimo aggiornamento
    @State var lastUpdate: String = ""
    
    //Stringa che mostra il numero TOTALE di contagi nel MONDO
    @State var totalCount: Int = 0
    
    //Serve per evitare che l'app ricarichi sempre la lista ogni volta che si torna nella pagina principale
    @State var loaded: Bool = false
    
    //Serve per mettere/togliere la pagina di caricamento
    @State var isLoading: Bool = true
    
    //Serve per filtrare i Paesi
    @State var textSearched: String = ""
    
    //Serve per mostrare e nascondere l'alert di informaizoni
    @State var showingAlert: Bool = false
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: $isLoading) {
                VStack(alignment: .leading){
                    
                    Text("Last update: \(self.lastUpdate)")
                        .font(.footnote)
                        .padding(.leading)
                    
                    Text("Total number of infections: \(self.totalCount)")
                        .font(.footnote)
                        .padding(.leading)
                    
                    SearchBar(txtSearched: self.$textSearched)
                    
                    List(self.nazioni.filter{
                        self.textSearched == "" ? true : $0.name.localizedCaseInsensitiveContains(self.textSearched)
                    }) { nazione in
                        NavigationLink(destination: NationDetailView(nation: nazione)) {
//                            HStack {
//                                Image(nazione.image)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 40, height: 40)
//                                VStack(alignment: .leading) {
//                                    Text(nazione.name)
//                                        .fontWeight(.bold)
//                                    Text("Confirmed cases: \(nazione.confirmedCases)")
//                                }
//                            }.padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            NationListItem(nation: nazione)
                        }.navigationBarTitle("Countries")
                            .navigationBarItems(leading:
                                Image(systemName: "arrow.clockwise.circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.isLoading = true
                                        self.loadData()
                                },
                                                trailing:
                                Button(action: {
                                    //Apri alert
                                    self.showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .font(.title)
                                        .foregroundColor(Color.blue)
                                }
                                .alert(isPresented: self.$showingAlert) {
                                    Alert(title: Text("About Covid-19 Map"),
                                          message: Text("\nDeveloper: Emmanuel Tesauro\n\n Data provider: channelnewsasia.com\n\n Covid-19 Map has been developed for information purposes only."),
                                          dismissButton: .default(Text("Close"))
                                    )
                            })
                    }.onAppear {
                        if !self.loaded {
                            self.loadData()
                            self.loaded = true
                        }
                    }
                }
            }
        }
    }
    
    //Carico i dati
    func loadData() {
        guard let url = URL(string: "https://spreadsheets.google.com/feeds/list/1lwnfa-GlNRykWBL5y7tWpLxDoCfs8BvzWxFjeOZ1YJk/1/public/values?alt=json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: .allowFragments)
                
                guard let response = jsonResponse as? Dictionary<String, Any> else {return}
                
                guard let jsonFeed = response["feed"] as? Dictionary<String, Any> else {return}
                
                guard let updatedDict = jsonFeed["updated"] as? Dictionary<String, Any> else { return }
                
                guard let updated = updatedDict as? NSDictionary else { return }
                
                guard let updatedStr = updated.value(forKey: "$t") as? String else { return }
                
                let dataArray = updatedStr.split(separator: "T")
                let day = dataArray[0]
                let hour = dataArray[1].split(separator: ".")[0]
                
                self.lastUpdate = "\(day) \(hour)"
                
                guard let array = jsonFeed["entry"] as? NSArray else {return}
                
                self.nazioni = []
                
                DispatchQueue.main.async {
                    for x in array {
                        if let dict = x as? NSDictionary {
                            //Prendi title -> $st
                            guard let nation = dict.value(forKey: "title")! as? Dictionary<String, Any> else {return}
                            
                            //Prendi gsx$confirmedcases -> $st
                            guard let confirmedCases = dict.value(forKey: "gsx$confirmedcases")! as? Dictionary<String, Any> else {return}
                            
                            //Prendi gsx$reporteddeaths -> $st
                            guard let confirmedDeath = dict.value(forKey: "gsx$reporteddeaths")! as? Dictionary<String, Any> else {return}
                            
                            self.nazioni.append(Nation(name: nation["$t"]! as! String, confirmedCases: confirmedCases["$t"]! as! String, confirmedDeath: confirmedDeath["$t"]! as! String, image: "\((nation["$t"]! as! String).lowercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: ""))"))
                            
                            guard let decimalValue = Int((confirmedCases["$t"] as! String).replacingOccurrences(of: ",", with: "")) else {
                                print("error")
                                return
                            }
                            self.totalCount += decimalValue
                        }
                    }
                    self.isLoading = false
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }.resume()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(nazioni: [
            Nation(name: "Italia", confirmedCases: "13", confirmedDeath: "15", image: "italy")
        ])
    }
}
#endif
