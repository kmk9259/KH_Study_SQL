--1
SELECT
    STUDENT_NO 학번,
    STUDENT_NAME 이름,
    ENTRANCE_DATE 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO='002'
ORDER BY 3;

--2
SELECT
    PROFESSOR_NAME,
    PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

--3
SELECT
    PROFESSOR_NAME 교수이름,
    121-TO_NUMBER(SUBSTR(PROFESSOR_SSN,0,2))-1 나이
FROM TB_PROFESSOR
ORDER BY 2 ;

--4
SELECT
    SUBSTR(PROFESSOR_NAME,2,3) 이름
FROM TB_PROFESSOR;

--5
SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(ENTRANCE_DATE,1,2)=
        SUBSTR(TO_NUMBER(SUBSTR(STUDENT_SSN,1,2))+20,2,3);
        
--6
SELECT
    TO_CHAR(TO_DATE('20201225','YYYYMMDD'),'DY"요일"')
FROM DUAL;

--7
SELECT
    TO_CHAR(TO_DATE('99/10/11','YY/MM/DD'),'YYYY"년" MM"월" DD"일"')Y1,
    TO_CHAR(TO_DATE('99/10/11','RR/MM/DD'),'RRRR"년" MM"월" DD"일"')R1,
    TO_CHAR(TO_DATE('49/10/11','YY/MM/DD'),'YYYY"년" MM"월" DD"일"')Y2,
    TO_CHAR(TO_DATE('99/10/11','RR/MM/DD'),'RRRR"년" MM"월" DD"일"')R2
FROM DUAL;

--8
SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE '%A%';

--9
SELECT
    ROUND(AVG(A.POINT),1) 평점
FROM TB_GRADE A
JOIN TB_STUDENT B ON A.STUDENT_NO = B.STUDENT_NO
WHERE B.STUDENT_NO='A517178';

--10
SELECT
    DEPARTMENT_NO 학과번호,
    COUNT(DEPARTMENT_NO) 학생수  
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

--11
SELECT
    COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

--12 
SELECT
    년도,
    ROUND(AVG(POINT),1) 년도별평점
FROM ( 
        SELECT
            G.*,
            SUBSTR(TERM_NO,1,4) 년도
        FROM TB_GRADE G
        WHERE STUDENT_NO='A112113'
    )
GROUP BY 년도;
--13
SELECT
    DEPARTMENT_NO 학과코드명,
    COUNT(ABSENCE_YN)휴학생수
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO,ABSENCE_YN
HAVING ABSENCE_YN='Y'
ORDER BY 1;

--14
SELECT
    STUDENT_NAME 동일이름,
    COUNT(STUDENT_NAME) 동명인수
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(STUDENT_NAME)=2
ORDER BY 1;

--15 다시
SELECT
    SUBSTR(TERM_NO,1,4) AS 년도,
    SUBSTR(TERM_NO,5,7) AS 학기,
    ROUND(AVG(POINT),1) 평점
FROM TB_GRADE
WHERE STUDENT_NO='A112113'
GROUP BY ROLLUP(TERM_NO)
ORDER BY 1,2;
 