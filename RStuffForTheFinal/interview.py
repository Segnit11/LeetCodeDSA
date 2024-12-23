# Class to represent an individual employee
class Employee:
    def __init__(self, emp_id, name, manager_id):
        self.emp_id = emp_id          # Employee's ID
        self.name = name              # Employee's name
        self.manager_id = manager_id  # Manager's ID
        self.report = []      # List to store employees that report directly to this employee

    # Method to add a direct reporting for the employee
    def add_direct_report(self, employee):
        self.report.append(employee)  # Adds a new direct report to the employee's list


# Class to manage the organization and its employees
class Organization:
    def __init__(self):
        self.employees = {}  # Dictionary to store employees by their emp_id

    # Method to add a new employee to the organization
    def add_employee(self, emp_id, name, manager_id):
        # Create a new Employee object
        new_employee = Employee(emp_id, name, manager_id)
        self.employees[emp_id] = new_employee  # Add the employee to the organization dictionary

        # If the employee has a manager (manager_id != -1), add them to the manager's direct reports list
        if manager_id != -1:
            self.employees[manager_id].add_direct_report(new_employee)

    # Method to remove an employee from the organization
    def remove_employee(self, emp_id):
        # Check if the employee exists in the organization
        emp = self.employees.get(emp_id)
        if not emp:
            return  # If the employee doesn't exist, return without making any changes

        # Remove the employee from their manager's direct reports (if they have a manager)
        if emp.manager_id != -1:
            manager = self.employees.get(emp.manager_id)
            if manager:
                # Filter out the employee from the manager's direct reports list
                manager.report = [e for e in manager.report if e.emp_id != emp_id]

        # Reassign all direct reports to the employee's manager, or set them to have no manager (-1)
        for direct_report in emp.report:
            direct_report.manager_id = emp.manager_id

        # Remove the employee from the organization
        self.employees.pop(emp_id, None)

        # If the employee removed was a top-level manager (manager_id == -1), reassign their direct reports to have no manager
        if emp.manager_id == -1:
            for e in self.employees.values():
                if e.manager_id == emp_id:
                    e.manager_id = -1

    # Method to move an employee to a new manager
    def move_employee(self, emp_id, new_manager_id):
        # Find the employee by their emp_id
        emp = self.employees.get(emp_id)
        if emp:
            # Remove the employee from their current manager's direct reports list
            old_manager = self.employees.get(emp.manager_id)
            if old_manager:
                old_manager.report = [e for e in old_manager.report if e.emp_id != emp_id]

            # Set the employee's new manager
            emp.manager_id = new_manager_id

            # Add the employee to their new manager's direct reports list
            new_manager = self.employees.get(new_manager_id)
            if new_manager:
                new_manager.add_direct_report(emp)

    # Method to count how many employees ultimately report to a given manager (including indirect reports)
    def count_reports(self, manager_id):
        # Recursive helper function to count all direct and indirect reports
        def count_recursive(manager):
            count = len(manager.report)  # Count the direct reports
            for report in manager.report:
                count += count_recursive(report)  # Count indirect reports recursively
            return count
        
        # Find the manager by their emp_id
        manager = self.employees.get(manager_id)
        if manager:
            return count_recursive(manager)  # Return the total count of reports
        return 0  # If the manager does not exist, return 0

    # Method to print the organizational chart in a specific format
    def print_org_chart(self):
        # Recursive helper function to print the organization chart with indentation based on reporting levels
        def print_recursive(employee, level=0):
            print(' ' * (2 * level) + f"{employee.name} [{employee.emp_id}]")  # Print the employee's name and ID
            for report in employee.report:  # Recursively print each direct report
                print_recursive(report, level + 1)  # Increase the level of indentation

        # Iterate over all employees to find top-level employees (manager_id == -1)
        for emp in self.employees.values():
            if emp.manager_id == -1:  # If the employee has no manager (top-level employee)
                print_recursive(emp)  # Print this employee and their subordinates

















# Test case setup
import unittest

class TestOrganization(unittest.TestCase):
    def setUp(self):
        # Create a new organization instance for each test
        self.org = Organization()
        # Add employees to the organization
        self.org.add_employee(1, "Alice", -1)
        self.org.add_employee(2, "Bob", 1)
        self.org.add_employee(3, "Charlie", 1)
        self.org.add_employee(4, "David", 2)
        self.org.add_employee(5, "Eve", 2)

    # Test case for removing an employee with no direct reports
    def test_remove_employee_no_direct_reports(self):
        self.org.remove_employee(5)  # Remove employee 5 (Eve)
        # Check that employee 5 is no longer in the organization
        self.assertNotIn(5, self.org.employees)
        # Check that employee 5 is no longer in Bob's direct reports list
        self.assertNotIn(5, [e.emp_id for e in self.org.employees[2].direct_reports])

    # Test case for removing an employee with direct reports
    def test_remove_employee_with_direct_reports(self):
        self.org.remove_employee(2)  # Remove employee 2 (Bob)
        # Check that employee 2 is no longer in the organization
        self.assertNotIn(2, self.org.employees)
        # Check that employee 2 is no longer in Alice's direct reports list
        self.assertNotIn(2, [e.emp_id for e in self.org.employees[1].direct_reports])
        # Ensure that Bob's direct reports (David and Eve) are now managed by Alice
        self.assertEqual(self.org.employees[4].manager_id, 1)
        self.assertEqual(self.org.employees[5].manager_id, 1)

    # Test case for removing a manager (top-level employee)
    def test_remove_employee_manager(self):
        self.org.remove_employee(1)  # Remove employee 1 (Alice)
        # Check that Alice is no longer in the organization
        self.assertNotIn(1, self.org.employees)
        # Check that Bob and Charlie are now top-level employees (manager_id == -1)
        self.assertEqual(self.org.employees[2].manager_id, -1)
        self.assertEqual(self.org.employees[3].manager_id, -1)

    # Test case for attempting to remove an employee that doesn't exist
    def test_remove_employee_not_exist(self):
        self.org.remove_employee(999)  # Attempt to remove a non-existent employee
        # The number of employees in the organization should remain unchanged
        self.assertEqual(len(self.org.employees), 5)

if __name__ == "__main__":
    unittest.main()  # Run all test cases
