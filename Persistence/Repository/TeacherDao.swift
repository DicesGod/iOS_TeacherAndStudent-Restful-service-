import UIKit
import CoreData

class TeacherDao {
    let appDelegate: AppDelegate!
    
    init(withAppDelegate delegate: AppDelegate) {
        self.appDelegate = delegate
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    func getTeachers(withAttributeName attributeName: String, andAttributeValue attributeValue: String) -> [Teacher]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")
            fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %@", attributeValue)
            do {
                return try context.fetch(fetchRequest) as? [Teacher]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func getTeacher(withTId tId: String) -> Teacher? {
        if let teachers = getTeachers(withAttributeName: "tId", andAttributeValue: tId) {
            if teachers.count > 1 {
                print("[WARNING] More than one teacher is registered with tId=\(tId)!")
            }
            return teachers.first
        } else {
            print("[ERROR] Teacher with tId=\(tId) does not exist!")
            return nil
        }
    }
    
    func getAllTeachers() -> [Teacher]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")
            do {
                return try context.fetch(fetchRequest) as? [Teacher]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func saveTeacher(withTeacherForm teacherForm: TeacherForm) -> Bool {
        if let existing = getTeacher(withTId: teacherForm.tId) {
            print("[ERROR] Teacher with tId=\(existing.tId ?? "N/A") already exists!")
            return false
        }
        if let context = getManagedContext() {
            let teacher = Teacher(context: context)
            teacher.tId = teacherForm.tId
            teacher.name = teacherForm.name
            teacher.password = teacherForm.password
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
    
    func removeTeacher(withTId tId: String) -> Bool {
        if let existing = getTeacher(withTId: tId) {
            if let context = getManagedContext() {
                context.delete(existing)
                return true
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] Teacher with tId=\(tId) does not exist!")
            return false
        }
    }
    
    func assignCourse(withCsId csId: String, toTeacher teacher: Teacher, saveReverse: Bool = true) -> Bool {
        if let course = courseDao?.getCourse(withCsId: csId) {
            if let teacherCourses = teacher.teachesCourses {
                for cs in teacherCourses {
                    if (cs as! Course).csId == course.csId {
                        print("[ERROR] Teacher is already teaching this course!")
                        return false
                    }
                }
            }
            teacher.addToTeachesCourses(course)
            if saveReverse {
                course.taughtByTeacher = teacher
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
