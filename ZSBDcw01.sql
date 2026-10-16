--Dominik Chorzępa gr.1
--Zadanie 1.

CREATE TABLE regions (
    region_id NUMBER(6) PRIMARY KEY,
    region_name VARCHAR2(50)
    );

CREATE TABLE countries (
    country_id CHAR(5) PRIMARY KEY,
    country_name VARCHAR2(60),
    region_id NUMBER(5)
    );

ALTER TABLE countries
ADD CONSTRAINT fk_countries_regions
FOREIGN KEY (region_id) REFERENCES regions(region_id);

CREATE TABLE locations(
    location_id NUMBER(5) PRIMARY KEY,
    street_address VARCHAR2(100),
    postal_code VARCHAR2(20),
    city VARCHAR2(50),
    state_province VARCHAR(50),
    country_id CHAR(5)
    );

ALTER TABLE locations
ADD CONSTRAINT fk_locations_countries
FOREIGN KEY (country_id) REFERENCES countries(country_id);

CREATE TABLE departments (
    department_id NUMBER(5) PRIMARY KEY,
    department_name VARCHAR2(50),
    manager_id NUMBER(6),
    location_id NUMBER(5)
    );

ALTER TABLE departments
ADD CONSTRAINT fk_departments_locations
FOREIGN KEY (location_id) REFERENCES locations(location_id);

CREATE TABLE jobs (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50),
    min_salary NUMBER(5),
    max_salary NUMBER(5),
    CONSTRAINT chk_salary CHECK (max_salary >= min_salary + 2000)
    );
    
CREATE TABLE employees(
    employee_id NUMBER(5) PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    email VARCHAR2(100),
    phone_number VARCHAR(30),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER(8),
    manager_id NUMBER(6),
    department_id NUMBER(5),
    
    CONSTRAINT fk_employees_jobs
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    
    CONSTRAINT fk_employees_departments
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    
    CONSTRAINT fk_employees_manager
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
    );
    
ALTER TABLE employees
ADD comission_pct NUMBER(5);

CREATE TABLE job_history (
    employee_id NUMBER(5),
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(10),
    
    CONSTRAINT pk_job_history
    PRIMARY KEY (employee_id, start_date),
    
    CONSTRAINT fk_history_employee
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    
    CONSTRAINT fk_history_job
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
    );

ALTER TABLE job_history
ADD department_id NUMBER(5);

ALTER TABLE job_history
ADD CONSTRAINT fk_history_department
FOREIGN KEY (department_id) REFERENCES departments(department_id);


--Zadanie 2.

INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES ('IT_PROG', 'Programista', 4000, 10000);

INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES ('IT_ADMIN', 'Administrator', 3500, 9000);

INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES ('DB_ADMIN', 'Administrator bazy', 6700, 11200);

INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES ('HR_PRAC', 'Pracownik HR', 4000, 6500);


--Zadanie 3.

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, manager_id, department_id)
VALUES (1, 'Jan', 'Kowalski', 'jkowalskixty', 123456, DATE '2024-01-10', 'IT_ADMIN',
6500, 1, NULL);

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, manager_id, department_id)
VALUES (2, 'Dawid', 'Moeck', 'dmoeckxty', 676767, DATE '2025-05-12', 'IT_PROG',
11000, 1, NULL);

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, manager_id, department_id)
VALUES (3, 'Artur', 'Nowak', 'anowakxty', 321456, DATE '2026-08-31', 'IT_PROG',
6000, 1, NULL);

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, manager_id, department_id)
VALUES (4, 'Piotr', 'Wisnia', 'pwisniaxty', 658493, DATE '2020-02-01', 'HR_PRAC',
4000, 2, NULL);


--Zadanie 4.

UPDATE employees
SET manager_id = 1
WHERE employee_id IN (2, 3);


--Zadanie 5.

UPDATE jobs
SET min_salary = min_salary + 500,
    max_salary = max_salary + 500
WHERE LOWER(job_title) LIKE '%b%'
  OR  LOWER(job_title) LIKE '%s%';


--Zadanie 6.

SELECT * FROM jobs WHERE max_salary > 9000;

--(Konflikt klucza obcego)

UPDATE employees SET job_id = 'HR_PRAC'
WHERE job_id IN (
    SELECT job_id
    FROM jobs
    WHERE max_salary > 9000
        AND job_id <> 'HR_PRAC'
    );

DELETE FROM jobs WHERE max_salary > 9000;


--Zadanie 7.

DROP TABLE job_history

SHOW RECYCLEBIN

FLASHBACK TABLE job_history TO BEFORE DROP



