//
//  EditViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/01.
//

import UIKit

class EditViewController: UIViewController {

    var dailys = Quick.shared.dailys
    let colours: [UIColor] = [#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colourSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
}

extension EditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return dailys.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCell", for: indexPath) as! EditCell
        cell.updateCell(daily: dailys[indexPath.item])
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colourCell", for: indexPath) as! ColourCell
            cell.cellBG.backgroundColor = colours[indexPath.item]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            
        }
    }
    
}


class EditCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    
    func updateCell(daily: Quick.Daily) {
        cellBG.backgroundColor = daily.bgClour
        cellTitle.text = daily.title
        cellBG.layer.cornerRadius = cellBG.bounds.height / 2
        
        if cellTitle.text == "Add" {
            cellBG.layer.borderWidth = 3
            cellBG.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
}

class ColourCell: UICollectionViewCell {
    @IBOutlet weak var cellBG: UIView!
}
