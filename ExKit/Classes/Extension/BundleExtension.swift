//
//  BundleExtension.swift
//  ExKit
//
//  Created by jxxz on 2021/1/29.
//

import Foundation

public extension Bundle {
    
    /*
     + (NSArray *)preferredScales {
         static NSArray *scales;
         static dispatch_once_t onceToken;
         dispatch_once(&onceToken, ^{
             CGFloat screenScale = [UIScreen mainScreen].scale;
             if (screenScale <= 1) {
                 scales = @[@1,@2,@3];
             } else if (screenScale <= 2) {
                 scales = @[@2,@3,@1];
             } else {
                 scales = @[@3,@2,@1];
             }
         });
         return scales;
     }
     
     */
    static func preferredScales() -> Array<Int> {
        var scales : Array<Int>;
        let screenScale = UIScreen.main.scale;
        if screenScale <= 1 {
            scales = [1,2,3];
        } else if screenScale <= 2 {
            scales = [2,3,1];
        } else {
            scales = [3,2,1];
        }
        return scales;
    }
    
    static func pathForScaled(forResource name: String, ofType ext: String, inDirectory bundlePath: String) -> String? {
        if name.isEmpty {
            return nil
        }
        if name.hasSuffix("/") {
            return self.path(forResource: name, ofType: ext, inDirectory: bundlePath)
        }
        
        var path: String? = nil;
        let scales = self.preferredScales();
        for s in 0..<scales.count {
            let scale = scales[s].float;
            let scaleName = ext.isEmpty ? name.appending(pathForScale: scale) : name.appending(nameForScale: scale)
            path = self.path(forResource: scaleName, ofType: ext, inDirectory: bundlePath)
            if path.isNonEmpty {
                break
            }
        }
        return path;
    }
    
}
