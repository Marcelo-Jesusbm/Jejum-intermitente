//
//  base.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

protocol ViewCode {
    func setupHierarchy()
    func setupConstraints()
    func setupViews()
}

extension ViewCode {
    func buildView() {
        setupHierarchy()
        setupConstraints()
        setupViews()
    }
}
