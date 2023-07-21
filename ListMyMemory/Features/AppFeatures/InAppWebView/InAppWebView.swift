//
//  InAppWebView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import SwiftUI
import WebKit

enum WebviewFlow {
    case tunosYcitas
    case chatLinea
    case protectionUser
    case popularLinea
}
struct InAppWebView: View {
    var selectedFlow : WebviewFlow
    var body: some View {
        WebViewTitleView(title:self.getTitleUrl(selectedFlow: selectedFlow).title) {
            WebView(url: URL(string: self.getTitleUrl(selectedFlow: selectedFlow).url)!)
        }
    }
    
    func getTitleUrl(selectedFlow:WebviewFlow) -> (title:String,url:String){
        if selectedFlow == .tunosYcitas{
            return ("Turnos y citas",NSLocalizedString("label.url.shiftManagement", comment: ""))
        }else if selectedFlow == .chatLinea{
            return ("Chat en línea",NSLocalizedString("popular.webchat.url", comment: ""))
        }else if selectedFlow == .protectionUser{
            return ("Protección al usuario",NSLocalizedString("user.protection.url", comment: ""))
        }else if selectedFlow == .popularLinea{
            return ("Popular en línea",NSLocalizedString("contact.web.url", comment: ""))
        }
       return ("","")
    }
}

struct InAppWebView_Previews: PreviewProvider {
    static var previews: some View {
        InAppWebView(selectedFlow: .chatLinea)
    }
}
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
struct WebViewTitleView<Content: View>: View{
    let content: () -> Content
    var title : String
    init(title:String,@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.title =  title
    }

    var body: some View {
        
        VStack{
            VStack(spacing:0){
                HStack{
                    CustomImageViewResizable(inputImage: ImageConstants.Exit, color: Color.orange).frame(width: 24, height: 14).onTapGesture {
                        ScreenNavigation().redirectToScreen(nextView: HomeView(active: .home))
                    }
                    Spacer()
                    Text(self.title).frame(maxWidth:.infinity, alignment: .center).offset(x: -20, y: 0).font(AppFonts.InterRegular16).foregroundColor(AppColors.Blue)
                }.frame(maxWidth:.infinity,maxHeight: 40,alignment: .top)
                    .padding([.leading,.trailing,.top],20)
                    .background(Color.white)
                Divider()
            }
            VStack{
                content()
            }.frame(maxWidth:.infinity,maxHeight: .infinity)
        }
    }
}
