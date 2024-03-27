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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        backgroundColor = .cellBackground
    }
    
// MARK: - Helpers
    
    func setInfected(_ isInfected: Bool) {
        backgroundColor = isInfected ? .cellInfectedBackground : .cellBackground
    }
}
