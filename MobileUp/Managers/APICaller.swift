//
//  APICaller.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation
import Alamofire

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    private let apiURL = "https://api.vk.com/method"
    private let version = "5.131"
    
    private func createRequest(
        url: String,
        method: HTTPMethod,
        parameters: [String: String] = [:],
        completion: @escaping (Result<DataRequest,AuthManagerError>) -> Void) {
        AuthManager.shared.withValidToken { result in
            switch result {
            case .success(let accessToken):
                let request = AF.request(
                    url + "&access_token=\(accessToken)&v=\(self.version)",
                    method: method,
                    parameters: parameters,
                    encoder: .urlEncodedForm)
                completion(.success(request))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPhotos(
        ownerID: String = "-128666765",
        albumID: String = "266276915",
        completion: @escaping (Result<PhotosResponseModel, Error>) -> Void) {
        let url = apiURL + "/photos.get?owner_id=\(ownerID)&album_id=\(albumID)"
        createRequest(url: url, method: .get) { result in
            switch result {
            case .success(let request):
                request.responseDecodable(of: PhotosResponseModel.self) { response in
                    switch response.result {
                    case .success(let responseModel):
                        completion(.success(responseModel))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
