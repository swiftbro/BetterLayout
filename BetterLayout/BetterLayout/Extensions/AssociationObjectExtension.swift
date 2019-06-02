//
//  AssociationObjectExtension.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation

/// Returns the value associated with a given object for a given key.
///
/// - Parameters:
///   - holder: The source object for the association.
///   - key: The key for the association. **Optional** if association was set without key specified.
/// - Returns: The value associated with the key key for object.
func getAssociatedObject(for holder: Any, key: UnsafeRawPointer? = nil) -> Any? {
    if let key = key { return objc_getAssociatedObject(holder, key) }
    else { return objc_getAssociatedObject(holder, &associationKey) }
}

/// Sets an associated value for a given object using a given key and association policy.
///
/// - Parameters:
///   - value:  The value to associate with the key key for object. Pass nil to clear an existing association.
///   - holder: The source object for the association.
///   - key:    The key for the association.
///             **Optional** if it's a **single** association for holder.
///             For extra associations key must be specified
///             otherwise new association will clear the old one.
///   - policy: The policy for the association. Default to retain atomic
///             For possible values, see [extension](x-source-tag://AssociationPolicyShorthand).
func setAssociatedObject(_ value: Any?,
                         for holder: Any,
                         key: UnsafeRawPointer? = nil,
                         policy: objc_AssociationPolicy = .retainAtomic) {
    if let key = key { objc_setAssociatedObject(holder, key, value, policy) }
    else { objc_setAssociatedObject(holder, &associationKey, value, policy) }
}

/// Clears an existing association
///
/// - Parameters:
///   - holder: The source object for the association.
///   - key: The key for the association. **Optional** if association was set without key specified.
func clearAssociationOblect(for holder: Any, key: UnsafeRawPointer? = nil) {
    if let key = key { objc_setAssociatedObject(holder, key, nil, .weak) }
    else { objc_setAssociatedObject(holder, &associationKey, nil, .weak) }
}

/// Default key for association
fileprivate var associationKey: Void?

// MARK: - Shorthand to association policies
extension objc_AssociationPolicy { /// - Tag: AssociationPolicyShorthand
    static var weak: objc_AssociationPolicy { return .OBJC_ASSOCIATION_ASSIGN}
    static var retain: objc_AssociationPolicy { return .OBJC_ASSOCIATION_RETAIN_NONATOMIC}
    static var retainAtomic: objc_AssociationPolicy { return .OBJC_ASSOCIATION_RETAIN}
    static var copy: objc_AssociationPolicy { return .OBJC_ASSOCIATION_COPY_NONATOMIC}
    static var copyAtomic: objc_AssociationPolicy { return .OBJC_ASSOCIATION_COPY}
}
