//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, ChangeStartAndEnd, UpdateButtons, UITextFieldDelegate {
    
    func update() {
        print("reload")
        buttonCollection.reloadData()
    }
    
    func change(start: String, end: String) {
        print("change")
        whenStarted.text = start
        whenFinished.text = end
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

    @IBOutlet weak var inputBottomView: NSLayoutConstraint!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count < 20
    }

    var viewModel = DidViewModel()
    var colours = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemIndigo, UIColor.systemOrange]
    
    @IBOutlet weak var timeView: UIVisualEffectView!
    @IBOutlet weak var setDidView: UIVisualEffectView!
    @IBOutlet weak var quickSetView: UIVisualEffectView!
    
    @IBOutlet weak var buttonCollection: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var whenStarted: UILabel!
    @IBOutlet weak var whenFinished: UILabel!
    @IBOutlet weak var setButton: UIButton!
    
    
    
    
    let dataPicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: 280, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.bgView(mainView: self.view)
        viewModel.applyRadius(view: timeView)
        viewModel.applyRadius(view: setDidView)
        viewModel.applyRadius(view: quickSetView)
        self.view.backgroundColor = UIColor.clear
        viewModel.loadToday()
        viewModel.loadMyButton()
        textField.autocorrectionType = .no
        textField.delegate = self
        

        let undoButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(undoDrawPie))
        navigationItem.rightBarButtonItem = undoButton
        
        buttonCollection.delegate = self
        buttonCollection.dataSource = self
        
        dataPicker.preferredDatePickerStyle = .compact
        dataPicker.datePickerMode = .date
        navigationController?.hidesBarsOnTap = true
        self.navigationItem.titleView = dataPicker
        dataPicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        dataPicker.maximumDate = Date()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateTimeUI()
        viewModel.addCircle(navigationController: self.navigationController!, mainView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataPicker.date = Date()
        viewModel.loadToday()
        loadAllPies()
    }

    func updateTimeUI() {
        whenFinished.text = "\(viewModel.hours):\(viewModel.minutes)"
        if viewModel.dids.count == 0 {
            whenStarted.text = "00:00"
        } else {
            let lastDid = viewModel.dids[viewModel.dids.endIndex-1].finish
            whenStarted.text = lastDid
        }
    }
    
    
    @IBAction func showTimeSet(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timeSetVC = storyboard.instantiateViewController(withIdentifier: "SetTimeViewController") as! SetTimeViewController
        timeSetVC.delegate = self
        timeSetVC.modalPresentationStyle = .formSheet
        buttonCollection.reloadData()
        present(timeSetVC, animated: true, completion: nil)
    }
        
    
    func loadAllPies() {
        viewModel.loadPies(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
    
    func drawPie() {
        self.viewModel.addPie(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
   
    @IBAction func set(_ sender: Any) {
        if textField.text!.isEmpty || textField.text!.count > 19 {
            print("check text count")
        } else if let thing = textField.text, let starting = whenStarted.text, let finishing = whenFinished.text, let color = colours.randomElement() {
            viewModel.save(did: thing, at: starting, to: finishing, look: color)
            drawPie()
            textField.text = ""
        }
    }
    
    @objc func showEdit(sender:UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
        present(editVC, animated: true, completion: nil)
    }
    
    @objc func chooseDate() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        performSegue(withIdentifier: "showCalender", sender: self)
    }
    
    @objc func undoDrawPie() {
        if !viewModel.dids.isEmpty {
            self.view.viewWithTag(365)?.removeFromSuperview()
            self.view.viewWithTag(314)?.removeFromSuperview()
            viewModel.undo()
            viewWillAppear(true)
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalender" {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            dateformatter.timeStyle = .none
            let chosed = dataPicker.date
            dateformatter.dateFormat = "yyyyMMdd"
            let dateKey = dateformatter.string(from: dataPicker.date)
            
            let calenderVC = segue.destination as? CalenderViewController
            calenderVC?.update(day: dateKey, title: chosed)
        }
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
        
        if indexPath.item == viewModel.dailys.count - 1 {
            
            let storyboard = UIStoryboard(name: "Edit", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditQuickViewController
            editVC.delegate = self
            let navEditVC = UINavigationController(rootViewController: editVC)
            present(navEditVC, animated: true, completion: nil)
        } else if let starting = self.whenStarted.text, let finishing = self.whenFinished.text{
            viewModel.save(did: title, at: starting, to: finishing, look: color)
            drawPie()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let title = viewModel.dailys[indexPath.item].title
        let color = viewModel.dailys[indexPath.item].bgColour
        
        if indexPath.item != viewModel.dailys.count - 1, let starting = self.whenStarted.text, let finishing = self.whenFinished.text {
            viewModel.save(did: title, at: starting, to: finishing, look: color)
            viewModel.drawPie(navigationController: self.navigationController!, mainView: self.view)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if indexPath.item != viewModel.dailys.count - 1 {
            self.view.viewWithTag(300)?.removeFromSuperview()
            viewModel.undo()
        }
    }
}

extension ViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height
            inputBottomView.constant = adjustmentHeight
        } else {
            inputBottomView.constant = 0
        }
    }
}


class QuickCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var buttonTitle: UILabel!
    
    
    func updateCell(daily: Quick.Daily) {
        cellBG.backgroundColor = daily.bgColour
        buttonTitle.text = daily.title
        cellBG.layer.cornerRadius = cellBG.bounds.height / 2.3
        
    }
}


