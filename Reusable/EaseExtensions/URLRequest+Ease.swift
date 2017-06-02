//
//  URLRequest+Ease.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 27/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension URLRequest {
    
    public init(url: URL, headerParams: [String : Any]) {
        self.init(url: url)
        for (key, value) in headerParams {
            addValue("\(value)", forHTTPHeaderField: key)
        }
    }
    
}
