//
//  NetworkManager.swift
//  RandomUserCollectionView
//
//  Created by Reek i on 05.07.2023.
//

import UIKit

protocol NetworkManagerDelegateProtocol: AnyObject {
    func showAlert()
}

class NetworkManager {
    var imageCache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    weak var delegate: NetworkManagerDelegateProtocol?
    
    private init() {}
    
    func getUsers(numberOfUsers: Int, _ completion: @escaping (UserResponse) -> ()) {
        guard let url = URL(string: "https://randomuser.me/api/?results=\(numberOfUsers)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Error without description")
                DispatchQueue.main.async {
                    self.delegate?.showAlert()
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func getUserImage(from stringURL: String, _ completion: @escaping (UIImage) -> ()) {
        if let cachedImage = imageCache.object(forKey: stringURL as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        } else {
            guard let url = URL(string: stringURL) else { return }
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    print(error?.localizedDescription ?? "Error without description")
                    DispatchQueue.main.async {
                        self.delegate?.showAlert()
                    }
                    return
                }
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: stringURL as NSString)
                DispatchQueue.main.async {
                    completion(image)                    
                }
            }.resume()
        }
    }
}
