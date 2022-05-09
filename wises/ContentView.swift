//
//  ContentView.swift
//  wises
//
//  Created by 이경민 on 2022/05/09.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    
    @State var bgColor:Color
    @State var textColor:Color
    
    init(){
        let stringbg = UserDefaults.standard.string(forKey: "bgColor")
        self.bgColor = Color.init(hex:stringbg ?? "#000000")
        
        let stringTextColor = UserDefaults.standard.string(forKey: "textColor")
        self.textColor = Color.init(hex: stringTextColor ?? "#ffffff")
    }
    var body: some View {
        VStack{
            HStack{
                Text("오늘명언")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(textColor)
                Spacer()
                
                Button {
                    print(123)
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 25))
                        .foregroundColor(textColor)
                }
                
            }
            .padding(20)
            Spacer()
            
            HStack(alignment:.center){
                if contentViewModel.wise != nil{
                    Text(contentViewModel.wise!.content)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(textColor)
                }
                
                Spacer()
            }
            .padding()
            
            HStack{
                Spacer()
                if contentViewModel.wise != nil{
                    Text(contentViewModel.wise!.author)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                }
            }
            .padding()
            
            Spacer()
            
            ColorPicker(selection: $textColor, supportsOpacity: false) {
                Text("글자색 변경")
                    .foregroundColor(.white)
            }
            .onChange(of: textColor, perform: { newValue in
                guard newValue.toHex() != nil else{return}
                UserDefaults.standard.set(newValue.toHex()!, forKey: "textColor")
            })
            .padding()
            
            ColorPicker(selection: $bgColor, supportsOpacity: false) {
                Text("배경색 변경")
                    .foregroundColor(.white)
            }
            .onChange(of: bgColor, perform: { newValue in
                guard newValue.toHex() != nil else{return}
                UserDefaults.standard.set(newValue.toHex()!,forKey: "bgColor")
            })
            .padding()
        }
        .background(bgColor)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex:String){
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb:UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red:red, green: green, blue: blue)
    }
    
    func toHex() -> String? {
            let uic = UIColor(self)
            guard let components = uic.cgColor.components, components.count >= 3 else {
                return nil
            }
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)

            if components.count >= 4 {
                a = Float(components[3])
            }

            if a != Float(1.0) {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }
}
