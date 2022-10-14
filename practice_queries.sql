-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(150) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
	-- PRIMARY KEY (emp_no)
);

select * from departments limit 10;
select * from dept_manager limit 10;
select * from dept_emp limit 10;
select * from employees limit 10;
select * from salaries limit 10;
select * from titles limit 10;

SELECT first_name, last_name, birth_date
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name, birth_date
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(emp_no)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

------

select count(*) from departments;  -- 9 (dept_no, dept_name)
select count(*) from dept_emp; -- 331,603 (emp_no, dept_no, from_date, to_date)
select count(*) from dept_manager; -- 24 (dept_no, emp_no, from_date, to_date)
select count(*) from employees; -- 300,024  (emp_no, birth_date, first_name, last_name, gender, hire_date)
select count(*) from salaries; -- 300024 (emp_no, salary, from_date, to_date)
select count(*) from titles; -- 443,308 (emp_no, title, from_date, to_date)

-- drop table IF EXISTS retirement_titles;

SELECT DISTINCT ON (e.emp_no) e.emp_no, e.birth_date, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
from employees e 
JOIN titles t
ON e.emp_no=t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') and t.to_date > current_date;

select count (DISTINCT emp_no), COUNT(emp_no) from retirement_titles; -- 72458	72458
select * from retirement_titles limit 50;

select count(emp_no) as emp_count, title from retirement_titles group by title order by emp_count;


