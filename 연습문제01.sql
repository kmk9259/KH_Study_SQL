--01
SELECT
    EMP_NAME 이름,
    EMAIL 이메일,
    LENGTH(EMAIL)이메일길이
FROM EMPLOYEE;
--02
SELECT
    EMP_NAME 이름,
    SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) 아이디
FROM EMPLOYEE;
--03
SELECT * FROM EMPLOYEE;
SELECT
    EMP_NAME 직원명,
    SUBSTR(EMP_NO, 1, 2) 년생,
    NVL(BONUS,0)보너스
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 60 AND 69;
--04
SELECT
    COUNT(PHONE),
    '명' 단위
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--05
SELECT
    EMP_NAME 직원명,
    TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"')입사년월
FROM EMPLOYEE;
--06
SELECT
    EMP_NAME 직원명,
    RPAD(SUBSTR(EMP_NO, 1,7), 14, '*') 주민번호
FROM EMPLOYEE;
--07
SELECT
    EMP_NAME 직원명,
    JOB_CODE 직급코드,
    TO_CHAR((SALARY+(SALARY*NVL(BONUS,0)))*12, 'L999999999')연봉
FROM EMPLOYEE;
--08
SELECT
    EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_CODE 부서코드,
    HIRE_DATE 입사일
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D9') AND HIRE_DATE LIKE '04%';
--09
SELECT
    EMP_NAME 직원명,
    HIRE_DATE 입사일,
    FLOOR(SYSDATE - HIRE_DATE)근무일수,
    '일' 단위
FROM EMPLOYEE;
--10
SELECT 
    EMP_NAME
    , DEPT_CODE
    , SUBSTR(EMP_NO, 1, 2) || '년 ' || 
      SUBSTR(EMP_NO, 3, 2) || '월 ' || 
      SUBSTR(EMP_NO, 5, 2) ||'일 ' 생년월일,
      EXTRACT(YEAR FROM SYSDATE) - 
      EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'))) + 1 나이
FROM EMPLOYEE
WHERE EMP_ID NOT IN (200, 201, 214);
--11

SELECT 
       COUNT(*) 전체직원수
     , COUNT(DECODE(TO_CHAR(EXTRACT(YEAR FROM HIRE_DATE)), '2001', 1)) "2001년"
     , COUNT(DECODE(TO_CHAR(EXTRACT(YEAR FROM HIRE_DATE)), '2002', 1)) "2002년"
     , COUNT(DECODE(TO_CHAR(EXTRACT(YEAR FROM HIRE_DATE)), '2003', 1)) "2003년"
     , COUNT(DECODE(TO_CHAR(EXTRACT(YEAR FROM HIRE_DATE)), '2004', 1)) "2004년"
  FROM EMPLOYEE;
FROM EMPLOYEE;
--12
SELECT 
    CASE 
    WHEN DEPT_CODE='D5' THEN '총무부'
    WHEN DEPT_CODE='D6' THEN '기획부'
    WHEN DEPT_CODE='D9' THEN '영업부'
    END 부서코드,
    A.*
FROM EMPLOYEE A
WHERE DEPT_CODE IN('D5','D6','D9')
ORDER BY DEPT_CODE ;


    