//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import CoreData
class SearchViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var searchFilter: SearchFilter? {
        didSet {
            fetchWeatherHistory()
        }
    }
    
    
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchResultsController: NSFetchedResultsController<SavedWeather>?
    
    
    var weatherHistory: [SavedWeather]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        if let context = container?.viewContext {
//
//            let request: NSFetchRequest<SavedWeather> = SavedWeather.fetchRequest()
//            request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
//            fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        }
//        fetchResultsController?.delegate = self
//
//        do {
//            try fetchResultsController?.performFetch()
//            tableView.reloadData()
//        } catch {
//            print(error)
//        }
        
        fetchWeatherHistory()
        
    }

    
    
    func fetchWeatherHistory() {
        
        if let context = container?.viewContext {
            
            let request: NSFetchRequest<SavedWeather> = SavedWeather.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            if searchFilter != nil {
                buildRequestPredicate(for: request)
            } 
            
            fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        fetchResultsController?.delegate = self
        
        do {
            try fetchResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print(error)
        }
        
        
        
    }
    
    
    func buildRequestPredicate(for request: NSFetchRequest<SavedWeather>) {
        var predicates: [NSPredicate] = []
        let filter = searchFilter!
        
        if filter.usedOptions.contains(.byCityName) {
            let predicate = NSPredicate(format: "city = %@", filter.cityKeyword!)
            predicates.append(predicate)
        } else if filter.usedOptions.contains(.byKeywords) { // doesn't work!!!
            let predicate = NSPredicate(format: "weatherKeyword = %@", argumentArray: filter.keywords!)
            predicates.append(predicate)
        } else if filter.usedOptions.contains(.bySingleDate) {
            let filteringDate = (filter.startDate == nil ? filter.endDate! : filter.startDate!)
            let predicate = NSPredicate(format: "date == %@", filteringDate as NSDate)
            predicates.append(predicate)
        } else if filter.usedOptions.contains(.byDates) {
            let fromPredicate = NSPredicate(format: "date >= %@", filter.startDate! as NSDate)
            let toPredicate = NSPredicate(format: "date <= %@", filter.endDate! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            predicates.append(datePredicate)
        }
        
        
        
        
        
        
        
//
//
//        switch filter.usedOptions {
//        case FilterOptions.byCityName:
//            let predicate = NSPredicate(format: "city = %@", filter.cityKeyword!)
//            predicates.append(predicate)
//        case FilterOptions.byKeywords:
//            let predicate = NSPredicate(format: "weatherKeyword = %@", argumentArray: filter.keywords!)
//            predicates.append(predicate)
//        case FilterOptions.bySingleDate:
//            let filteringDate = (filter.startDate == nil ? filter.endDate! : filter.startDate!)
//            let predicate = NSPredicate(format: "date == %@", filteringDate as NSDate)
//            predicates.append(predicate)
//        case FilterOptions.byDates:
//            let fromPredicate = NSPredicate(format: "date >= %@", filter.startDate! as NSDate)
//            let toPredicate = NSPredicate(format: "date <= %@", filter.endDate! as NSDate)
//            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
//            predicates.append(datePredicate)
//        default: break
//        }
        let resultingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = resultingPredicate
    
    }
    
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        print("UnwindSegue")
        print(searchFilter!)
    }
    
    

    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       

        if let savedWeather = fetchResultsController?.object(at: indexPath) {
            cell.textLabel?.text = savedWeather.city
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyy"
            cell.detailTextLabel?.text = dateFormatter.string(from: savedWeather.date!)

        }
        
        
        return cell
    }
    

    

}
