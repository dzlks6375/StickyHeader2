//
//  Page.swift
//  StickeyHeaderiOS
//
//  Created by Sowndharya M on 13/04/19.
//  Copyright © 2019 Sowndharya M. All rights reserved.
//

import Foundation
import UIKit

struct Page {
    
    var vc = UIViewController()
    
    init(_vc: UIViewController) {
        
        vc = _vc
    }
}

struct PageCollection {
    
    var pages = [Page]()
    var selectedPageIndex = 0 //The first page is selected by default in the beginning
}
