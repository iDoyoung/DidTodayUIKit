//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate {
    //TODO: if endtime > startTime , when change date still run timer
    var viewModel = DidViewModel()
    
    @IBOutlet weak var scrollTopLine: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    //MARK: - First Scroll View
    var start = "00:00"
    var end = "00:00"
    var colour: UIColor = UIColor.systemGray
    
    func update() {
        firstCollectionView.reloadData()
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
   }
    
    @IBAction func showEdit(_ sender: Any) {
        self.firstTextField.becomeFirstResponder()
        editShow()
        editButtonView.isHidden = true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count < 20
    }

    @IBOutlet weak var startTimeView: UIVisualEffectView!
    @IBOutlet weak var startTimeViewBottom: NSLayoutConstraint!
    @IBOutlet weak var endTimeView: UIVisualEffectView!
    @IBOutlet weak var endTimeViewBottom: NSLayoutConstraint!
    @IBOutlet weak var setDidView: UIVisualEffectView!
    @IBOutlet weak var setDidViewBottom: NSLayoutConstraint!
    @IBOutlet weak var quickSetView: UIVisualEffectView!
    @IBOutlet weak var quickSetViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var editButtonView: UIVisualEffectView!
    

    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    func editHidden() {
        startTimeView.isHidden = true
        endTimeView.isHidden = true
        setDidView.isHidden = true
        quickSetView.isHidden = true
    }
    
    func editShow() {
        startTimeView.isHidden = false
        endTimeView.isHidden = false
        setDidView.isHidden = false
        quickSetView.isHidden = false
    }
    
    //MARK: - Second Scroll View
    var started = "0"
    var doing = ""
    var timer: Timer?
    
    @IBOutlet weak var countingBG: UIVisualEffectView!
    @IBOutlet weak var secondCollectionBG: UIVisualEffectView!
    @IBOutlet weak var timeCountBG: UIView!
    
    
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var startingTime: UILabel!
    @IBOutlet weak var doneTime: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var proceedingView1: UIView!
    @IBOutlet weak var proceedingView2: UIView!
    @IBOutlet weak var proceedingView3: UIView!
    
    
    @IBAction func starting(_ sender: UIButton) {
            if sender.currentTitle == "Start", !secondTextField.text!.isEmpty {
                sender.setTitle("Done", for: .normal)
                prceedingViewUI()
                doing = secondTextField.text!
                startCountingUI()
            } else if sender.currentTitle == "Done" {
                actionSheet()
            } else {
                print("Error")
            }
        loadingAnimation()
    }
    
    func startCountingUI() {
        started = viewModel.dateToString(time: Date())
        viewModel.counting(time: started, doing: doing)
        secondTextField.text = ""
        secondTextField.isHidden = true
        timeCountBG.isHidden = false
        doneTime.text = viewModel.dateToString(time: Date())
    }
    
    func prceedingViewUI() {
        if viewModel.startNow.isEmpty {
            proceedingView1.isHidden = false
            proceedingView2.isHidden = false
            proceedingView3.isHidden = false
            loadingAnimation()
        } else {
            proceedingView1.isHidden = true
            proceedingView2.isHidden = true
            proceedingView3.isHidden = true
            timer?.invalidate()
        }
    }
    
    
    func loadingAnimation() {
        if !timeCountBG.isHidden {
            timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { (_) in
                self.animateLoadingDots()
            }
        } else {
            self.timer?.invalidate()
        }
    }
    
    func animateLoadingDots() {
        UIView.animate(withDuration: 1.2, delay: 0) {
            self.proceedingView1.frame.origin.y = self.proceedingView1.frame.origin.y - 8
            
        } completion: { (complete) in
            if complete {
                UIView.animate(withDuration: 1.2) {
                    self.proceedingView1.frame.origin.y += 8
                }
            }
        }
        
        UIView.animate(withDuration: 1.2, delay: 0.4) {
            self.proceedingView2.frame.origin.y = self.proceedingView2.frame.origin.y - 8
        } completion: { (complete) in
            if complete {
                UIView.animate(withDuration: 1.2) {
                    self.proceedingView2.frame.origin.y += 8
                }
            }
        }
        
        
        UIView.animate(withDuration: 1.2, delay: 0.8) {
            self.proceedingView3.frame.origin.y = self.proceedingView3.frame.origin.y - 8
        } completion: { (complete) in
            if complete {
                UIView.animate(withDuration: 1.2) {
                    self.proceedingView3.frame.origin.y += 8
                }
            }
        }
    }
    
    func actionSheet() {
        let alert = UIAlertController(title: "Are you done?", message: "", preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.startButton.setTitle("Start", for: .normal)
            self.viewModel.done()
            self.timeCountBG.isHidden = true
            let end = self.viewModel.dateToString(time: Date())
            self.secondTextField.isHidden = false
            self.viewModel.save(did: self.doing, at: self.started, to: end, look: self.viewModel.colour)
            self.viewWillAppear(true)
            
        }
        
        let stopAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.timeCountBG.isHidden = true
            self.startButton.setTitle("Start", for: .normal)
            self.viewModel.done()
            self.viewWillAppear(true)
            self.secondTextField.isHidden = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(doneAction)
        alert.addAction(stopAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func secondViewLoad() {
        proceedingView1.layer.cornerRadius = proceedingView1.frame.height / 2
        proceedingView2.layer.cornerRadius = proceedingView2.frame.height / 2
        proceedingView3.layer.cornerRadius = proceedingView3.frame.height / 2
        viewModel.applyRadius(view: countingBG)
        viewModel.applyRadius(view: secondCollectionBG)
    }
    
    func secondViewAppear() {
        viewModel.doing()
        if viewModel.startNow.isEmpty {
            startingTime.text = viewModel.dateToString(time: Date())
            timeCountBG.isHidden = true
            startButton.setTitle("Start", for: .normal)
        } else {
            started = viewModel.startNow[0]
            doing = viewModel.startNow[1]
            startingTime.text = started
            timeCountBG.isHidden = false
            doneTime.text = viewModel.dateToString(time: Date())
            startButton.setTitle("Done", for: .normal)
            secondTextField.isHidden = true
        }
        loadingAnimation()
    }

    ////////////////////////////////////////
    let dataPicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: 280, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editHidden()
        scrollTopLine.constant = self.view.frame.height/2
        
        secondViewLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        startTimePicker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        startTimePicker.preferredDatePickerStyle = .inline
        
        endTimePicker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        endTimePicker.preferredDatePickerStyle = .inline
        
        //viewModel.bgView(mainView: self.view)
        self.view.backgroundColor = UIColor.init(named: "CustomBackColor")
        viewModel.applyRadius(view: startTimeView)
        viewModel.applyRadius(view: endTimeView)
        viewModel.applyRadius(view: setDidView)
        viewModel.applyRadius(view: quickSetView)

        
        viewModel.loadToday()
//        viewModel.loadMyButton()
        firstTextField.autocorrectionType = .no
        firstTextField.delegate = self
        

        let undoButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(undoDrawPie))
        navigationItem.leftBarButtonItem = undoButton
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        
        secondCollectionView.dataSource = self
        
        dataPicker.preferredDatePickerStyle = .compact
        dataPicker.datePickerMode = .date
        self.navigationItem.titleView = dataPicker
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        dataPicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        dataPicker.maximumDate = Date()
        viewModel.addCircle(navigationController: self.navigationController!, mainView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataPicker.date = Date()
        viewModel.loadToday()
        loadAllPies()
        secondViewAppear()
    }

    func updateTimeUI() {
        if viewModel.dids.count == 0 {
            start = "00:00"
        } else {
            let lastDid = viewModel.dids[viewModel.dids.endIndex-1].finish
            start = lastDid
        }
        startTimePicker.setDate(viewModel.stringToDate(date: start), animated: false)
        endTimePicker.setDate(Date(), animated: false)
        end = viewModel.now
    }
            
    func loadAllPies() {
        viewModel.loadPies(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
    
    func completePie() {
        self.viewModel.addPie(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
   

    @IBAction func upSetButton(_ sender: Any) {
        if firstTextField.text!.isEmpty || firstTextField.text!.count > 19 {
            print("check text count")
        } else if let thing = firstTextField.text {
            self.view.viewWithTag(300)?.removeFromSuperview()
            viewModel.undo()
            viewModel.save(did: thing, at: start, to: end, look: colour)
            completePie()
            firstTextField.text = ""
        }
    }
    
    
    @IBAction func downSetButton(_ sender: Any) {
        if firstTextField.text!.isEmpty || firstTextField.text!.count > 19 {
            print("check text count")
        } else if let thing = firstTextField.text{
            viewModel.save(did: thing, at: start, to: end, look: colour)
            viewModel.drawPie(navigationController: self.navigationController, mainView: self.view)
        }
    }
    
    @IBAction func cancelSetButton(_ sender: Any) {
        self.view.viewWithTag(300)?.removeFromSuperview()
        viewModel.undo()
    }
    
    @IBAction func exitSetButton(_ sender: Any) {
        self.view.viewWithTag(300)?.removeFromSuperview()
        viewModel.undo()
        
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
    
    @objc func setTime(_ picker: UIDatePicker) {
        if picker == startTimePicker {
        start = viewModel.dateToString(time: picker.date)
            print(start)
            
        } else {
            end = viewModel.dateToString(time: picker.date)
            print(end)
        }
    }

    @objc func cancel() {
        editHidden()
        editButtonView.isHidden = false
        colour = viewModel.colour
        
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
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstTextField {
            self.view.endEditing(true)
        }
        return true
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.updateUI()
        cell.colours.backgroundColor = viewModel.colours[indexPath.item]
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = collectionView.cellForItem(at: indexPath)
//        let all = collectionView.visibleCells
//        
//        for cell in all {
//            cell.contentView.layer.borderWidth = 0
//        }
        selected?.contentView.layer.borderWidth = 4
        
        self.colour = viewModel.colours[indexPath.item]
    }
}



extension ViewController {
    @objc private func adjustInputView(noti: Notification) {

        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            scrollTopLine.constant = 60
            let adjustmentHeight = keyboardFrame.height
            quickSetViewBottom.constant = adjustmentHeight
            setDidViewBottom.constant = quickSetViewBottom.constant + quickSetView.frame.height + 8
            endTimeViewBottom.constant = setDidViewBottom.constant + setDidView.frame.height + 8
            startTimeViewBottom.constant = endTimeViewBottom.constant + endTimeView.frame.height + 8
        } else {
            //scrollTopLine.constant = self.view.frame.height/2
            quickSetViewBottom.constant = 0
            setDidViewBottom.constant = quickSetViewBottom.constant + quickSetView.frame.height + 8
            endTimeViewBottom.constant = setDidViewBottom.constant + setDidView.frame.height + 8
            startTimeViewBottom.constant = endTimeViewBottom.constant + endTimeView.frame.height + 8
        }
    }
}

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colours: UIView!
    

    func updateUI() {
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.cornerRadius = contentView.frame.width / 5
    }
    
}
