//
//  FilmGeneralCollectionViewCell.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import UIKit

class FilmGeneralCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { return "FilmGeneralCollectionViewCell" }
    static var name: String { return "FilmGeneralCollectionViewCell" }
    
    @IBOutlet weak var catergoryLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberReviewsLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(film : Film?) {
        self.catergoryLabel.text = film?.genre
        self.runtimeLabel.text = film?.runtime
        self.introLabel.text = film?.plot
        self.scoreLabel.text = film?.imdbRating
        self.numberReviewsLabel.text = film?.numberReview
        self.popularityLabel.text = film?.popularity
    }

}

extension FilmGeneralCollectionViewCell {
    static func size(bounds: CGSize,content : String) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0)
        label.text = content
        label.numberOfLines = 0
        var size: CGSize = label.sizeThatFits(.init(width: bounds.width, height: .infinity))
        size.height = size.height + 182.0
        return CGSize(width: bounds.width, height: size.height)
    }
}
