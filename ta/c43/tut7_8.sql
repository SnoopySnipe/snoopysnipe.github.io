CREATE TABLE IF NOT EXISTS dept (
	deptno INT UNSIGNED NOT NULL AUTO_INCREMENT,
    loc VARCHAR(50) NOT NULL,
    
    CONSTRAINT dept_pk PRIMARY KEY (deptno)
);

CREATE TABLE IF NOT EXISTS emp (
	empno INT UNSIGNED NOT NULL AUTO_INCREMENT,
	ename VARCHAR(50) NOT NULL,
    job VARCHAR(50) NOT NULL,
    sal DECIMAL(20, 2) NOT NULL,
    comm DECIMAL(20, 2) NOT NULL,
    deptno INT UNSIGNED NOT NULL,
    mgr INT UNSIGNED,
    
    CONSTRAINT emp_pk PRIMARY KEY (empno),
    CONSTRAINT emp_dept_fk FOREIGN KEY (deptno) REFERENCES dept(deptno),
    CONSTRAINT emp_mgr_fk FOREIGN KEY (mgr) REFERENCES emp(empno)
);

-- what are the names of managers that have a salary between 2000 and 3000?
SELECT e.ename
FROM emp e
WHERE e.job = 'Manager' AND
e.sal BETWEEN 2000 AND 3000;

-- What are the names of the salesmen who have an income (= salary
-- plus commission) above 2000? (Note that salary is never, but
-- the commission can be null).
SELECT e.ename
FROM emp e
WHERE e.job = 'Salesman' AND
e.sal + coalesce(comm,0) > 2000;

-- What are the names of the employees that work in New York?
SELECT e.ename
FROM emp e natural join dept d
WHERE d.loc = 'New York';

-- What are the employees that earn more than their manager?
SELECT e.ename
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE e.sal + coalesce(e.comm,0)
> m.sal + coalesce(m.comm,0);

-- What are the names of the employees who are managers of at least
-- one salesman?
SELECT DISTINCT m.ename
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE e.job = 'Salesman';

-- Which are the departments that employ someone who is not a
-- salesman?
SELECT DISTINCT d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.job <> 'Salesman';

-- What are the names of the employees who are not managing anyone?
SELECT m.ename
FROM emp m
WHERE NOT EXISTS (SELECT *
FROM emp e
WHERE e.mgr = m.empno);

-- What are the names of the employees who either have the
-- job title manager or who are managing other employees.
SELECT m.ename
FROM emp m
WHERE m.job = 'Manager' OR
EXISTS (SELECT *
FROM emp e
WHERE e.mgr = m.empno);

-- what is the average salary by town?
SELECT d.loc, AVG(e.sal)
FROM emp e NATURAL JOIN dept d
GROUP BY d.loc;

-- what are the names of employees who are 
-- managers of at least 3 people?
SELECT m.ename
FROM emp m INNER JOIN emp e ON m.empno = e.mgr
GROUP BY m.ename
HAVING COUNT(*) >= 3;

-- for how many employees is it the case that the employee 
-- works in a different town from their manager?
SELECT COUNT(*) AS emps_not_working_with_manager
FROM emp e NATURAL JOIN dept ed,
emp m NATURAL JOIN dept md
WHERE e.mgr = m.empno AND
ed.loc != md.loc;

-- who is the lowest paid employee in Dallas?
SELECT e.ename
FROM emp e NATURAL JOIN dept d
WHERE d.loc = 'Dallas' AND
e.sal = (SELECT MIN(e_dallas.sal)
FROM emp e_dallas NATURAL JOIN dept d_dallas
WHERE d_dallas.loc = 'Dallas');

-- for each town, find the employee with the highest
-- salary in that town
SELECT e.ename, d.loc, MAX(e.sal) AS max_sal
FROM emp e NATURAL JOIN dept d
GROUP BY d.loc;
