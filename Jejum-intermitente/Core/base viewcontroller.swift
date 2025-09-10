//
//  base viewcontroller.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

class BaseViewController<ContentView: UIView>: UIViewController {
    let contentView = ContentView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
    }
}
