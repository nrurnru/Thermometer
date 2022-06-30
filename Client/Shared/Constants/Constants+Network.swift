//
//  Constants+Network.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

import Foundation

extension Constants {
    struct Network {
        static let baseURL = "https://coincoin.co.in"
        static let timeoutCount = 30
        
        static let uploadQueueLabel = "in.co.coincoin.networkUploadQueue"
        static let downloadQueueLabel = "in.co.coincoin.networkDownloadQueue"
    }
}

