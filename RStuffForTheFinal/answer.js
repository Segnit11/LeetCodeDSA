const fs = require('fs');
const _ = require("lodash");
process.stdin.resume();
process.stdin.setEncoding('utf-8');

let ws;
let input = '';
process.stdin.on('data', inputStdin => input += inputStdin);
process.stdin.on('end', () => {
    ws = fs.createWriteStream(process.env.OUTPUT_PATH);

    input
        .replace(/\s*$/, '') // trim
        .split('\n')
        .map(str => str.replace(/\s*$/, '')) // trim again
        .filter(str => str.length > 1) // remove empty strings
        .map(str => str.split(',')) // parse command and options
        .map(([cmd, ...opts]) => { // call coresponding function
            switch(cmd) {
                case 'add':
                    return add(...opts);
                case 'remove':
                    return remove(...opts);
                case 'move':
                    return move(...opts);
                case 'count':
                    return writeLine(count(...opts));
                case 'print':
                    return print();
                default:
                    return;
            }
        });

    ws.end();
});

// helper for printing new lines to correct write stream
function writeLine(str) {
    ws.write(str + "\n");
}

class Employee {
    // creating an Employee object 
    constructor(employeeId, name, managerId = null) {
        this.employeeId = employeeId;   // Employee has to have an ID
        this.name = name;   // Employee has to have a name
        this.managerId = managerId;  // Employee has to have a manager that has to report to
        this.reports = [];    // Listing other employees that report to this Employee
    }
}

// creating a new map object
let orgChart = new Map();

/**
 * @param {String} employeeId
 * @param {String} name
 * @param {String} managerId
 */
function add(employeeId, name, managerId) {
    // Before Adding
    // Check employee if they exist = unique identifier 'employeeID'
    // If they do => fxn exist
    if (orgChart.has(employeeId)) return;
    
    // Else add them
        // Create a new employee with those propeties
        // Add this new employee to the org
        // using the mangerId find the manager
    const newEmployee = new Employee(employeeId, name, managerId);
    orgChart.set(employeeId, newEmployee)
    
    // After finding the manager - check if the manager exists in the org
        // if it does add the new employee to the managers report
    if (managerId && orgChart.has(managerId)) {
        orgChart.get(managerId).reports.push(newEmployee)
    }    
}

/**
 * @param {String} employeeId
 * @param {String} newManagerId
 */
function move(employeeId, newManagerId) {
    // Before Moving
    // Check if both the employee and the manager exist
    // If they don't => fxn exist
    if (!orgChart.has(employeeId) || !orgChart.has(newManagerId)) return;
    
    // Else move them
        // Get the employee, the oldmanager and the newmanager from the org
    
    const employee = orgChart.get(employeeId);
    const oldmanager = orgChart.get(employee.managerId);
    const newManager = orgChart.get(newManagerId);
    
    // remove the employee from the report of the old manager
        // we have to filter that employee from the list of the reportmof the old manager
    if (oldmanager) {
        oldmanager.reports = oldmanager.reports.filter((e) => e.id !== employeeId);
    }
    
    // update the managerID and push it the employee to the new manager report
    employee.managerId = newManagerId;
    newManager.reports.push(employee);
}

/**
 * Return the count, don't worry about writing the value to console
 * @param {String} employeeId
 * @returns {Int} number of employees that report up to a given employee
 */
function count(employeeId) {
    // Before counting
    // Check if the employee exist
    // If it doesn't say zero
    if (!orgChart.has(employeeId)) return 0;
    
    // Else count it
    // Get the Employee 
    const employee = orgChart.get(employeeId);
    
    const countReports = e =>
        e.reports.length + e.reports.reduce((total, report) => total + countReports(report), 0);

    return countReports(employee);
    
}

/**
 * @param {String} employeeId
 */
function remove(employeeId) {
    // Before removing
    // Check if the employee exist
    // If it doesn't there is no reason to remove anything
    if (!orgChart.has(employeeId)) return;
    
    // Else remove them
    // Get the employee that is going to be removed and its manager
    const employee = orgChart.get(employeeId);
    const manager = orgChart.get(employee.managerId);
    
    // Before removing the employee check if the Employee has a manager
        // If it has reassign to the the manager above of the Employee
    if (manager) {
        manager.reports = manager.reports.filter((e) => e.id !== employeeId).concat(employee.reports);  // adding the removed employee report to its manager
    } else {
        // if the Employee doesn't have a manager the report will not have a manager
        employee.reports.forEach((report) => {
            report.managerId = null;
        })
    }
    
    // Remove the Employee
    orgChart.delete(employeeId)
}

/**
 * Call writeLine(str) to print a single line
 */
function print() {
    // Getting all employees with no managers
   const topLevelEmployees = Array.from(orgChart.values()).filter(emp => !emp.managerId);

    // Function to print an employee and their reports with indentation
    function displayEmployee(employee, indent = 0) {
        /// Creating spaces for indentation
        const spaces = ' '.repeat(indent * 2); 
        // Print employee name and ID
        writeLine(`${spaces}${employee.name} [${employee.id}]`);
        employee.reports.forEach(report => displayEmployee(report, indent + 1)); // Print recursively each direct reports
    }

    // Print all Employes starting from top-level employees
    topLevelEmployees.forEach(employee => displayEmployee(employee));
};
