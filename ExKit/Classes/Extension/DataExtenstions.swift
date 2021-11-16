//
//  DataExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/1/17.
//

import CommonCrypto
import zlib

public extension Data {
    func md2String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD2_DIGEST_LENGTH))
        CC_MD2(self.bytes, CC_LONG(self.count), &result)
        return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", arguments: result)
    }
    
    func md2Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD2_DIGEST_LENGTH))
        CC_MD2(self.bytes, CC_LONG(self.count), &result)
        return Data(bytes: result, count: Int(CC_MD2_DIGEST_LENGTH))
    }
    
    func md4String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD4_DIGEST_LENGTH))
        CC_MD4(self.bytes, CC_LONG(self.count), &result)
        return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", arguments: result)
    }
    
    func md4Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD4_DIGEST_LENGTH))
        CC_MD4(self.bytes, CC_LONG(self.count), &result)
        return Data(bytes: result, count: Int(CC_MD4_DIGEST_LENGTH))
    }
    
    func md5String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(self.bytes, CC_LONG(self.count), &result)
        return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", arguments: result)
    }
    
    func md5Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(self.bytes, CC_LONG(self.count), &result)
        return Data(bytes: result, count: Int(CC_MD5_DIGEST_LENGTH))
    }

    func sha1String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(self.bytes, CC_LONG(self.count), &result);
        var hash = String()
        for i in 0 ..< Int(CC_SHA1_DIGEST_LENGTH) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash
    }
    
    func sha1Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(self.bytes, CC_LONG(self.count), &result);
        return Data(bytes: result, count: Int(CC_SHA1_DIGEST_LENGTH))
    }
    
    func sha224String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH));
        CC_SHA224(self.bytes, CC_LONG(self.count), &result);
        var hash = String()
        for i in 0 ..< Int(CC_SHA224_DIGEST_LENGTH) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash;
    }
    
    func sha224Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH));
        CC_SHA224(self.bytes, CC_LONG(self.count), &result);
        return Data(bytes: result, count: Int(CC_SHA224_DIGEST_LENGTH))
    }
    
    func sha256String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH));
        CC_SHA256(self.bytes, CC_LONG(self.count), &result);
        var hash = String()
        for i in 0 ..< Int(CC_SHA256_DIGEST_LENGTH) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash;
    }
    
    func sha256Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH));
        CC_SHA256(self.bytes, CC_LONG(self.count), &result);
        return Data(bytes: result, count: Int(CC_SHA256_DIGEST_LENGTH))
    }
    
    func sha384String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH));
        CC_SHA384(self.bytes, CC_LONG(self.count), &result);
        var hash = String()
        for i in 0 ..< Int(CC_SHA384_DIGEST_LENGTH) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash;
    }
    
    func sha384Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH));
        CC_SHA384(self.bytes, CC_LONG(self.count), &result);
        return Data(bytes: result, count: Int(CC_SHA384_DIGEST_LENGTH))
    }
    
    func sha512String() -> String {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH));
        CC_SHA512(self.bytes, CC_LONG(self.count), &result);
        var hash = String()
        for i in 0 ..< Int(CC_SHA512_DIGEST_LENGTH) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash;
    }
    
    func sha512Data() -> Data {
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH));
        CC_SHA512(self.bytes, CC_LONG(self.count), &result);
        return Data(bytes: result, count: Int(CC_SHA512_DIGEST_LENGTH))
    }
    
    func hmacString(_ alg: CCHmacAlgorithm, _ key: String) -> String? {
        var size: Int32 = 0;
        switch Int(alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH
        default:
            return nil
        }
        
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(size));
        guard let cKey = key.cString(using: .utf8) else {
            return nil
        }
        CCHmac(alg, cKey, cKey.count, self.bytes, self.count, &result)
        var hash = String()
        for i in 0 ..< Int(size) {
            hash = hash.appendingFormat("%02x", result[i])
        }
        return hash;
    }
    
    func hmacData(_ alg: CCHmacAlgorithm, _ key: String) -> Data? {
        var size: Int32 = 0;
        switch Int(alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH
        default:
            return nil
        }
        
        var result: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: Int(size));
        guard let cKey = key.cString(using: .utf8) else {
            return nil
        }
        CCHmac(alg, cKey, cKey.count, self.bytes, self.count, &result)
        return Data(bytes: result, count: Int(size))
    }
    
    func hmacMD5String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgMD5), key)
    }
    
    func hmacMD5Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgMD5), key)
    }
    
    func hmacSHA1String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgSHA1), key)
    }
    
    func hmacSHA1Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgSHA1), key)
    }
    
    func hmacSHA224String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgSHA224), key)
    }
    
    func hmacSHA224Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgSHA224), key)
    }
    
    func hmacSHA256String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgSHA256), key)
    }
    
    func hmacSHA256Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgSHA256), key)
    }
    
    func hmacSHA384String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgSHA384), key)
    }
    
    func hmacSHA384Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgSHA384), key)
    }
    
    func hmacSHA512String(_ key: String) -> String? {
        hmacString(CCHmacAlgorithm(kCCHmacAlgSHA512), key)
    }
    
    func hmacSHA512Data(_ key: String) -> Data? {
        hmacData(CCHmacAlgorithm(kCCHmacAlgSHA512), key)
    }
    
    func crc32String() -> String {
        String(format: "%08x", UInt32(zlib.crc32(0, self.bytes, uInt(self.count))))
    }
    
    func crc32() -> UInt32 {
        UInt32(zlib.crc32(0, self.bytes, uInt(self.count)))
    }
}
