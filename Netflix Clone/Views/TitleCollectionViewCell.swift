//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 01.10.2023.
//

import UIKit
import SDWebImage



class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        
        
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    // Set our image(poster) on all screen even when our cell changing size
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    // MARK: - super func
    // receive URL using TMBD api and set poster as backgroud for our cell
    public func configure(with model: String){
        guard let url = URL(string: Constants.baseImageURL + model) else { return }
        posterImageView.sd_setImage(with: url)
    }
    
}
