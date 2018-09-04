//
//  PictureListModel.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by 長谷川敬 on 2018/08/19.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

let loremipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "

class PictureListModel {
    private let pictures: [PictureListItem]
    
    init() {
        pictures = [
            PictureListItem(title: "Image 01", imageName: "Image1", description: loremipsum),
            PictureListItem(title: "Image 02", imageName: "Image2", description: loremipsum),
            PictureListItem(title: "Image 03", imageName: "Image3", description: loremipsum),
            PictureListItem(title: "Image 04", imageName: "Image4", description: loremipsum),
            PictureListItem(title: "Image 05", imageName: "Image5", description: loremipsum),
            PictureListItem(title: "Image 06", imageName: "Image6", description: loremipsum)
        ]
    }
    
    func numberOfItems() -> Int {
        return pictures.count
    }
    
    func picture(at indexPath: IndexPath) -> PictureListItem? {
        guard indexPath.section == 0 && indexPath.row < pictures.count else {
            return nil
        }
        
        return pictures[indexPath.row]
    }
}
