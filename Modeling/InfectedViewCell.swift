//
//  InfectedViewCell.swift
//  Modeling
//
//  Created by Александр Меренков on 25.03.2024.
//

import UIKit

final class InfectedViewCell: UICollectionViewCell {
    static let reuseIdentifire = "infectedViewCell"
    
// MARK: - Lifecycle
    
    override func prepareForReuse() {
        backgroundColor = .gray
    }
    
// MARK: - Helpers
    
    func setInfected(_ isInfected: Bool) {
        backgroundColor = isInfected ? .blue : .gray
    }
}
