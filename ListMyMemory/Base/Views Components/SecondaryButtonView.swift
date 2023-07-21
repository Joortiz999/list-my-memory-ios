//
//  SecondaryButtonView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import SwiftUI

struct SecondaryButtonView: View {
    typealias ActionHandler = () -> Void
    
    let title: LocalizedStringKey
    let image: String?
    let imageColor: Color?
    let background: Color
    let foreground: Color
    let border: Color
    let height: CGFloat
    let width: CGFloat
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 15
    
    internal init(title: LocalizedStringKey, image: String?,imageColor: Color?, background: Color = .orange, foreground: Color = .white, border: Color = .clear, height: CGFloat = 50, width: CGFloat = 200, handler: @escaping SecondaryButtonView.ActionHandler) {
        self.title = title
        self.image = image
        self.imageColor = imageColor
        self.background = background
        self.foreground = foreground
        self.border = border
        self.height = height
        self.width = width
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            HStack(spacing: 20){
                if image != "" && image != nil {
                    if title == "fitImage" {
                        CustomImageViewResizable(inputImage: image ?? "", color: imageColor).frame(width: height - 10, height: width - 10, alignment: .center)
                    } else {
                        CustomImageViewResizable(inputImage: image ?? "", color: imageColor).frame(width: 30, height: 30, alignment: .center)
                    }
                }
                if title != "" && title != "fitImage" {
                    Text(title)
                }
            }.padding(12)
                .frame(maxWidth: width, maxHeight: height)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.callout.bold())
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 3)
        )
    }
}

//struct SecondaryButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            SecondaryButtonView(title: "Secondary Filed Button", image: "" ) { }
//                .preview(with: "Secondary Filed Button View")
//
//            SecondaryButtonView(title: "Secondary Empty Button View", background: .clear, foreground: .orange, border: .orange) { }
//                .preview(with: "Secondary Empty Button View")
//        }
//    }
//}
