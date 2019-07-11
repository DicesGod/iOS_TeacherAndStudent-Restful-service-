import UIKit
import CoreData

class StudentDao {
    let appDelegate: AppDelegate!
    
    init(withAppDelegate delegate: AppDelegate) {
        self.appDelegate = delegate
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    func getStudents(withAttributeName attributeName: String, andAttributeValue attributeValue: String) -> [Student]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %@", attributeValue)
            do {
                return try context.fetch(fetchRequest) as? [Student]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func getStudent(withStId stId: String) -> Student? {
        if let students = getStudents(withAttributeName: "stId", andAttributeValue: stId) {
            if students.count > 1 {
                print("[WARNING] More than one student is registered with stId=\(stId)!")
            }
            return students.first
        } else {
            print("[ERROR] Student with stId=\(stId) does not exist!")
            return nil
        }
    }
    
    func getAllStudents() -> [Student]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            do {
                return try context.fetch(fetchRequest) as? [Student]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func saveStudent(withStudentForm studentForm: StudentForm) -> Bool {
        if let existing = getStudent(withStId: studentForm.stId) {
            print("[ERROR] Student with stId=\(existing.stId ?? "N/A") already exists!")
            return false
        }
        if let context = getManagedContext() {
            let student = Student(context: context)
            student.stId = studentForm.stId
            student.name = studentForm.name
            student.semester = studentForm.semester
            student.password = studentForm.password
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
    
    func removeStudent(withStId stId: String) -> Bool {
        if let existing = getStudent(withStId: stId) {
            if let context = getManagedContext() {
                context.delete(existing)
                return true
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] Student with stId=\(stId) does not exist!")
            return false
        }
    }
    
    func assignCourse(withCsId csId: String, toStudent student: Student, saveReverse: Bool = true) -> Bool {
        if let course = courseDao?.getCourse(withCsId: csId) {
            if let studentCourses = student.takesCourses {
                for cs in studentCourses {
                    if (cs as! Course).csId == course.csId {
                        print("[ERROR] Student is already taking this course!")
                        return false
                    }
                }
            }
            student.addToTakesCourses(course)
            if saveReverse {
                course.addToTakenByStudents(student)
            }
            if let context = getManagedContext() {
                do {
                    try context.save()
                    return true
                } catch {
                    print("[ERROR] Cannot save to CoreData!")
                    return false
                }
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] Cannot find course with csId=\(csId)!")
            return false
        }
    }
    
    func removeCourse(withCsId csId: String, forStudent student: Student, removeReverse: Bool = true) -> Bool {
        if let course = courseDao?.getCourse(withCsId: csId) {
            if let studentCourses = student.takesCourses {
                for cs in studentCourses {
                    if (cs as! Course).csId == course.csId {
                        student.removeFromTakesCourses(course)
                        return true
                    }
                    print("[ERROR] Student is not taking this course!")
                    return false
                }
            }
            if removeReverse {
                course.removeFromTakenByStudents(student)
            }
            if let context = getManagedContext() {
                do {
                    try context.save()
                    return true
                } catch {
                    print("[ERROR] Cannot save to CoreData!")
                    return false
                }
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] Cannot find course with csId=\(csId)!")
            return false
        }
    }
}
