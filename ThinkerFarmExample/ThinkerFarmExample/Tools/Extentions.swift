//
//  Extentions.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 13.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import Foundation



extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
