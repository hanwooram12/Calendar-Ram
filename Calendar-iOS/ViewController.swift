//
//  ViewController.swift
//  Calendar-iOS
//
//  Created by 한우람 on 2021/07/09.
//

import UIKit

class CalendarItem {
    var idx = -1
    var date = Date()
    func print() {
        date.print()
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var txtMonth: UILabel!
    
    let itemSpacing: CGFloat = 0.5
    let lineSpacing: CGFloat = 0.5
    
    var current = Date()
    var weekDay = 0
    var lastDay = 0
    var prevLastDay = 0
        
    var items = [CalendarItem]()
    var selectedItem: CalendarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Custom Calendar
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: CollectionDateCell.self), bundle: nil), forCellWithReuseIdentifier: "CollectionDateCell")
        // Custom Calendar 초기 셋팅
        self.initCustomCalendar(date: current)
        
        // FSCalendar
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.borderRadius = 0
        calendar.locale = Locale(identifier: "ko_KR")
    }
    
    /**
     * Custom Calendar 초기 셋팅
     */
    func initCustomCalendar(date: Date) {
        self.current = date
        self.weekDay = date.firstweekday
        self.lastDay = date.lastday
        self.prevLastDay = date.prevlastday
        self.txtMonth.text = self.current.format("yyyy년 MM월")
        self.items.removeAll()
        
        var rowCount = self.lastDay + self.weekDay - 1
        rowCount = (rowCount / 7) + 1
        rowCount = rowCount * 7
        for row in 0..<rowCount {
            var day = row + 1 // 이번달 날짜
            if self.weekDay > 1 {
                day = day - (self.weekDay - 1) // 이번달 날짜
                if row < self.weekDay - 1 {
                    day = self.prevLastDay + day // 이전달 날짜
                }
            }
            var date = self.current
            if row < self.weekDay - 1 {
                date = date.getPrevMonth().set(day: day)
            } else {
                if (self.lastDay < day) {
                    day = day - self.lastDay // 다음달 날짜
                    date = date.getNextMonth().set(day: day)
                } else {
                    date = date.set(day: day)
                }
            }
            let item = CalendarItem()
            item.idx = row
            item.date = date
            self.items.append(item)
        }
        self.collectionView.reloadData()
        
        // FSCalendar 달력 페이지 이동
        self.calendar.setCurrentPage(self.current, animated: true)
    }

    /**
     * 이전 달, 다음 달 이동 액션
     */
    @IBAction func onMonth(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 {
            let date = self.current.getPrevMonth()
            initCustomCalendar(date: date)
        } else {
            let date = self.current.getNextMonth()
            initCustomCalendar(date: date)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionDateCell", for: indexPath) as! CollectionDateCell
        let item = self.items[indexPath.row]
        cell.txtDate.backgroundColor = .clear
        cell.txtDate.text = "\(item.date.day)"
        item.print()
        let minimum = Date().getTomorrow()
        if item.date < minimum {
            cell.isUserInteractionEnabled = false
            if item.date.isToday() {
                cell.txtDate.textColor = .white
                cell.txtDate.backgroundColor = .systemIndigo
            } else {
                cell.txtDate.textColor = .lightGray
            }
        } else {
            let maximum = Date().getNext14Day()
            if item.date > maximum {
                cell.isUserInteractionEnabled = false
                cell.txtDate.textColor = .lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.txtDate.textColor = .darkGray
            }
        }
        if let selectedItem = self.selectedItem {
            if item.date.isEqualTo(selectedItem.date) {
                cell.txtDate.textColor = .white
                cell.txtDate.backgroundColor = .blue
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        item.print()
        self.selectedItem = item
        self.calendar.select(item.date)
        self.collectionView.reloadData()
    }

    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var count = self.lastDay + self.weekDay - 1
        count = (count / 7) + 1
        return CGSize(width: collectionView.frame.width / 7 - self.itemSpacing, height: collectionView.frame.height / CGFloat(count) - self.lineSpacing)
    }
    
    // 좌/우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing
    }
    
    // 위/아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacing
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let item = CalendarItem()
        item.date = date
        item.print()
        self.selectedItem = item
        collectionView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let minimum = Date().getTomorrow()
        // 오늘 날짜로부터 지난 날짜 선택 불가능
        if date < minimum {
            return false
        } else {
            // 오늘 날짜로부터 14일까지 선택 가능
            let maximum = Date().getNext14Day()
            if date > maximum {
                return false
            }
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let minimum = Date().getTomorrow()
        if date < minimum {
            if date.isToday() {
                return UIColor.white
            } else {
                return UIColor.lightGray
            }
        } else {
            let maximum = Date().getNext14Day()
            if date > maximum {
                return UIColor.lightGray
            }
            return UIColor.darkGray
        }
    }
}
