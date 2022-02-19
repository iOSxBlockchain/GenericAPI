//
//  ViewController.swift
//  GenericAPI
//
//  Created by Angshuman Das on 30/11/1400 AP.
//

import UIKit
import Foundation

struct User: Codable {
    let name: String
    let email: String
}

class ViewController: UIViewController {
    
    
    // can use this instead of var user: [User] = []
    var models:[Codable] = []
    
    struct  Constants {
        static let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchAPI()
    }
    
    
    func fetchAPI() {
        URLSession.shared.request(url: Constants.url, expecting: [User].self) { result in
            switch result {
            case .success(let user):
                print(user[0].name)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


extension URLSession {
    enum CustomErrors: Error{
        case invalidURL
        case invalidData
    }
    
    func request<T: Codable>(url: URL?,expecting: T.Type,completion: @escaping(Result<T,Error>) -> Void){
        guard let url = url else {
            completion(.failure(CustomErrors.invalidURL))
            return
        }
        
        let myTask = self.dataTask(with: url) { data, _, err in
            guard let data = data else {
                if let error = err {
                    completion(.failure(error))
                }else {
                    completion(.failure(CustomErrors.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }catch {
                completion(.failure(error))
            }
        }
        
        myTask.resume()
    }
}

