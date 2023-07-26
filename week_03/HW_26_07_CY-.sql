-- Question 1.
-- How many employee records are lacking both a grade and salary?

SELECT count(id)
FROM employees 
WHERE grade IS NULL AND salary IS NULL ; 

/*Question 2.
* Produce a table with the two following fields (columns):the department
* the employees full name (first and last name)
* Order your resulting table alphabetically by department, and then by last name
*/ 

SELECT 
	department,
	concat(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY department, last_name ;

/*Question 3.
 * Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.
 */

SELECT * 
FROM employees
WHERE last_name ILIKE 'A%'
ORDER BY salary IS NULL 
LIMIT 10 ;


/* Question 4.
 * Obtain a count by department of the employees who started work with the corporation in 2003.
 */

SELECT 	
		count(id) AS dept_employees, 
		department 
FROM employees 
WHERE start_date BETWEEN '01-01-2003' AND '12-31-2003'
GROUP BY department ;

/*Question 5. 
 * Obtain a table showing department, fte_hours and the number of employees in each 
 * department who work each fte_hours pattern. Order the table alphabetically by department, 
 * and then in ascending order of fte_hours.
 * 
 */

SELECT 
	department,
	fte_hours,
	count(*) AS dept_employee_count
FROM employees
GROUP BY fte_hours, department
ORDER BY department, fte_hours ASC


/*Question 6.
 * Provide a breakdown of the numbers of employees enrolled, not enrolled, and with 
 * unknown enrollment status in the corporation pension scheme.
 */

SELECT 
	count(*) AS pension_status_count,
	pension_enrol
FROM employees
GROUP BY pension_enrol 


/*Question 7. Obtain the details for the employee with the highest salary in the 
 * ‘Accounting’ department who is not enrolled in the pension scheme?
 */

SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC 
LIMIT 1 ; 


/*Question 8. Get a table of country, number of employees in that country, 
 * and the average salary of employees in that country for any countries in which more 
 * than 30 employees are based. Order the table by average salary descending.
 */


SELECT 
	country,
	count(*) AS country_employee_count,
	avg(salary) AS country_avg_salary 
FROM employees 
GROUP BY country 
HAVING count(*) > 30
ORDER BY avg(salary) DESC ;


/* Question 10.
 * Find the details of all employees in either Data Team 1 or Data Team 2
 */

SELECT *
FROM employees AS e
FULL JOIN teams AS t 
ON e.team_id = t.id 
WHERE  t.name IN  ('Data Team 1','Data Team 2');


/*Question 11
 * Find the first name and last name of all employees who lack a local_tax_code.
 */

SELECT 
	first_name,
	last_name,
	local_tax_code
FROM employees AS e
FULL JOIN pay_details AS p 
ON e.pay_detail_id = p.id 
WHERE local_tax_code IS NULL

/* Question 12.
* The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
* where charge_cost depends upon the team to which the employee belongs. Get a table showing 
* expected_profit for each employee.
 */


SELECT 
	e.first_name, 
	e.last_name,
		(48 * 35 * t.charge_cost::NUMERIC - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e
FULL JOIN teams AS t 
ON e.team_id = t.id; 


/* Question 13. [Tough]
* Find the first_name, last_name and salary of the lowest paid employee in Japan who works 
* the least common full-time equivalent hours across the corporation.”
*/

					
SELECT 
    first_name, 
    last_name, 
    salary
FROM 
    employees
WHERE 
    country = 'Japan' AND
    fte_hours  = (SELECT fte_hours 
        		FROM (
                	SELECT 
                    fte_hours ,
                    COUNT(*) as frequency
                FROM employees
                WHERE country = 'Japan'
                GROUP BY fte_hours 
            			) AS subquery
        ORDER BY frequency DESC
        LIMIT 1)
ORDER BY salary ASC
LIMIT 1;


/*Question 14.
* Obtain a table showing any departments in which there are two or more employees 
* lacking a stored first name. Order the table in descending order of the number of 
* employees lacking a first name, and then in alphabetical order by department
*/

SELECT department,
		count(*) AS first_nameless
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING count(*) >= 2
ORDER BY first_nameless DESC, department ASC

/* Question 15. [Bit tougher]
* Return a table of those employee first_names shared by more than one employee, 
* together with a count of the number of times each first_name occurs. Omit employees 
* without a stored first_name from the table. Order the table descending by count, and 
* then alphabetically by first_name. 
 */
	
SELECT first_name,
		count(id) AS name_repeat
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name
HAVING count(id) >1 
ORDER BY name_repeat DESC, first_name ASC


/* 16
 * Find the proportion of employees in each department who are grade 1.
 */

SELECT 
	count(grade = 1) AS grd1_count,
	count(*) AS total_dep_emp,
	count(grade = 1) * 100 / count(*) AS proportion 
FROM employees
GROUP BY department 







