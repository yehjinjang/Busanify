//
//  RatingTableViewCell.swift
//  Busanify
//
//  Created by 이인호 on 7/18/24.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    
    static let identifier = "rating"
    
    private let ratingLabel = UILabel()
    
    private lazy var starBackgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var addReviewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            // 버튼 클릭시 리뷰 작성 뷰로 이동
            
        }, for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        backgroundStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        ratingLabel.font = UIFont.systemFont(ofSize: 24)
        
        contentView.addSubview(ratingLabel)
        contentView.addSubview(starBackgroundStackView)
        contentView.addSubview(starStackView)
        contentView.addSubview(addReviewButton)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        starBackgroundStackView.translatesAutoresizingMaskIntoConstraints = false
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            starBackgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            starBackgroundStackView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 16),
            starBackgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            starStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            starStackView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 16),
            starStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            addReviewButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            addReviewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addReviewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func backgroundStars() {
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .gray
            starBackgroundStackView.addArrangedSubview(starImageView)
        }
    }
    
    private func setUpStars(rating: Double) {
        for _ in 0..<5 {
            let starImageView = StarImageView(image: UIImage(systemName: "star.fill"))
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .black
            starStackView.addArrangedSubview(starImageView)
        }
        
        var rating = rating
        for i in 0..<5 {
            if rating < 0 {
                break
            }
            
            let percentage = min(rating, 1)
            updateStarFill(at: i, percentage: percentage)
            rating -= percentage
        }
    }
    
    private func updateStarFill(at index: Int, percentage: CGFloat) {
        guard let starImageView = starStackView.arrangedSubviews[index] as? StarImageView else { return }
        starImageView.fillPercentage = percentage
    }
    
    func configure(with rating: Double) {
        ratingLabel.text = "\(rating)"
        setUpStars(rating: rating)
    }
}

class StarImageView: UIImageView {

    var fillPercentage: CGFloat = 0 {
        didSet {
            applyMask()
        }
    }
    
    private func applyMask() {
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * fillPercentage, height: bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        
        let maskView = UIView(frame: bounds)
        maskView.layer.addSublayer(maskLayer)
        
        self.mask = maskView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyMask()
    }
}
