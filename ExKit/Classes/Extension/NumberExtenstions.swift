//
//  NumberExtenstions.swift
//  ExKit
//
//  Created by jxxz on 2021/2/1.
//

import Foundation

public extension NSNumber {
    
    static func numberWithString(string: String) -> NSNumber? {
        return nil;
//        let str: String = string.
        
//        let str:String = [[string stringByTrim] lowercaseString];
//        if (!str || !str.length) {
//            return nil;
//        }
//
//        static NSDictionary *dic;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            dic = @{@"true" :   @(YES),
//                    @"yes" :    @(YES),
//                    @"false" :  @(NO),
//                    @"no" :     @(NO),
//                    @"nil" :    [NSNull null],
//                    @"null" :   [NSNull null],
//                    @"<null>" : [NSNull null]};
//        });
//        id num = dic[str];
//        if (num) {
//            if (num == [NSNull null]) return nil;
//            return num;
//        }
//
//        // hex number
//        int sign = 0;
//        if ([str hasPrefix:@"0x"]) sign = 1;
//        else if ([str hasPrefix:@"-0x"]) sign = -1;
//        if (sign != 0) {
//            NSScanner *scan = [NSScanner scannerWithString:str];
//            unsigned num = -1;
//            BOOL suc = [scan scanHexInt:&num];
//            if (suc)
//                return [NSNumber numberWithLong:((long)num * sign)];
//            else
//                return nil;
//        }
//        // normal number
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//        return [formatter numberFromString:string];
    }

    
    
}
