//
//  SearchBar.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 03/03/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    @Binding var txtSearched: String
    func makeCoordinator() -> SearchBar.Coordinator {
        return SearchBar.Coordinator.init(parentViewClass: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchView = UISearchBar()
        searchView.barStyle = .default
        searchView.autocapitalizationType = .none
        searchView.placeholder = "Country name..."
        searchView.delegate = context.coordinator
        return searchView
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parentView: SearchBar!
        
        init(parentViewClass: SearchBar) {
            parentView = parentViewClass
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parentView.txtSearched = searchText
        }
    }
}
