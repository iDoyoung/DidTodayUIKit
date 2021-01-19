//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate {
    
    var viewModel = DidViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadToday()
        viewModel.loadSavedDate()
        scrollTopLine.constant = self.view.frame.height/2
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.backgroundColor = UIColor.init(named: "CustomBackColor")
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(undoDrawPie))
        navigationItem.leftBarButtonItem = undoButton
        
        firstTextField.autocorrectionType = .no
        firstTextField.delegate = self
        secondTextField.autocorrectionType = .no
        secondTextField.delegate = self

        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        pageControl.numberOfPages = 2
        
        firstViewLoad()
        secondViewLoad()
        
        stateNavRightItem()
        todayLabel.text = viewModel.todayMonthDay
        
        viewModel.loadToday()
        loadAllPies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataPicker.date = Date()
        viewModel.loadToday()
        secondViewAppear()
    }
    
    @IBOutlet weak var scrollTopLine: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var todayLabel: UILabel!
    
    //MARK: - First Scroll View
    
    @IBOutlet weak var startTimeView: UIVisualEffectView!
    @IBOutlet weak var endTimeView: UIVisualEffectView!
    @IBOutlet weak var setDidView: UIVisualEffectView!
    @IBOutlet weak var quickSetView: UIVisualEffectView!
    @IBOutlet weak var quickSetViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var editButtonView: UIVisualEffectView!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var start = "00:00"
    var end = "00:00"
    var colourSetOfFirst: UIColor = .clear
    
    @IBAction func showEdit(_ sender: UIButton) {
        self.firstTextField.becomeFirstResponder()
        editShow()
        viewModel.navRightButton = true
        stateNavRightItem()
        editButtonView.isHidden = true
    }
    
    @IBAction func upSetButton(_ sender: Any) {
        if firstTextField.text!.isEmpty {
            print("check text count")
        } else if let thing = firstTextField.text {
            let startTimes = viewModel.timeFormat(saved: start)
            let endTimes = viewModel.timeFormat(saved: end)
            if startTimes > endTimes {
                alertSetError()
            } else {
                self.view.viewWithTag(300)?.removeFromSuperview()
                viewModel.undo()
                viewModel.save(did: thing, at: start, to: end, look: colourSetOfFirst, date: viewModel.today)
                completePie()
                firstTextField.text = ""
                colourSetOfFirst = viewModel.colour
                firstCollectionView.reloadData()
            }
            self.view.endEditing(true)
        }
    }
    
    @IBAction func downSetButton(_ sender: Any) {
        colourSetOfFirst = viewModel.colour
        if firstTextField.text!.isEmpty {
            print("check text count")
        } else if let thing = firstTextField.text {
            let startTimes = viewModel.timeFormat(saved: start)
            let endTimes = viewModel.timeFormat(saved: end)
            
            if startTimes > endTimes {
                viewModel.save(did: thing, at: start, to: end, look: colourSetOfFirst, date: viewModel.today)
            } else {
                viewModel.save(did: thing, at: start, to: end, look: colourSetOfFirst, date: viewModel.today)
                viewModel.drawPie(navigationController: self.navigationController, mainView: self.view)
            }
        }
    }
    
    @IBAction func exitSetButton(_ sender: Any) {
        self.view.viewWithTag(300)?.removeFromSuperview()
        if firstTextField.text!.isEmpty == false {
            viewModel.undo()
        }
    }
    
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
    
    let dataPicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: 280, height: 44))

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

    func alertSetError() {
        let alert = UIAlertController(title: "Check setting time".localized, message: "You can't set end time faster than start time.".localized, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default) { (action) in
            self.viewModel.undo()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func firstViewLoad() {
        viewModel.applyRadius(view: startTimeView)
        viewModel.applyRadius(view: endTimeView)
        viewModel.applyRadius(view: setDidView)
        viewModel.applyRadius(view: quickSetView)
        editHidden()
        startTimePicker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        startTimePicker.preferredDatePickerStyle = .inline
        endTimePicker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        endTimePicker.preferredDatePickerStyle = .inline
    }

    //MARK: - Second Scroll View
    
    @IBOutlet weak var countingBG: UIVisualEffectView!
    @IBOutlet weak var secondCollectionBG: UIVisualEffectView!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var secondViewBottomLine: NSLayoutConstraint!
    
    var started = "0"
    var doing = ""
    var colourSetOfSecond: UIColor = .clear
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    @IBAction func starting(_ sender: UIButton) {
        if !secondTextField.text!.isEmpty {
        startCountingUI()
        setDoingView()
        editCancel()
        blurView.isHidden = false
        navigationItem.leftBarButtonItem?.isEnabled = false
            self.view.endEditing(true)
        } else {
            print("empty")
        }
    }
    
    let label = UILabel()
    let infoLabel = UILabel()
    let doingButton = UIButton()
    
    func setDoingView() {
        blurView.frame = self.view.bounds
        label.textAlignment = .center
        if Locale.current.languageCode == "ko" {
            label.text = "\(started)부터 \(doing)..."
        } else {
            label.text = "\(doing) from \(started)...".uppercased()
        }
        label.sizeToFit()
        label.center = blurView.contentView.center
        
        infoLabel.textAlignment = .center
        infoLabel.text = "If you finish, touch screen.".localized
        infoLabel.textColor = UIColor.secondaryLabel
        infoLabel.sizeToFit()
        infoLabel.center = CGPoint(x: label.center.x, y: label.center.y + label.frame.height)
        
        doingButton.frame = blurView.contentView.frame
        doingButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
    }
    
    func startCountingUI() {
        doing = secondTextField.text!
        started = viewModel.dateToString(time: Date())
        viewModel.counting(time: started, doing: doing, paint: colourSetOfSecond)
        secondTextField.text = ""
    }
    

    func actionSheet() {
        let alert = UIAlertController(title: "Are you done?".localized, message: "", preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
            self.startButton.setTitle("Start".localized, for: .normal)
            self.viewModel.done()
            let end = self.viewModel.dateToString(time: Date())
            self.viewModel.save(did: self.doing, at: self.started, to: end, look: self.colourSetOfSecond, date: self.viewModel.today)
            self.completePie()
            self.blurView.isHidden = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        let stopAction = UIAlertAction(title: "Delete".localized, style: .destructive) { (action) in
            self.startButton.setTitle("Start".localized, for: .normal)
            self.viewModel.done()
            self.blurView.isHidden = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)

        alert.addAction(doneAction)
        alert.addAction(stopAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func alertDayOver() {
        let alert = UIAlertController(title: "You did't fisnish last day.".localized, message: "Do you report finishing at 23:59 on last day".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default) { (action) in
            self.started = self.viewModel.startNow[0].startTime
            self.doing = self.viewModel.startNow[0].doing
            self.viewModel.save(did: self.doing, at: self.started, to: "23:59", look: self.viewModel.colour, date: self.viewModel.startNow[0].date)
            self.viewModel.done()
        }
        let cancelAction = UIAlertAction(title: "Delete".localized, style: .destructive) { (action) in
            self.viewModel.done()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
    func secondViewLoad() {
        viewModel.applyRadius(view: countingBG)
        viewModel.applyRadius(view: secondCollectionBG)
        self.view.addSubview(blurView)
        blurView.contentView.addSubview(label)
        blurView.contentView.addSubview(infoLabel)
        blurView.contentView.addSubview(doingButton)
        setDoingView()
        blurView.isHidden = true
        viewModel.loadDoing()
    }
    
    func secondViewAppear() {
        if viewModel.startNow.isEmpty {
            print("Empty")
        } else if viewModel.startNow[0].date != viewModel.today {
            alertDayOver()
        } else {
            started = viewModel.startNow[0].startTime
            doing = viewModel.startNow[0].doing
            blurView.isHidden = false
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
    }

    
    @IBAction func tapPage(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.width, y: 0), animated: true)
    }
    
    func stateNavRightItem() {
        if viewModel.navRightButton == false {
            let calerdarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(chooseDate))
            navigationItem.rightBarButtonItem = calerdarButton
        } else if viewModel.navRightButton == true {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(editCancel))
            navigationItem.rightBarButtonItem = cancelButton
        }
    }
    
    func loadAllPies() {
        viewModel.loadPies(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
    
    func completePie() {
        self.viewModel.addPie(navigationController: self.navigationController!, mainView: self.view)
        updateTimeUI()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count < 20
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - @objc
    
    @objc func showEdit(sender:UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
        present(editVC, animated: true, completion: nil)
    }
    
    @objc func chooseDate() {
        performSegue(withIdentifier: "showCalender", sender: self)
    }
    
    @objc func undoDrawPie() {
        if !viewModel.dids.isEmpty {
            self.view.viewWithTag(365)?.removeFromSuperview()
            self.view.viewWithTag(314)?.removeFromSuperview()
            viewModel.undo()
            loadAllPies()
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
    
    @objc func editCancel() {
        editHidden()
        editButtonView.isHidden = false
        viewModel.navRightButton = false
        stateNavRightItem()
        self.view.endEditing(true)
    }
    
    @objc func stop() {
        actionSheet()
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
        let all = collectionView.visibleCells

        for cell in all {
            cell.contentView.layer.borderWidth = 0
        }
        selected?.contentView.layer.borderWidth = 4
        
        if collectionView == self.firstCollectionView {
            self.colourSetOfFirst = viewModel.colours[indexPath.item]
        } else if collectionView == self.secondCollectionView {
            self.colourSetOfSecond = viewModel.colours[indexPath.item]
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float((scrollView.contentOffset.x) / (scrollView.frame.width))))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

extension ViewController {
    @objc private func adjustInputView(noti: Notification) {

        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            scrollTopLine.constant = 0
            let adjustmentHeight = keyboardFrame.height
            quickSetViewBottom.constant = adjustmentHeight
            secondViewBottomLine.constant = adjustmentHeight
           
        } else {
            scrollTopLine.constant = 0
            quickSetViewBottom.constant = 0
            secondViewBottomLine.constant = 0
          
        }
    }
}

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var colours: UIView!
    
    func updateUI() {
        colours.layer.borderWidth = 1
        colours.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.systemIndigo.withAlphaComponent(0.3).cgColor
        contentView.layer.cornerRadius = contentView.frame.width / 5
    }
}
