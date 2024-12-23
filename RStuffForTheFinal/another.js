class Employee {
    constructor(id, name, managerId = null) {
        this.id = id;
        this.name = name;
        this.managerId = managerId;
        this.reports = []; // Direct reports
    }
}

let orgChart = new Map();

/**
 * @param {String} employeeId
 * @param {String} name
 * @param {String} managerId
 */
function add(employeeId, name, managerId) {
    // Check if employee already exists
    if (orgChart.has(employeeId)) return;

    // Create a new employee
    const newEmployee = new Employee(employeeId, name, managerId);

    // Add the employee to the org chart
    orgChart.set(employeeId, newEmployee);

    // If the manager exists, add this employee to their reports
    if (managerId && orgChart.has(managerId)) {
        orgChart.get(managerId).reports.push(newEmployee);
    }
}

/**
 * @param {String} employeeId
 * @param {String} newManagerId
 */
function move(employeeId, newManagerId) {
    // Check if both employee and new manager exist
    if (!orgChart.has(employeeId) || !orgChart.has(newManagerId)) return;

    const employee = orgChart.get(employeeId);
    const oldManager = orgChart.get(employee.managerId);
    const newManager = orgChart.get(newManagerId);

    // Remove employee from the old manager's reports, if applicable
    if (oldManager) {
        oldManager.reports = oldManager.reports.filter((e) => e.id !== employeeId);
    }

    // Update the manager ID for the employee
    employee.managerId = newManagerId;

    // Add employee to the new manager's reports
    newManager.reports.push(employee);
}

/**
 * Return the count, don't worry about writing the value to console
 * @param {String} employeeId
 * @returns {Int} number of employees that report up to a given employee
 */
function count(employeeId) {
    if (!orgChart.has(employeeId)) return 0;

    const employee = orgChart.get(employeeId);

    // Helper function to recursively count all reports
    function countReports(emp) {
        return emp.reports.reduce((acc, report) => acc + 1 + countReports(report), 0);
    }

    return countReports(employee);
}

/**
 * @param {String} employeeId
 */
function remove(employeeId) {
    if (!orgChart.has(employeeId)) return;

    const employee = orgChart.get(employeeId);
    const manager = orgChart.get(employee.managerId);

    // If the employee has a manager, reassign their reports to the manager
    if (manager) {
        // Append removed employee's reports to manager's reports
        manager.reports = manager.reports
            .filter((e) => e.id !== employeeId) // Remove the employee being deleted
            .concat(employee.reports);
    } else {
        // If the employee has no manager, their reports will have no manager
        employee.reports.forEach((report) => {
            report.managerId = null;
        });
    }

    // Remove the employee from the org chart
    orgChart.delete(employeeId);
}

/**
 * Call writeLine(str) to print a single line
 */
function print() {
    // Find all top-level employees (employees with no manager)
    const topLevelEmployees = Array.from(orgChart.values()).filter((e) => !e.managerId);

    // Helper function to recursively print the org chart
    function printEmployee(emp, level = 0) {
        writeLine(`${' '.repeat(level * 2)}${emp.name} [${emp.id}]`);
        emp.reports.forEach((report) => printEmployee(report, level + 1));
    }

    // Print each top-level employee and their reports
    topLevelEmployees.forEach((emp) => printEmployee(emp));
}

/**
 * Helper function to simulate output (for testing)
 */
function writeLine(str) {
    console.log(str);
}
