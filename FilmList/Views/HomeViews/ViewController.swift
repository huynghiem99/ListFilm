//
//  ViewController.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var homeNetwork = DefaultFilmNetwork()
    var listFilm: [Film] = []
    var page:Int = 1
    var textSearch: String = "Marvel"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 16.0, right: 16.0)
        self.searchTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.callData(page: 1, key: self.textSearch)
    }
    
    private func callData(page: Int, key: String) {
        homeNetwork.getSearchFilm(page: page,keySearch: key) { (result) in
            switch result {
            case .success(let films):
                self.listFilm += films
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerCell() {
        self.collectionView.register(UINib(nibName: FilmCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textSearch = textField.text ?? ""
        self.page = 1
        self.listFilm = []
        print(self.textSearch)
        self.callData(page: self.page, key: self.textSearch)
        return true
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let transition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if self.collectionView.contentOffset.y >= (collectionView.contentSize.height - self.collectionView.frame.height) {
            if transition.y < -70 {
                self.page += 1
                self.callData(page: self.page, key: self.textSearch)
                self.collectionView.reloadData()
            }
        }
    }


}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FilmCollectionViewCell.size(bounds: self.view.bounds.size)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.listFilm.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as? FilmCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(film: listFilm[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "FilmDetailViewController") as? FilmDetailViewController else { return }
        vc.film = self.listFilm[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

