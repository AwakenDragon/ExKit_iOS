//
//  StringEx.swift
//  ExKit
//
//  Created by ZhouYuzhen on 2020/11/8.
//

import SwifterSwift

// MARK: 字符串截取/拼接等
public extension String {
    
  
    ///  ExKit: 获取指定范围的字符串
    ///
    ///  ```
    ///  let str = "abcdefg"
    ///  let d = str[from: 3, len: 2] // d = "de"
    ///  ```
    ///
    ///  - parameter index: 指定开始位置，必须大于等于0且小于字符串本身长度 - 1
    ///  - parameter length: 指定字符串长度，必须大于0
    ///  - returns: String
    subscript(from index: Int, len length: Int) -> String? {
        self[safe: index ..< index + length]
    }
    
    ///  ExKit: 获取指定范围的字符串
    ///
    ///  ```
    ///  let str = "abcdefg"
    ///  let d = str[from: 3, len: 2] // d = "de"
    ///  ```
    ///
    ///  - parameter index: 指定开始位置，必须大于等于0且小于字符串本身长度 - 1
    ///  - parameter length: 指定字符串长度，必须大于0
    ///  - returns: String
    func substring(from index: Int, length: Int) -> String? {
        self[from: index, len: length]
    }

    /// ExKit: 截取到指定位置的字符串
    ///
    ///  ```
    ///  let str = "abcdefg"
    ///  let d = str.substring(to: 3) // d = "abcd"
    ///  ```
    ///
    ///  - parameter index : 结束位置（包含）
    ///  - returns : 截取String
    subscript(to index: Int) -> String? {
        self[safe: 0 ... (index >= self.count ? self.count - 1 : index)]
    }
    
    
    /// ExKit: 截取到指定位置的字符串
    ///
    ///  ```
    ///  let str = "abcdefg"
    ///  let d = str.substring(to: 3) // d = "abcd"
    ///  ```
    ///
    ///  - parameter index : 结束位置（包含）
    ///  - returns : 截取String
    func substring(to index: Int) -> String? {
        self[to: index]
    }
    
    /**
        ## 截取到指定位置的字符串
        ***
        ### 使用示例
        ```
        let str = "abcdefg"
        let d = str.ex_substring(from: 3) // d = "defg"
        ```
        ****
        - parameter index: 开始位置（包含）
        - returns : String
     */
    subscript(from index: Int) -> String? {
        self[safe: (index < 0 ? 0 : index) ..< self.count]
    }
    
    ///  ExKit: 截取到指定位置的字符串
    ///
    ///  ```
    ///  let str = "abcdefg"
    ///  let d = str.substring(from: 3) // d = "defg"
    ///  ```
    ///
    ///  - parameter from: 开始位置（包含）
    ///  - returns : String
    func substring(from index: Int) -> String? {
        self[from: index]
    }
    
    func appending(nameForScale scale: Float) -> String {
        if abs(scale - 1) <= Float.ulpOfOne || self.count == 0 || self.hasSuffix("/") {
            return String(self)
        } else {
            return "@\(scale)x"
        }
    }
    
    func appending(pathForScale scale: Float) -> String {
        if abs(scale - 1) <= Float.ulpOfOne || self.count == 0 || self.hasSuffix("/") {
            return String(self)
        } else {
            let ext = self.pathExtension
            var range = NSRange(location: self.count - ext.count, length: 0)
            if ext.count > 0 {
                range.location -= 1
            }
            let scaleStr = "@\(scale)@x"
            
            return (self as NSString).replacingCharacters(in: range, with: scaleStr) as String
        }
    }
}

// MARK: 字符串加密
public extension String {
    func md2String() -> String? {
        self.data(using: .utf8)?.md2String()
    }
    
    func md4String() -> String? {
        self.data(using: .utf8)?.md4String()
    }
    
    func md5String() -> String? {
        self.data(using: .utf8)?.md5String()
    }
    
    func sha1String() -> String? {
        self.data(using: .utf8)?.sha1String()
    }
    
    func sha224String() -> String? {
        self.data(using: .utf8)?.sha224String()
    }
    
    func sha256String() -> String? {
        self.data(using: .utf8)?.sha256String()
    }
    
    func sha384String() -> String? {
        self.data(using: .utf8)?.sha384String()
    }
    
    func sha512String() -> String? {
        self.data(using: .utf8)?.sha512String()
    }
    
    func hmacMD5StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacMD5String(key)
    }
    
    func hmacSHA1StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacSHA1String(key)
    }
    
    func hmacSHA224StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacSHA224String(key)
    }
    
    func hmacSHA256StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacSHA256String(key)
    }
    
    func hmacSHA384StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacSHA384String(key)
    }
    
    func hmacSHA512StringWithKey(key: String) -> String? {
        return self.data(using: .utf8)?.hmacSHA512String(key)
    }
    
    func crc32String() -> String? {
        self.data(using: .utf8)?.crc32String()
    }
    
    func base64EncodedString() -> String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }
    
    static func stringWithBase64EncodedString(base64EncodedString: String) -> String? {
        guard let base64Data = Data(base64Encoded: base64EncodedString, options:Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        let stringWithDecode = String(data: base64Data, encoding: .utf8)
        return stringWithDecode
    }
}

// MARK: URL
public extension String {
    func stringByURLEncode() -> String? {
        if self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) != nil {

            let kAFCharactersGeneralDelimitersToEncode: String = ":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
            let kAFCharactersSubDelimitersToEncode: String = "!$&'()*+,;=";

            var allowedCharacterSet: CharacterSet = CharacterSet.urlQueryAllowed;
            //[[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
            allowedCharacterSet.remove(charactersIn: kAFCharactersGeneralDelimitersToEncode.appending(kAFCharactersSubDelimitersToEncode));
            //[allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
            let batchSize: Int = 50;

            var index: Int = 0;
            var escaped: String = "";

            while (index < self.count) {
                let length: Int = min(self.count - index, batchSize);
                var range: NSRange = NSMakeRange(index, length);
                // To avoid breaking up character sequences such as 👴🏻👮🏽
                range = (self as NSString).rangeOfComposedCharacterSequences(for: range);

                    //[self rangeOfComposedCharacterSequencesForRange:range];
                let substring: String? = self.substring(from: range.location, length: range.length);
                    //[self substringWithRange:range];
                let encoded: String? = substring?.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet);
                    //[substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
                escaped = escaped.appending(encoded!);
                //[escaped appendString:encoded];

                index += range.length;
            }
            return escaped;
        } else {
            let cfEncoding: CFStringEncoding = CFStringConvertNSStringEncodingToEncoding(Encoding.utf8.rawValue)
            let encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self as CFString, nil, "!#$&'()*+,/:;=?@[]" as CFString,
                cfEncoding)! as String;
            return encoded;
        }
    }
    
    func stringByURLDecode() -> String? {
        if self.removingPercentEncoding != nil {
            return self.removingPercentEncoding;
        }else{
            var decoded: String = self.replacingOccurrences(of: "+", with: " ")
            decoded = CFURLCreateStringByReplacingPercentEscapes(nil, decoded as CFString, "" as CFString) as String
            return decoded;
        }
    }
}

// MARK: 计算大小
public extension String {
    func sizeForFont(font: UIFont?, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var result:CGSize;
        let tempFont = font ?? UIFont.systemFont(ofSize: 12);
        var attr: Dictionary = [NSAttributedString.Key: Any]();
        attr[NSAttributedString.Key.font] = tempFont;
        if (lineBreakMode != .byWordWrapping) {
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.init();
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSAttributedString.Key.paragraphStyle] = paragraphStyle;
        }
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin , .usesFontLeading]
        result = (self as NSString).boundingRect(with: size, options: options, attributes: attr, context: nil).size
        return result;
    }
    
    func sizeForFont(font: UIFont) -> CGSize {
        self.sizeForFont(font: font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping)
    }
    
    func widthForFont(font: UIFont, height: Float) -> Float {
        Float(self.sizeForFont(font: font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(height)), lineBreakMode: .byWordWrapping).width)
    }
    
    func heightForFont(font: UIFont, width: Float) -> Float {
        Float(self.sizeForFont(font: font, size: CGSize(width: CGFloat(width), height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping).width)
    }
}

/*

 - (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
     NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
     if (!pattern) return NO;
     return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
 }

 - (void)enumerateRegexMatches:(NSString *)regex
                       options:(NSRegularExpressionOptions)options
                    usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
     if (regex.length == 0 || !block) return;
     NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
     if (!regex) return;
     [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
         block([self substringWithRange:result.range], result.range, stop);
     }];
 }

 - (NSString *)stringByReplacingRegex:(NSString *)regex
                              options:(NSRegularExpressionOptions)options
                           withString:(NSString *)replacement; {
     NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
     if (!pattern) return self;
     return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
 }

 - (char)charValue {
     return self.numberValue.charValue;
 }

 - (unsigned char) unsignedCharValue {
     return self.numberValue.unsignedCharValue;
 }

 - (short) shortValue {
     return self.numberValue.shortValue;
 }

 - (unsigned short) unsignedShortValue {
     return self.numberValue.unsignedShortValue;
 }

 - (unsigned int) unsignedIntValue {
     return self.numberValue.unsignedIntValue;
 }

 - (long) longValue {
     return self.numberValue.longValue;
 }

 - (unsigned long) unsignedLongValue {
     return self.numberValue.unsignedLongValue;
 }

 - (unsigned long long) unsignedLongLongValue {
     return self.numberValue.unsignedLongLongValue;
 }

 - (NSUInteger) unsignedIntegerValue {
     return self.numberValue.unsignedIntegerValue;
 }


 + (NSString *)stringWithUUID {
     CFUUIDRef uuid = CFUUIDCreate(NULL);
     CFStringRef string = CFUUIDCreateString(NULL, uuid);
     CFRelease(uuid);
     return (__bridge_transfer NSString *)string;
 }

 + (NSString *)stringWithUTF32Char:(UTF32Char)char32 {
     char32 = NSSwapHostIntToLittle(char32);
     return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
 }

 + (NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
     return [[NSString alloc] initWithBytes:(const void *)char32
                                     length:length * 4
                                   encoding:NSUTF32LittleEndianStringEncoding];
 }

 - (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
     NSString *str = self;
     if (range.location != 0 || range.length != self.length) {
         str = [self substringWithRange:range];
     }
     NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
     UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
     if (len == 0 || char32 == NULL) return;
     
     NSUInteger location = 0;
     BOOL stop = NO;
     NSRange subRange;
     UTF32Char oneChar;
     
     for (NSUInteger i = 0; i < len; i++) {
         oneChar = char32[i];
         subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
         block(oneChar, subRange, &stop);
         if (stop) return;
         location += subRange.length;
     }
 }

 - (NSString *)stringByTrim {
     NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
     return [self stringByTrimmingCharactersInSet:set];
 }

 - (NSString *)stringByAppendingNameScale:(CGFloat)scale {
     if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
     return [self stringByAppendingFormat:@"@%@x", @(scale)];
 }

 - (NSString *)stringByAppendingPathScale:(CGFloat)scale {
     if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
     NSString *ext = self.pathExtension;
     NSRange extRange = NSMakeRange(self.length - ext.length, 0);
     if (ext.length > 0) extRange.location -= 1;
     NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
     return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
 }

 - (CGFloat)pathScale {
     if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
     NSString *name = self.stringByDeletingPathExtension;
     __block CGFloat scale = 1;
     [name enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
         scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
     }];
     return scale;
 }

 - (BOOL)isNotBlank {
     NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
     for (NSInteger i = 0; i < self.length; ++i) {
         unichar c = [self characterAtIndex:i];
         if (![blank characterIsMember:c]) {
             return YES;
         }
     }
     return NO;
 }

 - (BOOL)containsString:(NSString *)string {
     if (string == nil) return NO;
     return [self rangeOfString:string].location != NSNotFound;
 }

 - (BOOL)containsCharacterSet:(NSCharacterSet *)set {
     if (set == nil) return NO;
     return [self rangeOfCharacterFromSet:set].location != NSNotFound;
 }

 - (NSNumber *)numberValue {
     return [NSNumber numberWithString:self];
 }

 - (NSData *)dataValue {
     return [self dataUsingEncoding:NSUTF8StringEncoding];
 }

 - (NSRange)rangeOfAll {
     return NSMakeRange(0, self.length);
 }

 - (id)jsonValueDecoded {
     return [[self dataValue] jsonValueDecoded];
 }

 + (NSString *)stringNamed:(NSString *)name {
     NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
     NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
     if (!str) {
         path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
         str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
     }
     return str;
 }

 
 */
