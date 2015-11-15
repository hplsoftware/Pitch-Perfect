//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Rob Sutherland on 2015-11-14.
//  Copyright © 2015 Rob Sutherland. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL!,titleFile: String!){
        
        filePathUrl = url
        title = titleFile
        
    }
}