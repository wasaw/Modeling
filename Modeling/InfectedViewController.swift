//
//  InfectedViewController.swift
//  Modeling
//
//  Created by Александр Меренков on 25.03.2024.
//

import UIKit

private enum Constants {
    static let cellDimensions: CGFloat = 60
    static let sectionPadding: CGFloat = 10
    static let minimumLineSpacing: CGFloat = 10
}

final class InfectedViewController: UIViewController {
    
// MARK: - Properties
    
    private let groupSize = 26
    private let infectionFactor = 5
    private let timeInterval = 3
    private var isStartTimer = true
    private var maxSections = 0
    private let itemsPerSection = 5
    private var infectedPerson: Set<Person> = []
    private var grid: [[Person]] = []
    
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxSections = Int(ceil(Double(groupSize) / Double(itemsPerSection)))
        setupGrid()
        configureUI()
    }
    
// MARK: - Helpers
    
    private func setupGrid() {
        var id = 0
        for i in 0..<maxSections {
            var row: [Person] = []
            for j in 0..<itemsPerSection {
                row.append(Person(id: id, column: i, row: j))
                id += 1
            }
            grid.append(row)
        }
    }
    
    private func configureUI() {
        collectionView.register(InfectedViewCell.self, forCellWithReuseIdentifier: InfectedViewCell.reuseIdentifire)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(leading: view.leadingAnchor, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        collectionView.backgroundColor = .orange
    }
    
    private func humanInfection(_ index: IndexPath) {
        grid[index.section][index.row].isInfected = true
        let selectedPerson = grid[index.section][index.row]
        infectedPerson.insert(selectedPerson)
        let neighbors = [
            (index.section, index.row - 1),
            (index.section, index.row + 1),
            (index.section - 1, index.row),
            (index.section + 1, index.row)
        ].compactMap { (c, r) -> Person? in
            guard c >= 0 && c < maxSections && r >= 0 && r < itemsPerSection else { return nil }
            return grid[c][r]
        }
        
        for neighbor in neighbors {
            if !infectedPerson.contains(neighbor) 
                && Bool.random()
                && infectedPerson.count < infectionFactor {
                    humanInfection(IndexPath(row: neighbor.row, section: neighbor.column))
            }
        }
    }
    
    private func drawInfectedViews() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: false) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension InfectedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        infectedPerson = []
        humanInfection(indexPath)

        if isStartTimer {
            drawInfectedViews()
            isStartTimer = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension InfectedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return maxSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == (maxSections - 1) {
            let showCells = section * itemsPerSection
            return groupSize - showCells
        }
        return itemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfectedViewCell.reuseIdentifire, for: indexPath) as? InfectedViewCell else { return UICollectionViewCell() }
            cell.setInfected(grid[indexPath.section][indexPath.row].isInfected)
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

extension InfectedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellDimensions, height: Constants.cellDimensions)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.sectionPadding,
                            left: Constants.sectionPadding,
                            bottom: Constants.sectionPadding,
                            right: Constants.sectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }
}
