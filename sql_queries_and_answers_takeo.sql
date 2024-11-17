
drop table if exists employees; 

CREATE TABLE Employees (

EmployeeID INT,

Name VARCHAR(50),

Department VARCHAR(50),

Salary INT,

JoiningDate DATE

);


INSERT INTO Employees (EmployeeID, Name, Department, Salary, JoiningDate) VALUES

(1, 'Alice', 'Sales', 70000, '2021-03-15'),

(2, 'Bob', 'Sales', 68000, '2022-04-20'),

(3, 'Charlie', 'Marketing', 72000, '2020-07-30'),

(4, 'David', 'Marketing', 75000, '2021-11-25'),

(5, 'Eve', 'Sales', 69000, '2020-02-10'),

(6, 'Frank', 'HR', 66000, '2019-05-15'),

(7, 'Grace', 'HR', 64000, '2021-06-10'),

(8, 'Hannah', 'Finance', 73000, '2022-08-19'),

(9, 'Ian', 'Finance', 71000, '2020-03-05'),

(10, 'Jack', 'Sales', 78000, '2023-01-10'),

(11, 'Kara', 'Marketing', 80000, '2022-05-05'),

(12, 'Liam', 'Finance', 72000, '2021-01-30');


# Question 1: Find the total number of employees and the average salary for each department.
select department , avg(salary)as avg_salary, count(employeeid) as total_employees
from employees
group by department;


# Question 2: List each employee’s name, department, salary, and their rank based on salary within their department.
select name, department , salary, rank() over (partition by department order by salary desc) as ranked_salary 
from employees;


# Question 3: For each department, find the employee with the highest salary.
select name, department, salary
from employees
where salary in (
    select MAX(salary)
    from employees
    group by  department
);

# Question 4: Calculate the cumulative salary for each employee within their department, ordered by their salary in descending order.
select name, department, salary, sum(salary) over (partition by department order by salary desc)as cum_salary from employees;

# Question 5: Find the average salary for each department and list the employees who earn above their department's average salary.

select e.name, e.department,e.salary from employees e join (select department, avg(salary) as avg_salary from employees group by department) as dept_avg_salary on e.department = dept_avg_salary.department where salary > avg_salary;


# Question 6: For each department, determine the difference between each employee's salary and the highest salary in that department.
select e.name, e.department, e.salary, (dept_max_salary.max_salary - e.salary) as salary_difference from employees e join (select department, max(salary) as max_salary from employees e group by department) as dept_max_salary on e.department = dept_max_salary.department;


# Question 7: List the number of employees hired each year, ordered by year.
select year(joiningdate) as hire_year, count(employeeid) as num_employees_hired
from employees
group by year(joiningdate)
order by hire_year;

# Question 8: Find the top two highest-paid employees from each department.
with ranked_salary as (
select name , department , salary,
 rank() over (partition by department order by salary desc) as salary_rank 
 from employees )
 select name, department, salary, salary_rank from ranked_salary where salary_rank <=2;

# Question 9: Calculate the running average salary for each department, ordered by salary in descending order.
with running_average as (select department, salary, avg(salary)over(partition by department order by salary desc) as running_avg from employees) 
select department, running_avg from running_average order by department, running_avg desc;


# Question 10: Find each employee's tenure in years (as of today) and rank employees by tenure within each department.
with department_tenure as (
    select
        name, 
        department, 
        floor(datediff(current_date, joiningdate) / 365) as tenure_years, 
        rank() over (partition by department order by floor(datediff(current_date, joiningdate) / 365) desc) as tenure_rank 
    from
        employees
)
select
    name, 
    department, 
    tenure_years, 
    tenure_rank
from
    department_tenure
order by 
    department, tenure_rank desc;


