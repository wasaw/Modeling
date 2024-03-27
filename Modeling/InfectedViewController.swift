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
    static let infoViewHeight: CGFloat = 270
    static let infoViewCornerRadius: CGFloat = 20
    static let collectionViewPaddingTop: CGFloat = 25
    static let quantityWidth: CGFloat = 120
    static let quantityHeight: CGFloat = 60
    static let quantityOfInfectedViewTrailing: CGFloat = 40
}

final class InfectedViewController: UIViewController {
    
// MARK: - Properties
    
    private let groupSize = 26
    private let infectionFactor = 5
    private let timeInterval = 0
    private var isStartTimer = true
    private var maxSections = 0
    private let itemsPerSection = 5
    private var infectedPerson: Set<Person> = []
    private var grid: [[Person]] = []
    
    private lazy var quantityOfHealthyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    private lazy var quantityOfHealthyView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Здоровые"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: view.topAnchor)
        return view
    }()
    
    private lazy var quantityOfInfectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    private lazy var quantityOfInfectedView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Инфицированные"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: view.topAnchor)
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.infoViewCornerRadius
        view.backgroundColor = .logoBackground
        return view
    }()
    
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
        configureInfoView()
        configureCollectionView()
        view.backgroundColor = .background
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        infoView.anchor(leading: view.leadingAnchor,
                        top: view.topAnchor,
                        trailing: view.trailingAnchor,
                        height: Constants.infoViewHeight)
        
        infoView.addSubview(quantityOfHealthyView)
        quantityOfHealthyView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        quantityOfHealthyView.anchor(leading: infoView.leadingAnchor,
                                     paddingLeading: Constants.sectionPadding,
                                     width: Constants.quantityWidth,
                                     height: Constants.quantityHeight)
        quantityOfHealthyView.addSubview(quantityOfHealthyLabel)
        quantityOfHealthyLabel.centerXAnchor.constraint(equalTo: quantityOfHealthyView.centerXAnchor).isActive = true
        quantityOfHealthyLabel.anchor(bottom: quantityOfHealthyView.bottomAnchor)
        quantityOfHealthyView.layer.opacity = 0
        quantityOfHealthyLabel.layer.opacity = 0
        
        infoView.addSubview(quantityOfInfectedView)
        quantityOfInfectedView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        quantityOfInfectedView.anchor(trailing: infoView.trailingAnchor,
                                      paddingTrailing: -Constants.quantityOfInfectedViewTrailing,
                                      width: Constants.quantityWidth,
                                      height: Constants.quantityHeight)
        quantityOfInfectedView.addSubview(quantityOfInfectedLabel)
        quantityOfInfectedLabel.centerXAnchor.constraint(equalTo: quantityOfInfectedView.centerXAnchor).isActive = true
        quantityOfInfectedLabel.anchor(bottom: quantityOfInfectedView.bottomAnchor)
        quantityOfInfectedView.layer.opacity = 0
        quantityOfInfectedLabel.layer.opacity = 0
    }
    
    private func configureCollectionView() {
        collectionView.register(InfectedViewCell.self, forCellWithReuseIdentifier: InfectedViewCell.reuseIdentifire)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(leading: view.leadingAnchor,
                              top: infoView.bottomAnchor,
                              trailing: view.trailingAnchor,
                              bottom: view.bottomAnchor,
                              paddingTop: Constants.collectionViewPaddingTop)
        collectionView.backgroundColor = .background
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
            self?.setHumanData()
        }
    }
    
    private func setHumanData() {
        let quantityOfHealthy = groupSize - infectedPerson.count
        quantityOfHealthyLabel.text = String(quantityOfHealthy)
        quantityOfInfectedLabel.text = String(infectedPerson.count)
        
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.quantityOfHealthyView.layer.opacity = 1
            self?.quantityOfInfectedView.layer.opacity = 1
        }
        UIView.animate(withDuration: 1.4) { [weak self] in
            self?.quantityOfHealthyLabel.layer.opacity = 1
            self?.quantityOfInfectedLabel.layer.opacity = 1
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
