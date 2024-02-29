
import Foundation
import Moya

enum AuthenticationTargetType {
    case refreshAccessToken
}


extension AuthenticationTargetType: TargetType {
    var baseURL: URL {
        return CoreSdkConfig.shared.environment?.baseURL ?? URL(string: "")!
    }

    var path: String {
        switch self {
        case .refreshAccessToken:
            return "/mobile/client/refresh-access-token"
        }
    }

    var method: Moya.Method {
        switch self {
        case .refreshAccessToken:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .refreshAccessToken:
            params["refreshToken"] = CacheService.currentSession?.refreshToken ?? ""
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    }

    var headers: [String : String]? {
        var headers = ["Authorization": "Bearer \(CacheService.currentSession?.accessToken ?? "")"]
        headers["Content-Type"] = "application/json"
        return headers
    }
}
