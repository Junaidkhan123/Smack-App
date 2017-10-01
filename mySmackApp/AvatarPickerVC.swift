
//
//  AvatarPickerVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 20/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController {
    
    @IBOutlet weak var controlSegment: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var avatarType = AvatarType.dark
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
 
    
    @IBAction func controlSegmentValueChanged(_ sender: Any) {
        if controlSegment.selectedSegmentIndex == 0
        {
            avatarType = .dark
        }
        else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension AvatarPickerVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell{
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320
        {
            numberOfColumns = 4
        }
        let spaceBetweenCell : CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1 ) * spaceBetweenCell)/numberOfColumns
       
        return CGSize(width: cellDimension, height: cellDimension)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark
        {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }
        else
        {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
