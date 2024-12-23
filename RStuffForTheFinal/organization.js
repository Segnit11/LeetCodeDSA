// Class to represent an individual employee
class Employee {
    constructor(emp_id, name, manager_id) {
        this.emp_id = emp_id;        // Employee's ID
        this.name = name;            // Employee's name
        this.manager_id = manager_id; // Manager's ID
        this.report = [];            // List to store employees that report directly to this employee
    }

    // Method to add a direct report to the employee
    addDirectReport(employee) {
        this.report.push(employee); // Adds a new direct report to the employee's list
    }
}

// Class to manage the organization and its employees
class Organization {
    constructor() {
        this.employees = {}; // Dictionary to store employees by their emp_id
    }

    // Method to add a new employee to the organization
    addEmployee(emp_id, name, manager_id) {
        const newEmployee = new Employee(emp_id, name, manager_id);
        this.employees[emp_id] = newEmployee; // Add the employee to the organization dictionary

        // If the employee has a manager (manager_id != -1), add them to the manager's direct reports list
        if (manager_id !== -1) {
            this.employees[manager_id]?.addDirectReport(newEmployee);
        }
    }

    // Method to remove an employee from the organization
    removeEmployee(emp_id) {
        const emp = this.employees[emp_id];
        if (!emp) return; // If the employee doesn't exist, return

        // Remove the employee from their manager's direct reports (if they have a manager)
        if (emp.manager_id !== -1) {
            const manager = this.employees[emp.manager_id];
            if (manager) {
                manager.report = manager.report.filter(e => e.emp_id !== emp_id);
            }
        }

        // Reassign all direct reports to the employee's manager or set them to have no manager (-1)
        emp.report.forEach(directReport => {
            directReport.manager_id = emp.manager_id;
            if (emp.manager_id !== -1) {
                this.employees[emp.manager_id]?.addDirectReport(directReport);
            }
        });

        // Remove the employee from the organization
        delete this.employees[emp_id];

        // If the employee was a top-level manager, reassign their direct reports to have no manager
        if (emp.manager_id === -1) {
            Object.values(this.employees).forEach(e => {
                if (e.manager_id === emp_id) {
                    e.manager_id = -1;
                }
            });
        }
    }

    // Method to move an employee to a new manager
    moveEmployee(emp_id, new_manager_id) {
        const emp = this.employees[emp_id];
        if (emp) {
            // Remove the employee from their current manager's direct reports list
            const oldManager = this.employees[emp.manager_id];
            if (oldManager) {
                oldManager.report = oldManager.report.filter(e => e.emp_id !== emp_id);
            }

            // Set the employee's new manager
            emp.manager_id = new_manager_id;

            // Add the employee to their new manager's direct reports list
            const newManager = this.employees[new_manager_id];
            if (newManager) {
                newManager.addDirectReport(emp);
            }
        }
    }

    // Method to count how many employees ultimately report to a given manager
    countReports(manager_id) {
        const countRecursive = manager => {
            let count = manager.report.length; // Count the direct reports
            manager.report.forEach(report => {
                count += countRecursive(report); // Count indirect reports recursively
            });
            return count;
        };

        const manager = this.employees[manager_id];
        return manager ? countRecursive(manager) : 0;
    }

    // Method to print the organizational chart in a specific format
    printOrgChart() {
        const printRecursive = (employee, level = 0) => {
            console.log(' '.repeat(2 * level) + `${employee.name} [${employee.emp_id}]`); // Print the employee's name and ID
            employee.report.forEach(report => {
                printRecursive(report, level + 1); // Recursively print each direct report
            });
        };

        Object.values(this.employees).forEach(emp => {
            if (emp.manager_id === -1) { // If the employee has no manager (top-level employee)
                printRecursive(emp); // Print this employee and their subordinates
            }
        });
    }
}







// Example Usage
const org = new Organization();
org.addEmployee(1, "Alice", -1); // Top-level manager
org.addEmployee(2, "Bob", 1);
org.addEmployee(3, "Charlie", 1);
org.addEmployee(4, "Dave", 2);

org.printOrgChart();
