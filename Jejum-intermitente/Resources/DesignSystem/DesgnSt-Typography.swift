//
//  DesgnSt-Typography.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

enum Typography {
    static func titleBold(_ size: CGFloat = 28) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func body(_ size: CGFloat = 17) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func caption(_ size: CGFloat = 13) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
