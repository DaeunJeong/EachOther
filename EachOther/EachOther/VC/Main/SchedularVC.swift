//
//  SchedularVC.swift
//  EachOther
//
//  Created by daeun on 19/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseFirestore
import RxSwift
import RxCocoa

class SchedularVC: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    let formatter = DateFormatter()
    var calendarDataSource: [String:String] = [:]
    var db: Firestore!
    let commentString = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendarView()
        calendarView.scrollToDate(Date(),animateScroll:false)
        calendarView.selectDates([Date()])
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        let familyCode = UserDefaults.standard.string(forKey: "FAMILYCODE") ?? ""
        
        db.collection(familyCode).document("schedule").getDocument {[weak self] (querySnapshot, err) in
            guard let strongSelf = self else {return}
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let querySnapshot = querySnapshot {
                    let date = querySnapshot.data()?["date"] as? String ?? ""
                    let comment = querySnapshot.data()?["comment"] as? String ?? ""
                    strongSelf.calendarDataSource[date] = comment
                }
            }
            strongSelf.calendarView.reloadData()
        }
    }
    
    func setUpCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates {(visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard  let validCell = view as? CalendarCell else {return}
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.black
            } else {
                validCell.dateLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {return}
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            let dateString = formatter.string(from: cellState.date)
            if let comment = calendarDataSource[dateString] {
                commentString.accept(comment)
                commentTableView.reloadData()
            } else {
                commentString.accept("")
                commentTableView.reloadData()
            }
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        self.yearMonthLabel.text = formatter.string(from: date)
    }
    
    func handleCellEvents(cell: CalendarCell, cellState: CellState) {
        let dateString = formatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
    }
}

extension SchedularVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension SchedularVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
}

extension SchedularVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        commentString.bind(to: cell.commentLabel.rx.text).dispose()
        return cell
    }
}

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!
}
