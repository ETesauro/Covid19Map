//
//  AdView.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 03/03/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI
import Foundation
import GoogleMobileAds

struct AdView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<AdView>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeFluid)
        banner.adUnitID = "ca-app-pub-2275493261526130/2998688264"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: AdView.UIViewType, context: UIViewRepresentableContext<AdView>) {
        
    }
}

