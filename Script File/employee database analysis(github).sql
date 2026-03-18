-- =========================================
-- Employee Database Analysis - SQL Queries
-- =========================================
use employees;
-- 1. Total number of employees
SELECT COUNT(*) AS total_employees FROM employees;

-- 2. List all employees
SELECT * FROM employees;

-- 3. Employees hired after 2000
SELECT * FROM employees WHERE hire_date > '2000-01-01';

-- 4. Count of employees by gender
SELECT gender, COUNT(*) AS total FROM employees GROUP BY gender;

-- 5. Total number of departments
SELECT COUNT(*) AS total_departments FROM departments;

-- 6. Employees per department
SELECT d.dept_name, COUNT(e.emp_no) AS total_employees FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name;

-- 7. Current employees in each department
SELECT d.dept_name, COUNT(de.emp_no) AS current_employees FROM dept_emp de
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- 8. Highest salary
SELECT MAX(salary) AS highest_salary FROM salaries;

-- 9. Lowest salary
SELECT MIN(salary) AS lowest_salary FROM salaries;

-- 10. Average salary
SELECT AVG(salary) AS avg_salary FROM salaries;

-- 11. Top 5 highest salaries
SELECT emp_no as Top_salaried_emp_nos, salary FROM salaries ORDER BY salary DESC LIMIT 5;

-- 12. Employees with current salary
SELECT e.emp_no, e.first_name, s.salary FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no WHERE s.to_date = '9999-01-01';

-- 13. Employees with their department names
SELECT e.emp_no, e.first_name, d.dept_name FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

-- 14. Employees with their titles
SELECT e.emp_no, e.first_name, t.title FROM employees e
JOIN titles t ON e.emp_no = t.emp_no;

-- 15. Count of employees by title
SELECT title, COUNT(*) AS total_employees FROM titles GROUP BY title;

-- 16. Department managers
SELECT d.dept_name, e.first_name FROM dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
JOIN departments d ON dm.dept_no = d.dept_no;

-- 17. Average salary by department
SELECT d.dept_name, AVG(s.salary) AS avg_salary FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name;

-- 18. Departments with more than 10000 employees
SELECT d.dept_name, COUNT(e.emp_no) AS total_employees FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name HAVING COUNT(e.emp_no) > 10000;

-- 19. Latest salary of each employee
SELECT emp_no, salary FROM salaries WHERE to_date = '9999-01-01';

-- 20. Employees whose name starts with 'A'
SELECT * FROM employees WHERE first_name LIKE 'A%';

-- 21.Rank employees by salary (highest first)
SELECT emp_no, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM salaries;
-- 22.Dense rank (no gaps in ranking)
SELECT emp_no, salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM salaries;
-- 23.Top 3 highest paid employees per department
SELECT * FROM (SELECT d.dept_name, e.emp_no, s.salary,
           ROW_NUMBER() OVER (PARTITION BY d.dept_name ORDER BY s.salary DESC) AS rn FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    JOIN salaries s ON e.emp_no = s.emp_no) t WHERE rn <= 3;
    -- 24.Find salary difference (current vs previous)
    SELECT emp_no, salary,
       salary - LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS salary_diff FROM salaries;
	-- 25.Compare salary with next salary (LEAD)
    SELECT emp_no, salary,
       LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS next_salary FROM salaries;
	-- 26.Average salary per employee (window)
    SELECT emp_no, salary,
       AVG(salary) OVER (PARTITION BY emp_no) AS avg_salary FROM salaries;
	-- 27.Get latest salary using window function
    SELECT emp_no, salary FROM (SELECT emp_no, salary,
           ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY to_date DESC) AS rn FROM salaries ) t WHERE rn = 1;
