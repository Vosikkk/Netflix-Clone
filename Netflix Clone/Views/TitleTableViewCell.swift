//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 01.10.2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "TitleTableViewCell"
    
    private let playTitlesButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let titlesPoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPoster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitlesButton)
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Methods
    private func applyConstraints() {
        let titlesPosterConstraints = [
            titlesPoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlesPoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlesPoster.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playTitlesButtonConstraints = [
            playTitlesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitlesButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(playTitlesButtonConstraints)
        NSLayoutConstraint.activate(titlesPosterConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        
    }
    
    // MARK: - Again super func
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: Constants.baseImageURL + model.posterURL) else { return }
        titlesPoster.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
}
