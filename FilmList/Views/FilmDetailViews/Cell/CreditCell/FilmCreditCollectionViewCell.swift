//
//  FilmCreditCollectionViewCell.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import UIKit

class FilmCreditCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { return "FilmCreditCollectionViewCell" }
    static var name: String { return "FilmCreditCollectionViewCell" }
    
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(film: Film?) {
        self.directorLabel.text = film?.director
        self.writerLabel.text = film?.writer
        self.actorLabel.text = film?.actor
    }

}

extension FilmCreditCollectionViewCell {
    static func size(bounds: CGSize) -> CGSize {
        return CGSize(width: bounds.width, height: 350.0)
    }
}
