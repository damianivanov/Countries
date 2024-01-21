//
//  CFScrollableView.swift
//  Countries
//
//  Created by Damian Ivanov on 9.01.24.
//

import UIKit

class CFScrollableView: UIViewController, UIScrollViewDelegate {

    var scrollView = UIScrollView()
    var countryName = ""
    var unsplashLinks: [UnsplashURLs] = []
    var scrollViewImages: [UIImageView] = []
    var scrollLock = false
    var page = 1
    var imagesCount: CGFloat {
        return CGFloat(unsplashLinks.count)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(countryName: String) {
        super.init(nibName: nil, bundle: nil)
        self.countryName = countryName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        configureScrollView()
        getPhotosLinks()
        // scrollView.reloadInputViews()
    }

    func updateContentSize() {
        let contentWidth = Constants.widthScrollViewItem * imagesCount + Constants.padding * (imagesCount+1)
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: contentWidth, height: Constants.heightScrollViewItem)
        }
    }

    func configureScrollView() {
        view.addSubview(scrollView)
        view.tamicFalse()
        updateContentSize()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: Constants.heightScrollViewItem)
        ])
    }

    func getPhotosLinks() {
        DispatchQueue.global().async {[weak self] in
            guard let self = self else {return}
            NetworkManager.shared.searchImagesQuery(query: countryName, page: page) {response, _ in
                guard let urls = response else {return}
                self.unsplashLinks.append(contentsOf: urls)
                DispatchQueue.main.async {
                    self.populateScrollView()
                    self.updateContentSize()
                }
            }
        }
    }

    func populateScrollView() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        for index in 0..<unsplashLinks.count {
            DispatchQueue.global(qos: .userInitiated).async {
                NetworkManager.shared.downlodImage(imageURL: self.unsplashLinks[index].regular) { data, _ in
                    let frame = CGRect(x: self.getXposition(index), y: 0,
                                       width: Constants.widthScrollViewItem, height: Constants.heightScrollViewItem)
                    DispatchQueue.main.async {
                        let subView = UIImageView(frame: frame)
                        subView.image = UIImage(data: data! as Data)
                        subView.contentMode = .scaleAspectFill
                        subView.layer.cornerRadius = 15
                        subView.clipsToBounds = true
                        self.scrollView.addSubview(subView)
                    }
                }
            }
        }
    }

    func getXposition(_ index: Int) -> CGFloat {
        return CGFloat(Constants.widthScrollViewItem * CGFloat(index)) + CGFloat(index+1) * Constants.padding
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.width) && !scrollLock {
            getPhotosLinks()
            page += 1
            if page > 2 {
                scrollLock = true
            }
        }
    }
}
