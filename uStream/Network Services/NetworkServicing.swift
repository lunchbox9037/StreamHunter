//
//  NetworkServicing.swift
//  uStream
//
//  Created by stanley phillips on 4/10/21.
//

import Foundation

enum NetError: Error {
    case badURL
    case badRequest(Error)
    case couldNotUnwrap
}

protocol NetworkServicing {
    typealias DataCompletion = (Result<Data, NetError>) -> Void
    func perform(urlRequest: URLRequest, completion: @escaping DataCompletion)
}

extension NetworkServicing {
    func perform(urlRequest: URLRequest, completion: @escaping DataCompletion) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)\nFunction: \(#function)\nDescription: \(error.localizedDescription)")
                return completion(.failure(.badRequest(error)))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print("RESPONSE CODE: \(response.statusCode)")
//            }
            
            guard let data = data else {
                completion(.failure(.couldNotUnwrap))
                return
            }
            
            DispatchQueue.main.async { completion(.success(data)) }
        }.resume()
    }
}

extension Data {
    func decode<T: Decodable>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        do {
            let object = try decoder.decode(T.self, from: self)
            return object
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
        return nil
    }
}
