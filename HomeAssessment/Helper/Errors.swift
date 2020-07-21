//
//  Errors.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation

extension NSError {
    func cnDescription() -> String {
        switch code {
        case 7070:
            return "用户名或密码错误"
        case 8080:
            return "没有 Data"
        case 9090:
            return "No Response"
        case -1004:
            return "无法连接到服务器"
        default:
            return ""
        }
    }
}
