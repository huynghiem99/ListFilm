//
//  FilmCollectionViewCell.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return "FilmCollectionViewCell" }
    static var name: String { return "FilmCollectionViewCell" }
    
    @IBOutlet weak var nameFilmLabel: UILabel!
    @IBOutlet weak var imagePosterFilm: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    //MARK: -UI
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
    }
    
    func setup(film: Film) {
        self.nameFilmLabel.text = film.title
        guard let poster = film.poster else { return }
        self.imagePosterFilm.downloaded(from: poster)
    }

}

extension FilmCollectionViewCell {
    static func size(bounds : CGSize) -> CGSize {
        let width:CGFloat = (bounds.width - 16*3 ) / 2
        let height:CGFloat = width * 1.5
        return CGSize(width: width, height: height)
    }
}
