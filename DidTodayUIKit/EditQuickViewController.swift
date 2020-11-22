//
//  EditViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/01.
//

import UIKit

class EditQuickViewController: UIViewController, UITextFieldDelegate {

    var viewModel = DidViewModel()
    var delegate: UpdateButtons?
    var id: Int = 0
  
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButton(_ sender: Any) {
        viewModel.removeDaily(id: id)
        viewModel.saveMyButton()
        textField.text = ""
        textField.backgroundColor = viewModel.colours[0]
        doneButton.setTitle("Add".localized, for: .normal)
        deleteButton.isHidden = true
        collectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let subStringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - subStringToReplace.count + string.count
        return count < 11
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        deleteButton.isHidden = true
        id = viewModel.dailys.endIndex - 1
        
//        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)

        collectionView.dataSource = self
        collectionView.delegate = self
        
        textField.layer.cornerRadius = textField.frame.height/2
        textField.textColor = UIColor.darkGray
        textField.tintColor = UIColor.systemPink
        textField.backgroundColor = viewModel.colours[0]
        
        doneButton.setTitle("Add".localized, for: .normal)
        textField.attributedPlaceholder = NSAttributedString(string: "Daily did thing".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        textField.autocorrectionType = .no
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.title = "Edit Daily".localized
        self.navigationController?.navigationBar.tintColor = .systemPink
    }
    

    @objc func back() {
        delegate?.update()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneEdit(_ sender: Any) {
        if textField.text?.isEmpty == false {
            let toAdd = Quick.Daily(title: textField.text!, bgColour: textField.backgroundColor!)
            if id == viewModel.dailys.endIndex - 1 {
                if viewModel.dailys.count == 11 {
                    let alert = UIAlertController(title: "Full your daily.".localized, message: "Sorry, you can add only 10 daily.".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    viewModel.addDaily(daily: toAdd)
                    viewModel.saveMyButton()
                    delegate?.update()
                    dismiss(animated: true, completion: nil)
                }
            } else {
                viewModel.resetButton(about: id, new: toAdd)
                viewModel.saveMyButton()
                delegate?.update()
                dismiss(animated: true, completion: nil)
            }
        } else {
            print("empty")
        }
    }
}

extension EditQuickViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            
            if indexPath.item == viewModel.dailys.count - 1 {
                cell.cellTitle.textColor = .link
                cell.contentView.alpha = 0.5
                
            } else {
                cell.cellTitle.textColor = .darkGray
                cell.contentView.alpha = 1.0
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colourCell", for: indexPath) as! ColourCell
            cell.colourView.backgroundColor = viewModel.colours[indexPath.item]
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
            
            if indexPath.item == viewModel.dailys.count - 1 {
                doneButton.setTitle("Add".localized, for: .normal)
                textField.text = ""
                deleteButton.isHidden = true
                textField.backgroundColor = viewModel.colours[0]
            } else {
                deleteButton.isHidden = false
                doneButton.setTitle("Edit".localized, for: .normal)
                textField.backgroundColor = viewModel.dailys[indexPath.item].bgColour
                print(textField.backgroundColor!)
                print(viewModel.dailys[indexPath.item].bgColour)
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
            textField.backgroundColor = viewModel.colours[indexPath.item]
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
        cellTitle.text = daily.title.localized
        cellBG.layer.cornerRadius = cellBG.bounds.height / 2.3
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

protocol UpdateButtons {
    func update()
}
