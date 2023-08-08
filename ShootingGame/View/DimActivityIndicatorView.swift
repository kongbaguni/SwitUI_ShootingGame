//
//  DimActivityIndicatorView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/08/08.
//

import SwiftUI
import ActivityIndicatorView

struct DimActivityIndicatorView: View {
    @Binding var isLoading:Bool
    let backgroundColor : Color
    let forgroundColor : Color
    var body: some View {
        if isLoading {
            GeometryReader { proxy in
                ZStack(alignment:.center) {
                    backgroundColor
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            ActivityIndicatorView(isVisible: $isLoading, type: .default())
                                .frame(width:50, height: 50)
                                .foregroundColor(forgroundColor)
                        }
                    }
                    
                }
            }.ignoresSafeArea()
        }
        else {
            EmptyView()
        }
    }
}

struct DimActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("loading")
            DimActivityIndicatorView(
                isLoading: .constant(true),
                backgroundColor: .black.opacity(0.9),
                forgroundColor: .white
            )
        }
    }
}
