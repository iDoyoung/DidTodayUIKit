//
//  EditViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/01.
//

import UIKit

class EditViewController: UIViewController {

    var viewModel = DidViewModel()
    var id: Int = 0
    let colours: [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPink, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemPurple, UIColor.systemIndigo, UIColor.label]
    
    @IBOutlet weak var setViewBottom: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    // 글자수 제한, 버튼 enable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        
        id = viewModel.dailys.endIndex
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        textField.layer.cornerRadius = textField.frame.height/2
        textField.textColor = UIColor.systemBackground
        textField.tintColor = UIColor.systemBackground
        textField.backgroundColor = UIColor.systemPink
        
        doneButton.setTitle("Add", for: .normal)
        textField.attributedPlaceholder = NSAttributedString(string: "Daily did thing", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
        
        textField.autocorrectionType = .no
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.title = "Edit Daily"
        self.navigationController?.navigationBar.tintColor = .systemPink
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneEdit(_ sender: Any) {
        let toAdd = Quick.Daily(title: textField.text!, bgColour: textField.backgroundColor!)
        
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: "Please fill text!!", attributes: [NSAttributedString.Key.font: UIFont.Weight.bold])
            
        } else {
            
            if id == viewModel.dailys.endIndex {
                viewModel.addDaily(daily: toAdd)
            } else {
                viewModel.resetButton(about: id, new: toAdd)
            }
            viewModel.saveMyButton()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.dailys.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCell", for: indexPath) as! EditCell
        
            cell.updateCell(daily: viewModel.dailys[indexPath.item])
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colourCell", for: indexPath) as! ColourCell
            cell.colourView.backgroundColor = colours[indexPath.item]
            cell.colourPickUI()
            if textField.backgroundColor == cell.colourView.backgroundColor {
                cell.contentView.layer.borderWidth = 4
            } else {
                cell.contentView.layer.borderWidth = 0
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            textField.text = viewModel.dailys[indexPath.item].title
            
            if textField.text == "Add" {
                doneButton.setTitle("Add", for: .normal)
                textField.text = ""
            } else {
                doneButton.setTitle("Edit", for: .normal)
                textField.backgroundColor = viewModel.dailys[indexPath.item].bgColour
            }
            
            let selected = collectionView.cellForItem(at: indexPath)
            let all = collectionView.visibleCells
            for cell in all {
                cell.contentView.alpha = 1.0
               
                selected?.contentView.alpha = 0.5
            }
            let indexSet = IndexSet(integer: 1)
            self.collectionView.reloadSections(indexSet)
            
            id = indexPath.item
        } else {
            textField.backgroundColor = colours[indexPath.item]
            let selected = collectionView.cellForItem(at: indexPath)
            let all = collectionView.visibleCells
            
            for cell in all {
                cell.contentView.layer.borderWidth = 0
                selected?.contentView.layer.borderWidth = 4
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}



class EditCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    
    func updateCell(daily: Quick.Daily) {
        cellBG.backgroundColor = daily.bgColour
        cellTitle.text = daily.title
        if cellTitle.text == "Add" {
            cellTitle.textColor = .link
        }
        cellBG.layer.cornerRadius = cellBG.bounds.height / 2
        
    }
}
//확장 만들기
extension EditViewController {
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            setViewBottom.constant = adjustmentHeight
        } else {
            setViewBottom.constant = 0
        }
    }
    
}
class ColourCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    
    @IBOutlet weak var colourView: UIView!
    
    func colourPickUI() {
        cellBG.layer.cornerRadius = cellBG.frame.width * 0.5
        cellBG.layer.borderColor = UIColor.systemGray5.cgColor
        colourView.layer.cornerRadius = colourView.frame.width * 0.5
    }
}

