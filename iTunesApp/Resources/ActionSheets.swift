//
//  ActionSheets.swift
//  iTunesApp
//
//  Created by Sergey on 12/11/20.
//

import Foundation
import UIKit

class ActionSheets {
    
    
    //MARK: - Public functions
    
    public static func createAnAlertWhenDidTapAddedTrackButton(on vc: UIViewController, with title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            NotificationCenter.default.post(name: Notification.Name("DeletedTrack"), object: nil)
        }))
        DispatchQueue.main.async {
            actionSheet.popoverPresentationController?.sourceView = UIView()
            actionSheet.popoverPresentationController?.sourceRect = UIView().bounds
            vc.present(actionSheet, animated: true)
        }
    }

    
}

