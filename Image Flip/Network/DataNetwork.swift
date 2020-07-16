//
//  DataNetwork.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import Foundation
import Moya

enum DataNetwork {
    case getMeme
}

extension DataNetwork : TargetType {
    var baseURL: URL {
        return URL(string: Base().baseUrl())!
    }
    
    var path: String {
        switch self {
        case .getMeme:
            return "get_memes"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var httpHeaders: [String: String] = [:]
        httpHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        return httpHeaders

    }
        
}


private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
