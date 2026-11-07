--Dominik Chorzępa gr.1
--Zadanie I.

DROP TABLE JOB_HISTORY;
DROP TABLE EMPLOYEES;
DROP TABLE DEPARTMENTS;
DROP TABLE JOBS;
DROP TABLE LOCATIONS;
DROP TABLE COUNTRIES;
DROP TABLE REGIONS;

--Zadanie II.
CREATE TABLE regions AS SELECT * FROM HR.REGIONS;

CREATE TABLE countries AS SELECT * FROM HR.COUNTRIES;

CREATE TABLE locations AS SELECT * FROM HR.LOCATIONS;

CREATE TABLE jobs AS SELECT * FROM HR.JOBS;

CREATE TABLE departments AS SELECT * FROM HR.DEPARTMENTS;

CREATE TABLE employees AS SELECT * FROM HR.EMPLOYEES;

CREATE TABLE job_history AS SELECT * FROM HR.JOB_HISTORY;

ALTER TABLE regions ADD CONSTRAINT pk_regions PRIMARY KEY (region_id);

ALTER TABLE countries ADD CONSTRAINT pk_countries PRIMARY KEY (country_id);

ALTER TABLE locations ADD CONSTRAINT pk_locations PRIMARY KEY (location_id);

ALTER TABLE jobs ADD CONSTRAINT pk_jobs PRIMARY KEY (job_id);

ALTER TABLE departments ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);

ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);

ALTER TABLE job_history ADD CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date);

ALTER TABLE countries ADD CONSTRAINT fk_countries_regions FOREIGN KEY (region_id) REFERENCES regions(region_id)

ALTER TABLE locations ADD CONSTRAINT fk_locations_countries FOREIGN KEY (country_id) REFERENCES countries(country_id);

ALTER TABLE departments ADD CONSTRAINT fk_departments_locations FOREIGN KEY (location_id) REFERENCES locations(location_id);

ALTER TABLE employees ADD CONSTRAINT fk_employees_departments FOREIGN KEY (department_id) REFERENCES departments(department_id);

ALTER TABLE employees ADD CONSTRAINT fk_employees_jobs FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE employees ADD CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id)

ALTER TABLE job_history ADD CONSTRAINT fk_job_history_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE job_history ADD CONSTRAINT fk_job_history_departments FOREIGN KEY (department_id) REFERENCES departments(department_id);

ALTER TABLE job_history ADD CONSTRAINT fk_job_history_jobs FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE departments ADD CONSTRAINT fk_departments_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

--ZADANIE III.

-- 1.
SELECT last_name || ' - ' || salary AS wynagrodzenie
FROM employees
WHERE department_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name ASC;

-- 2.
SELECT hire_date, last_name, &&kolumna
FROM employees WHERE manager_id IS NOT NULL
AND hire_date >= DATE '2005-01-01'
AND hire_date < DATE '2006-01-01'
ORDER BY &&kolumna ASC;

-- 3.
SELECT first_name || ' ' || last_name AS pracownik, salary, phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e'
AND first_name LIKE '%' || '&fragment_imienia' || '%'
ORDER BY 1 DESC, 2 ASC;

-- 4.
SELECT first_name, last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS liczba_miesiecy,
CASE WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 150
THEN salary * 0.10
WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 200
THEN salary * 0.20
ELSE salary * 0.30
END AS wysokosc_dodatku
FROM employees 
ORDER BY 3 ASC;

-- 5.
SELECT e.department_id, SUM(e.salary) AS suma_zarobkow, ROUND(AVG(e.salary)) AS srednia_zarobkow
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE j.min_salary > 5000
GROUP BY e.department_id;

-- 6.
SELECT e.last_name, d.department_id, d.department_name, e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

-- 7.
SELECT j.first_name AS imie_jennifer, j.last_name AS nazwisko_jennifer, w.first_name AS imie_wspolpracownika, w.last_name AS nazwisko_wspolpracownika
FROM employees j
JOIN employees w ON j.department_id = w.department_id
WHERE j.first_name = 'Jennifer' AND j.employee_id <> w.employee_id;

-- 8.
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS(
    SELECT 1 FROM employees e
    WHERE e.department_id = d.department_id
    );

-- 9.
SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary,
CASE
    WHEN e.salary < 3000 THEN 'A'
    WHEN e.salary < 6000 THEN 'B'
    WHEN e.salary < 10000 THEN 'C'
    WHEN e.salary < 15000 THEN 'D'
    ELSE 'E'
END AS grade
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
ORDER BY e.salary DESC;

-- 10.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

-- 11.
SELECT employee_id, first_name, last_name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM employees
    WHERE LOWER(last_name) LIKE '%u%'
)
ORDER BY employee_id;

-- 12.
SELECT employee_id, first_name, last_name,
    ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))
        AS staz_w_miesiacach
FROM employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) > (
    SELECT AVG(MONTHS_BETWEEN(SYSDATE, hire_date))
    FROM employees
)
ORDER BY staz_w_miesiacach DESC;

-- 13.
SELECT d.department_name, COUNT(e.employee_id) AS liczba_pracownikow,
ROUND(AVG(e.salary)) AS srednie_wynagrodzenie
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY liczba_pracownikow DESC;

-- 14.
SELECT first_name, last_name, salary
FROM employees
WHERE salary < ANY (
    SELECT e.salary
    FROM employees e
    JOIN departments d
        ON e.department_id = d.department_id
    WHERE d.department_name = 'IT'
    );

-- 15.
SELECT DISTINCT d.department_id, d.department_name
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
);

-- 16.
SELECT j.job_title, ROUND(AVG(e.salary)) AS srednie_zarobki
FROM jobs j
JOIN employees e
    ON j.job_id = e.job_id
GROUP BY j.job_id, j.job_title
ORDER BY srednie_zarobki DESC
FETCH FIRST 5 ROWS ONLY;

-- 17.
SELECT r.region_name, COUNT(DISTINCT c.country_id) AS liczba_krajow, COUNT(DISTINCT e.employee_id) AS liczba_pracownikow
FROM regions r
LEFT JOIN countries c
    ON r.region_id = c.region_id
LEFT JOIN locations l
    ON c.country_id = l.country_id
LEFT JOIN departments d
    ON l.location_id = d.location_id
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY r.region_id, r.region_name
ORDER BY r.region_name;

-- 18.
SELECT e.first_name, e.last_name, e.salary AS zarobki_pracownika,
m.first_name AS imie_menadzera, m.last_name AS nazwisko_menadzera,
m.salary AS zarobki_menadzera
FROM employees e
JOIN employees m
    ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- 19.
SELECT EXTRACT(MONTH FROM hire_date) AS numer_miesiaca,
COUNT(*) AS liczba_pracownikow
FROM employees
GROUP BY EXTRACT(MONTH FROM hire_date)
ORDER BY numer_miesiaca;

-- 20.
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS srednie_wynagrodzenie
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY srednie_wynagrodzenie DESC
FETCH FIRST 3 ROWS ONLY;


