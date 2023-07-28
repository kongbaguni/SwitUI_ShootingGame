//
//  RoundedButtonView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/28.
//

import SwiftUI

struct RoundedButtonView: View {
    let image:Image?
    let text:Text
    let action:()->Void
    var body: some View {
        Button {
            action()
        } label : {
            HStack {
                if let img = image {
                    img.resizable()
                        .scaledToFit()
                        .frame(height: 25)
                }
                text.font(.system(size: 25).bold())
            }
        }
        .padding(10)
        .background(Color.backGround3)
        .cornerRadius(10)
        .shadow(radius: 10,x: 5, y:5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.textColorStrong, lineWidth:2)
        )
        .padding(10)
    }
}

struct RoundedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonView(image:Image(systemName: "circle"),  text: Text("test")) {
        }
        RoundedButtonView(image:nil,  text: Text("test")) {
            
        }

    }
}
