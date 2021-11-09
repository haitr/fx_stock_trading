//
//  API.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/04.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import Moya

private func stringToData(string: String) -> Data {
    return string.data(using: .utf8)!
}

private func escaped(string: String) -> String {
    return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}

enum API {
    case loginWithId(id: String, password: String)
    case monitoring
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "http://www.cy2code.com")!
    }
    
    var path: String {
        switch self {
        case .loginWithId:
            return "/login"
        case .monitoring:
            return "/monitor"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .loginWithId:
            return .post
        case .monitoring:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return stringToData(string: "")
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
