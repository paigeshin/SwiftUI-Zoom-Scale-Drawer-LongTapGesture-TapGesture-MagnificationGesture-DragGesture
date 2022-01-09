//
//  Page.swift
//  PinchAndZoomSwiftUI3
//
//  Created by paige on 2022/01/10.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

let pagesData: [Page] = [
    Page(id: 1, imageName: "magazine-front-cover"),
    Page(id: 2, imageName: "magazine-back-cover"),
]

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
