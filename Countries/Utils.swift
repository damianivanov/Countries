//
//  Utils.swift
//  Countries
//
//  Created by Damian Ivanov on 11.01.24.
//

import UIKit


class Utils {
    
    static let shared = Utils()
    private init(){
        
    }
    
    func getFlagId(fromUrl: String) -> String{
        return String(fromUrl.suffix(6))
    }
    
    func setFlowLayout(viewWidth: CGFloat, padding: CGFloat, itemSpacing: CGFloat, columns: CGFloat = 3 ) -> UICollectionViewFlowLayout {
        
        let availableWidth = viewWidth  - (padding*2) - (itemSpacing*2)
        let itemWidth = availableWidth / columns
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize( width: itemWidth, height: itemWidth + (padding*3))
        return flowLayout
    }
    
    func addBadgeToFavorite(_ tabBar: UITabBar?){
        guard let tabBar = tabBar else {return}
        guard let tabItem = tabBar.items?[1] else {return}
        var number = 0
        if let value = tabItem.badgeValue {
            number = Int(value) ?? 0
        }
        number+=1
        var numberString = String(number)
        tabItem.badgeColor = .red
        tabItem.badgeValue = numberString
        tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    func removeBadgeFavorite(_ tabBar: UITabBar?){
        guard let tabBar = tabBar else {return}
        guard let tabItem = tabBar.items?[1] else {return}
        tabItem.badgeValue = nil
    }
    
    func getButtonWidth(viewWidth: CGFloat, padding: CGFloat = Constants.buttonPadding, buttonSpacing: CGFloat = Constants.buttonSpacing, buttonsCount: CGFloat = 2) -> CGFloat {
            return (viewWidth - (padding * 2) - buttonSpacing * (buttonsCount-1)) / buttonsCount
        
    }
    
    func reduceCountryInfo(longInfo: String,sentencesCount: Int) -> String{
        let characterSet = CharacterSet(charactersIn: ".!?")
        let sentences = longInfo.components(separatedBy: characterSet)
        let combinedString = sentences.prefix(sentencesCount).joined(separator: ".")
        let clearedInfo = removeParenthesesAndContent(from: combinedString)
        return clearedInfo + "."
    }
    
    func removeParenthesesAndContent(from input: String) -> String {
        let pattern = "\\([^)]*\\)"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: input.utf16.count)
        return regex.stringByReplacingMatches(in: input, range: range, withTemplate: "")
    }
    
    func getSheetDetailsVC(countryName: String) -> UINavigationController{
        
        let detailsVC = DetailsVC()
        let nav = UINavigationController(rootViewController: detailsVC)
        detailsVC.countryName = countryName
        
        if #available(iOS 15.0, *) {
            if let sheet  = nav.sheetPresentationController {
                sheet.detents = [.large(),.medium()]
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.preferredCornerRadius = 20
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
        }
        return nav
    }
}


struct Constants {
    static let logoImagePath = "countriesLogo.png"
    static let padding: CGFloat = 10
    
    static let heightScrollViewItem: CGFloat = 200
    static let widthScrollViewItem: CGFloat = 170
    
    static let viewHeight: CGFloat = 120
    
    static let labelHeight: CGFloat = 20
    static let buttonPadding: CGFloat = 50
    static let buttonSpacing: CGFloat = 30
    static let buttonHeight: CGFloat = 40
    //Alert
    static let alertHeight: CGFloat = 200
    static let alertWidth: CGFloat = 320
    static let alertPadding: CGFloat = 20
    
    static let tintColor: UIColor = .systemGreen
}