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
    var scrollLock = false
    var page = 1
    let maxPage = 2
    var height: CGFloat = 0
    var width: CGFloat = 0
    var itemsCount: CGFloat {
        return CGFloat(unsplashLinks.count + ((page - 1) * 10))
    }
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

    fileprivate func screenSize() {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 800 {
            height = Constants.heightScrollViewItemSM
            width = Constants.widthScrollViewItemSM
        } else {
            height = Constants.heightScrollViewItem
            width = Constants.widthScrollViewItem
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize()
        self.scrollView.delegate = self
        configureScrollView()
        getPhotosLinks()
    }

    func updateContentSize() {
        let contentWidth = width * itemsCount + Constants.padding * (itemsCount+1)
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: contentWidth, height: self.height)
        }
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        view.tamicFalse()
        updateContentSize()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    private func getPhotosLinks() {
        Task {
            do {
                self.unsplashLinks = try await NetworkManager.shared.searchImagesQuery(query: countryName, page: page)
                populateScrollView()
                updateContentSize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @MainActor
    func populateScrollView() {
        for index in 0..<unsplashLinks.count {
            let link = unsplashLinks[index].regular
            Task {
                let frame = CGRect(x: getXposition(index, page), y: 0,
                                   width: width, height: height)
                let subView = UIImageView(frame: frame)
                subView.image = UIImage(named: "placeholderImage")
                subView.contentMode = .scaleAspectFill
                subView.layer.cornerRadius = 15
                subView.clipsToBounds = true
                scrollView.addSubview(subView)
                subView.image = await NetworkManager.shared.downloadUnsplashImage(imageURL: link)
            }
        }
    }

    func getXposition(_ index: Int, _ page: Int) -> CGFloat {
        let itemIndex: CGFloat = CGFloat(index + ((page-1)*10))
        return CGFloat(width * itemIndex + (itemIndex+1) * Constants.padding)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.width) && !scrollLock {
            getPhotosLinks()
            page += 1
            if page >= maxPage {
                scrollLock = true
            }
        }
    }
}
