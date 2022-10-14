/* select count(*) from departments;  -- 9 (dept_no, dept_name)
select count(*) from dept_emp; -- 331,603 (emp_no, dept_no, from_date, to_date)
select count(*) from dept_manager; -- 24 (dept_no, emp_no, from_date, to_date)
select count(*) from employees; -- 300,024  (emp_no, birth_date, first_name, last_name, gender, hire_date)
select count(*) from salaries; -- 300024 (emp_no, salary, from_date, to_date)
select count(*) from titles; -- 443,308 (emp_no, title, from_date, to_date)

select count (DISTINCT emp_no), COUNT(emp_no) from employees; 300024	300024
select count (DISTINCT emp_no), COUNT(emp_no) from titles; 300024	443308
select count (DISTINCT emp_no), COUNT(emp_no) from titles where to_date > current_date; 240124	240124 */

-- create Retirement Titles table and export
drop table IF EXISTS retirement_titles;

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
from employees e 
JOIN titles t
ON e.emp_no=t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31'); -- 133776

select count (DISTINCT emp_no), COUNT(emp_no) from retirement_titles;  -- 90398	133776

-- # Create Unique Titles table from retirement titles and export
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
from retirement_titles
WHERE to_date = '9999-01-01';  --72458

-- # Create Retiring Titles table and export
select count(emp_no) as emp_count, title
into retiring_titles
from unique_titles group by title order by emp_count desc;

-- Create mentorship eligibilty table
select DISTINCT ON (emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, d.from_date, d.to_date, t.title
into mentorship_eligibilty
from employees e
join dept_emp d
on e.emp_no=d.emp_no
join titles t
on e.emp_no=t.emp_no
where d.to_date = '9999-01-01'
and (birth_date BETWEEN '1965-01-01' AND '1965-12-31') order by emp_no -- 1549

select count (DISTINCT emp_no), COUNT(emp_no) from mentorship_eligibilty;  -- 1549	1549

select count (DISTINCT emp_no), COUNT(emp_no) from employees; 300024	300024
select count(emp_no) as emp_count, title from unique_titles group by title order by emp_count;
2		"Manager"
1090	"Assistant Engineer"
3603	"Technique Leader"
7636	"Staff"
9285	"Engineer"
24926	"Senior Staff"
25916	"Senior Engineer"

select count(emp_no) as emp_count, title from mentorship_eligibilty group by title order by emp_count;
77		"Technique Leader"
78		"Assistant Engineer"
155		"Staff"
169		"Senior Engineer"
501		"Engineer"
569		"Senior Staff"
