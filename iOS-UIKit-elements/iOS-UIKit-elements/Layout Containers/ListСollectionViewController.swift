//
//  ListСollectionViewController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 8.03.22.
//
// Based on example from Apple
// https://developer.apple.com/tutorials/app-dev-training/creating-a-list-view

import Foundation
import UIKit

class ListСollectionViewController: UICollectionViewController {
    private lazy var dataSource = makeDataSource()
    private var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = listLayout()
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

extension ListСollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .green
        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
        cell.accessibilityValue = reminder.isComplete ? "Completed" : "Not completed"
        cell.accessories = [.customView(configuration: doneButtonConfiguration)]
        
        let backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    private func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let action = UIAccessibilityCustomAction(name: "Toggle completion") { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "checkmark.circle" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    private func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    private func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
}

extension ListСollectionViewController {
    @objc private func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}

fileprivate struct Reminder: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

#if DEBUG
extension Reminder {
    static var sampleData = [
        Reminder(title: "Submit reimbursement report", dueDate: Date().addingTimeInterval(800.0), notes: "Don't forget about taxi receipts"),
        Reminder(title: "Code review", dueDate: Date().addingTimeInterval(14000.0), notes: "Check tech specs in shared folder", isComplete: true),
        Reminder(title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0), notes: "Optometrist closes at 6:00PM"),
        Reminder(title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0), notes: "Collaborate with project manager", isComplete: true),
        Reminder(title: "Interview new project manager candidate", dueDate: Date().addingTimeInterval(60000.0), notes: "Review portfolio"),
        Reminder(title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0), notes: "Think different"),
        Reminder(title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0), notes: "Discuss trends with management"),
        Reminder(title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0), notes: "Ask about space heaters"),
        Reminder(title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),  notes: "v0.9 out on Friday")
    ]
}
#endif

extension Date {
    fileprivate var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
}

extension Array where Element == Reminder {
    fileprivate func indexOfReminder(with id: Reminder.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

fileprivate class ReminderDoneButton: UIButton {
    var id: Reminder.ID?
}
