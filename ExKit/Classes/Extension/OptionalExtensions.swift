//
//  OptionalExtension.swift
//  ExKit
//
//  Created by zyz on 2021/1/16.
//

// MARK: - Methods (Collection)
public extension Optional where Wrapped: Collection {
    
    /// ExKit 检查`optional`是否不为`nil`且不为空集合
    var isNonEmpty: Bool {
        guard let collection = self else { return false }
        return !collection.isEmpty
    }
}
