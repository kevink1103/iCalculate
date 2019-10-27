//
//  CoreDataManager.swift
//  iCalculate
//
//  Created by Kevin Kim on 27/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

class CoreDataManager {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
}
