--1. Active courses

SELECT course_id AS mnemonic, course_name
FROM COURSES
WHERE is_active = 1
ORDER BY course_id;

--2. Inactive courses:

SELECT course_id AS mnemonic, course_name
FROM COURSES
WHERE is_active = 0
ORDER BY course_id;

--3. Instructors who are not current employees:

SELECT instructor_id, first_name, last_name, is_current_employee
FROM INSTRUCTORS
WHERE is_current_employee = 0
ORDER BY instructor_id;

--4. Number of learning outcomes per course:

SELECT c.course_id AS mnemonic, c.course_name, COUNT(lo.lo_id) AS num_outcomes
FROM COURSES c
LEFT JOIN LEARNING_OUTCOMES lo ON c.course_id = lo.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;

--5. Courses with no learning outcomes:

SELECT c.course_id AS mnemonic, c.course_name
FROM COURSES c
LEFT JOIN LEARNING_OUTCOMES lo ON c.course_id = lo.course_id
WHERE lo.learning_outcome IS NULL
ORDER BY c.course_id;

--6. Courses including SQL as a learning outcome:

SELECT DISTINCT c.course_id AS mnemonic, c.course_name, lo.learning_outcome
FROM COURSES c
JOIN LEARNING_OUTCOMES lo ON c.course_id = lo.course_id
WHERE lo.learning_outcome LIKE '%SQL%'
ORDER BY c.course_id;

--7. Instructor for ds5100 in Summer 2021:

SELECT co.instructor_id, i.first_name, i.last_name
FROM COURSE_OFFERINGS co
JOIN INSTRUCTORS i ON co.instructor_id = i.instructor_id
WHERE co.course_id = 'ds5100' AND co.offering_id = 'summer2021'

--8. Instructors who taught in Fall 2021:

SELECT DISTINCT i.first_name, i.last_name, i.instructor_id
FROM COURSE_OFFERINGS co
JOIN INSTRUCTORS i ON co.instructor_id = i.instructor_id
WHERE co.offering_id = 'fall2021'
ORDER BY i.instructor_id, i.last_name, i.first_name;

--9. Number of courses taught by each instructor in each term:

SELECT i.instructor_id, co.offering_id, i.first_name, i.last_name, COUNT(DISTINCT co.course_id) AS courses_taught
FROM COURSE_OFFERINGS co
JOIN INSTRUCTORS i ON co.instructor_id = i.instructor_id
GROUP BY co.offering_id, i.instructor_id, i.first_name, i.last_name
ORDER BY i.instructor_id, co.offering_id, i.instructor_id, i.last_name, i.first_name;

--10a. Courses with more than one instructor fo rthe same term:

SELECT course_id AS mnemonic, offering_id
FROM COURSE_OFFERINGS
GROUP BY course_id, offering_id
HAVING COUNT(DISTINCT instructor_id) > 1
ORDER BY offering_id, course_id;

--10b. Details for courses with multiple sections

WITH MultiSectionCourses AS (
    SELECT course_id, offering_id
    FROM COURSE_OFFERINGS
    GROUP BY course_id, offering_id
    HAVING COUNT(DISTINCT instructor_id) > 1
)
SELECT msc.offering_id, msc.course_id AS mnemonic, i.first_name, i.last_name
FROM MultiSectionCourses msc
JOIN COURSE_OFFERINGS co ON msc.course_id = co.course_id 
    AND msc.offering_id = co.offering_id
JOIN INSTRUCTORS i ON co.instructor_id = i.instructor_id
ORDER BY msc.offering_id, msc.course_id, i.last_name, i.first_name;
