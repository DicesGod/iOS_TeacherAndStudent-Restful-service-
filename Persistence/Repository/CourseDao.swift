import UIKit
import CoreData

class CourseDao {
    let appDelegate: AppDelegate!
    
    init(withAppDelegate delegate: AppDelegate) {
        self.appDelegate = delegate
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    //get course with conditions
    func getCourses(withAttributeName attributeName: String, andAttributeValue attributeValue: String) -> [Course]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
            //Conditions
            fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %@", attributeValue)
            do {
                return try context.fetch(fetchRequest) as? [Course]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func getCourse(withCsId csId: String) -> Course? {
        if let courses = getCourses(withAttributeName: "csId", andAttributeValue: csId) {
            if courses.count > 1 {
                print("[WARNING] More than one course is registered with csId=\(csId)!")
            }
            return courses.first
        } else {
            print("[ERROR] Course with csId=\(csId) does not exist!")
            return nil
        }
    }
    
    
    func getAllCourses() -> [Course]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
            do {
                return try context.fetch(fetchRequest) as? [Course]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func saveCourse(withCourseForm courseForm: CourseForm) -> Bool {
        if let existing = getCourse(withCsId: courseForm.csId) {
            print("[ERROR] Course with csId=\(existing.csId ?? "N/A") already exists!")
            return false
        }
        if let context = getManagedContext() {
            let course = Course(context: context)
            course.csId = courseForm.csId
            course.title = courseForm.title
            course.credit = courseForm.credit
            course.semester = courseForm.semester
            do {
                try context.save()
                return true
            } catch {
                print("[ERROR] Cannot save to CoreData!")
                return false
            }
        }  else {
            print("[ERROR] Cannot communicate with CoreData!")
            return false
        }
    }
    
    func removeCourse(withCsId csId: String) -> Bool {
        if let existing = getCourse(withCsId: csId) {
            if let context = getManagedContext() {
                context.delete(existing)
                return true
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] Course with csId=\(csId) does not exist!")
            return false
        }
    }
}
