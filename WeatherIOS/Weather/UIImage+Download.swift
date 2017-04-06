//
//  UIImage+Download.swift
//  Weather
//
//  Created by Akanksha on 4/5/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView
{
    func downloadImage(imgName:String)
    {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(Constant.iconUrl)\(imgName).png")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
                
            }
            
        })
        task.resume()
    }
}
