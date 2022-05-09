//
//  Service.swift
//  wises
//
//  Created by 이경민 on 2022/05/09.
//

import Foundation

struct Response:Codable{
    let result,respond:String?
}

struct Wise:Codable{
    var content:String
    var author:String
}

class ContentViewModel:ObservableObject{
    @Published var wise:Wise?
    let url = "https://api.qwer.pw/request/helpful_text?apikey=guest"
    init(){
        self.requestGet(url: url)
    }
    func requestGet(url:String){
        guard let url = URL(string: url) else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else{
                print(error.debugDescription)
                return
                
            }
            guard let data = data else{
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode else{
                print(error.debugDescription)
                return
            }
            guard let output = try? JSONDecoder().decode([Response].self, from: data) else{
                return
            }
            DispatchQueue.main.async {
                self.wise = self.convertWise(output)
            }

        }
        .resume()
    }
    
    func convertWise(_ data:[Response])->Wise{
        let dataArray = data[1].respond!.split(separator: "-").map{String($0)}
        print(dataArray)
        if dataArray.count == 1{
            return Wise(content: dataArray[0].replacingOccurrences(of: ",", with: "."), author: "")
        }else{
            return Wise(content: dataArray[0].replacingOccurrences(of: ",", with: "."), author: dataArray[1])
        }

    }

}

