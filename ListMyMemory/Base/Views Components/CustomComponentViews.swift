//
//  CustomComponentViews.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
import SwiftUI

struct CustomLabel: View{
    var text : LocalizedStringKey
    var font : Font
    var foregroundColor : Color

    init(text: LocalizedStringKey, font: Font, foregroundColor: Color){
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
    }

    var body: some View{
        Text(text)
            .font(font)
            .foregroundColor(foregroundColor)
    }
}

struct CustomLabelString: View{
    var text : String
    var font : Font
    var foregroundColor : Color

    init(text: String, font: Font, foregroundColor: Color){
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
    }

    var body: some View{
        Text(text)
            .font(font)
            .foregroundColor(foregroundColor)
    }
}


struct CustomCapsule: View {
    var color: Color
    var width: CGFloat
    var height: CGFloat
    
    init(color: Color, width: CGFloat, height: CGFloat) {
        self.color = color
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: width, height: height)
    }
}

struct CustomSfSymbol : View{
    let image : String
    var imageColor : Color? = nil
    var rotationDegree : CGFloat? = nil
    init(inputImage:String,color:Color? = nil, rotationDegree: CGFloat? = nil) {
        self.image = inputImage
        self.imageColor = color
        self.rotationDegree = rotationDegree
    }
    var body: some View {
        if imageColor != nil && rotationDegree != nil{
            Image(systemName:self.image).renderingMode(.template).foregroundColor(imageColor).rotationEffect(.degrees(rotationDegree ?? 0)).scaledToFit()
        }else if rotationDegree != nil{
            Image(systemName:self.image).rotationEffect(.degrees(rotationDegree ?? 0)).scaledToFit()
        }else if imageColor != nil{
            Image(systemName:self.image).renderingMode(.template).foregroundColor(imageColor).scaledToFit()
        }else{
            Image(systemName:self.image).aspectRatio(contentMode: .fit)
        }
    }
}

struct RenderingCustomImage: View {
    let image : String
    let width : CGFloat
    let height: CGFloat
    let foregroundColor: Color
    init(inputImage:String, width: CGFloat, height: CGFloat, foregroundColor: Color) {
        self.image = inputImage
        self.width = width
        self.height = height
        self.foregroundColor = foregroundColor
    }
    var body: some View {
        Image(self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(foregroundColor)
            .frame(width: width, height: height)
    }
}

enum RotationDegree: CGFloat {
    case normal = 0
    case tiltRight = 90
    case tiltLeft = -90
    case upsideDown = 180
}

struct CustomImage: View {
    let image : String
    let width : CGFloat
    let height: CGFloat
    var rotationDegree: RotationDegree? = .normal
    
    init(inputImage:String, width: CGFloat, height: CGFloat, rotationDegree: RotationDegree? = .normal) {
        self.image = inputImage
        self.width = width
        self.height = height
        self.rotationDegree = rotationDegree
    }
    var body: some View {
        if rotationDegree != .normal {
            Image(self.image)
                .resizable()
                .rotationEffect(.degrees(Double(rotationDegree?.rawValue ?? 0)))
                .frame(width: width, height: height)
        } else {
            Image(self.image)
                .resizable()
                .frame(width: width, height: height)
        }
    }
}

struct CustomImageViewResizable : View{
    let image : String
    var imageColor : Color? = nil
    var rotationDegree : CGFloat? = nil
    init(inputImage:String,color:Color? = nil, rotationDegree: CGFloat? = nil) {
        self.image = inputImage
        self.imageColor = color
        self.rotationDegree = rotationDegree
    }
    var body: some View {
        if imageColor != nil && rotationDegree != nil{
            Image(self.image).resizable().renderingMode(.template).foregroundColor(imageColor).rotationEffect(.degrees(rotationDegree ?? 0)).scaledToFit()
        }else if rotationDegree != nil{
            Image(self.image).resizable().rotationEffect(.degrees(rotationDegree ?? 0)).scaledToFit()
        }else if imageColor != nil{
            Image(self.image).resizable().renderingMode(.template).foregroundColor(imageColor).scaledToFit()
        }else{
            Image(self.image).resizable().scaledToFit()
        }
    }
}
