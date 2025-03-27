//
//  UIImageResource.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import UIKit

enum UIImageResource {
    static let cancel: UIImage = UIImage(systemName: "multiply")!.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    static let create: UIImage = UIImage(systemName: "plus")!
    static let delete: UIImage = UIImage(systemName: "trash")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    static let done: UIImage = UIImage(systemName: "checkmark")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    
    static let check: UIImage = UIImage(systemName: "checkmark.square")!
    static let uncheck: UIImage = UIImage(systemName: "square")!
}
