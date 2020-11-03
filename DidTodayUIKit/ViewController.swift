//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit

class ViewController: UIViewController {
   
    var viewModel = DidViewModel()
    
    var colours = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemIndigo, UIColor.systemOrange]
    
    @IBOutlet weak var setViewBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonCollection: UICollectionView!
    @IBOutlet weak var tableBG: UIView!
    @IBOutlet weak var setBG: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var whenStarted: UILabel!
    @IBOutlet weak var whenFinished: UILabel!
    @IBOutlet weak var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadToday()
        viewModel.loadMyButton()
        setBoxUI()
        textField.autocorrectionType = .no
        
        
    
        buttonCollection.delegate = self
        buttonCollection.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateTimeUI()
        print(viewModel.dids)
       drawPie()
    }

    func updateTimeUI() {
        whenFinished.text = "\(viewModel.hours):\(viewModel.minutes)"
        if viewModel.dids.count == 0 {
            whenStarted.text = "0:00"
        } else {
            let lastDid = viewModel.dids[viewModel.dids.endIndex-1].finish
            whenStarted.text = lastDid
        }
    }
    
    func setBoxUI() {
        setBG.layer.shadowColor = UIColor.black.cgColor
        setBG.layer.shadowRadius = 5.0
        setBG.layer.shadowOpacity = 0.1
        setBG.layer.cornerRadius =  setBG.bounds.height / 10
    }
    
    func drawPie() {
        let pie = Pie(frame: tableBG.frame)
        pie.center = tableBG.center
        pie.backgroundColor = .clear
        tableBG.addSubview(pie)
        
        pie.layer.shadowColor = UIColor.black.cgColor
        pie.layer.shadowOpacity = 1
        pie.layer.shadowRadius = 5.0
        pie.layer.shadowOffset = .zero
        pie.layer.animationKeys()
        updateTimeUI()
    }
   
    @IBAction func set(_ sender: Any) {
        if textField.text != ""{
            if let thing = textField.text, let starting = whenStarted.text, let finishing = whenFinished.text, let color = colours.randomElement() {
                viewModel.save(did: thing, at: starting, to: finishing, look: color)
                textField.text = ""
                drawPie()
            }
        } else {
            print("Error! Text Field Empty!")
        }
    }
    
    @objc func showEdit(sender:UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
        present(editVC, animated: true, completion: nil)
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dailys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as? QuickCell else {
            return UICollectionViewCell()
        }
        cell.updateCell(daily: viewModel.dailys[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = viewModel.dailys[indexPath.item].title
        let color = viewModel.dailys[indexPath.item].bgColour
        
        if indexPath.item == viewModel.dailys.count - 1{
            let storyboard = UIStoryboard(name: "Edit", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
            let navEditVC = UINavigationController(rootViewController: editVC)
            present(navEditVC, animated: true, completion: nil)
        } else if let starting = self.whenStarted.text, let finishing = self.whenFinished.text {
            viewModel.save(did: title, at: starting, to: finishing, look: color)
            drawPie()
        }
    }
}

extension ViewController {
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


class QuickCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var buttonTitle: UILabel!
    
    func updateCell(daily: Quick.Daily) {
        cellBG.backgroundColor = daily.bgColour
        buttonTitle.text = daily.title
        cellBG.layer.cornerRadius = cellBG.bounds.height*0.5
        
        if cellBG.backgroundColor == UIColor.systemBackground {
            buttonTitle.textColor = UIColor.link
        }
    }
}


