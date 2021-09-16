//
//  FilmDetailViewController.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import UIKit

enum FilmDetailSection: Int, Comparable, CaseIterable {
    case general = 0
    case credit = 1
    
    static func < (lhs: FilmDetailSection, rhs: FilmDetailSection) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

class FilmDetailViewController: UIViewController {
    
    static var identifier: String { return "FilmDetailViewController" }
    static var name: String { return self.identifier }
    
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    @IBOutlet weak var imgParalel: UIImageView!
    @IBOutlet weak var heightParalel: NSLayoutConstraint!
    
    var film: Film?
    var filmNetwork = DefaultFilmNetwork()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setupParalelHeader()
        self.getData()
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupParalelHeader() {
        self.imgParalel.downloaded(from: self.film?.poster ?? "", contentMode: .scaleAspectFill)
    }
    
    private func registerCell() {
        self.collectionViewDetail.delegate = self
        self.collectionViewDetail.dataSource = self
        self.collectionViewDetail.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        self.collectionViewDetail.register(UINib(nibName: FilmGeneralCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: FilmGeneralCollectionViewCell.identifier)
        self.collectionViewDetail.register(UINib(nibName: FilmCreditCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: FilmCreditCollectionViewCell.identifier)
        self.collectionViewDetail.isHidden = true
    }
    
    private func getData() {
        self.filmNetwork.getDetailFilm(id: self.film?.imdbID) { (result) in
            switch result {
            case .success(let film):
                self.film = film
                self.collectionViewDetail.isHidden = false
                self.collectionViewDetail.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

extension FilmDetailViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case FilmDetailSection.general.rawValue:
            return FilmGeneralCollectionViewCell.size(bounds: view.bounds.size, content: film?.plot ?? "")
        case FilmDetailSection.credit.rawValue:
            return FilmCreditCollectionViewCell.size(bounds: view.bounds.size)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension FilmDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilmDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case FilmDetailSection.general.rawValue:
            return 1
        case FilmDetailSection.credit.rawValue:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case FilmDetailSection.general.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmGeneralCollectionViewCell.identifier, for: indexPath) as? FilmGeneralCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setup(film: self.film)
            return cell
        case FilmDetailSection.credit.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCreditCollectionViewCell.identifier, for: indexPath) as? FilmCreditCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setup(film: film)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: -Scroll Paralel Header
extension FilmDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = max(y,10)
        self.heightParalel.constant = height
    }
}
