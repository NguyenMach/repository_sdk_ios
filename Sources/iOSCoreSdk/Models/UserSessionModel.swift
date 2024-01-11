//
//  UserSessionModel.swift
//  
//
//  Created by Nguyen's Mac on 10/01/2024.
//

import UIKit
import SwiftyJSON

public class UserSessionModel: BaseModel {
    
    var accessToken: String?
    var refreshToken: String?
    var userId: String?
    var tokenType: String?

    var expiresIn: Double? {
        if let _accessToken = accessToken {
            let dataDecode = CommonUtils.decode(jwtToken:  _accessToken)
            let iat = (dataDecode["iat"] as? Double) ?? 0
            let exp = dataDecode["exp"] as? Double ?? 0
            return exp - iat
        }
        return nil
    }
    
    var tokenDate: Double? {
        if let _accessToken = accessToken {
            let dataDecode = CommonUtils.decode(jwtToken:  _accessToken)
            return dataDecode["exp"] as? Double
        }
        return nil
    }
    
    var hasValidToken: Bool {
        if let tokenExpiredDate = tokenDate {
            return tokenExpiredDate - Date().timeIntervalSince1970 > 0
        }
        return true
    }

    public init(accessToken: String? = nil, refreshToken: String? = nil, tokenType: String? = nil, userId: String? = nil) {
        super.init()
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.userId = userId
    }
    
    public required init(json: JSON) {
        super.init()
        accessToken = json["accessToken"].string
    }
    
    func toDictionary() -> [String: Any] {
        let result: [String: Any] = [
            "accessToken": E(accessToken),
            "expiresIn": expiresIn ?? 0,
            "refreshToken": E(refreshToken),
            "tokenDate": tokenDate ?? 0,
            "tokenType": E(tokenType),
            "userId": E(userId),
        ]
        return result
    }
}
