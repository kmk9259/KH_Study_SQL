
/*@ 조인문(JOIN)
-> 여러테이블의 레코드를 조합하여 하나의 열로 표현한것, 하나로 합쳐서 결과를 조회한다. 
-> 두 개 이상의 테이블에서 연관성을 가지고있는 데이터 들을 따로 분류하여 새로운 가상의 테이블을 이용하여 출력
   서로다른 테이블에서 각각 공통값을 이용함으로써 필드를 조합함
   즉, 관계형 데이터베이스에서 SQL 문을 이용한 테이블간 "관계"를 맺는 방법
   
* JOIN 시 컬럼이 같을 경우와 다를 경우 2가지 방법이있다.
- ORACLE 전용구문
- ANSI 표준구문
(ANSI( 미국 국립 표준 협회 => 산업표준을 재정하는 단체 ) 에서 지정한 DBMS 에 상관없이 공통으로 사용하는 표준 SQL)
*/

--오라클 전용구문 
-- FROM 절에 ','  로 구분하여 합치게될 테이블명을 기술하고 
-- WHERE 절에 합치기위해 사용할 컬럼명을 명시한다. 

--연결에 사용할 두 컬럼명이 다른경우 
SELECT
    EMP_ID,
    DEPT_CODE,
    DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT A
WHERE DEPT_CODE = DEPT_ID;

--연결에 사용할 두 컬럼명이 같은 경우
SELECT
    EMPLOYEE.EMP_ID,
    EMPLOYEE.EMP_NAME,
    JOB.JOB_CODE,
    JOB.JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--테이블 별칭 사용
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_CODE,
    B.JOB_NAME
FROM EMPLOYEE A, JOB B
WHERE A.JOB_CODE = B.JOB_CODE;

--ANSI 표준구문
--연결에 사용할 컬럼 명이 같은 경우 USING(컬럼명)을 사용함
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);
--연결에 사용할 컬럼명이 같은 경우 ON(컬럼명) 사용
SELECT
    EMP_ID,
    EMP_NAME,
    A.JOB_CODE,
    JOB_NAME
FROM EMPLOYEE A
JOIN JOB B ON(A.JOB_CODE=B.JOB_CODE);

--연결에 사용할 컴럼며이 다른 경우 무조건 ON(컬럼명) 사용
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
--부서 테이블과 지역테이블을 조인하여 테이블에 모든 데이터를 조회하시오
--오라클 전용
SELECT
    *
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

--ANSI 표준 구문
SELECT
    *
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);


--조인은 기본이 EQUAL JOIN(등가조인) 이다(=EQU JOIN)
--연결이 되는 컬럼의 값이 일치하는 행들만 조인됨(일치하는 값이 없는 경우는 조인에서 제외되어 출력)

--JOIN 기본은 INNER JOIN(=JOIN) & EQU JOIN

--OUTER JOIN : 두테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
--             반드시 OUTER JOIN 임을 명시해야한다. 

--1. LEFT OUTER JOIN (= LEFT JOIN) : 합치기에 사용된 두테이블중에서 왼편에 기술된 테이블의 행을 기준으로 하여 JOIN

--2. RIGHT OUTER JOIN (= RIGHT JOIN) : 합치기에 사용된 두테이블중에서 오른편에 기술된 테이블의 행을 기준으로 하여 JOIN

--3. FULL OUTER JOIN (= FULL JOIN): 합치기에 사용된 두테이블이 가진 모든행을 결과에 포함하여 JOIN

--INNER JOIN, EQUAL JOIN
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--LEFT OUTER JOIN
--ANSI 표준
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
--LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--ORACLE 전용 구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

--RIGHT OUTER JOIN
--ANSI 표준
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
--RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;   

--오라클 전용구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

--FULL OUTER JOIN
--ANSI 표준
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
--FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;


--오라클 전용구문
--오라클 전용구문으로는 FULL OUTER JOIN을 할 수 없다. -> 에러 발생

--CROSS JOIN : 카테이션 곱이라고도 한다.
--조인이 되는 테이블의 각 행들이 모두 매핑된 데이터가 검색 되는 방법 (곱집합)

--ANSI 표준 구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; --23*9 = 207

--오라클 전용구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;

--NON EQUAL JOIN
--지정한 컬럼의 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식
--ANSI표준

SELECT
    EMP_NAME,
    SALARY,
    A.SAL_LEVEL A_SQL_LEVEL,
    B.SAL_LEVEL B_SQL_LEVEL
FROM EMPLOYEE A
JOIN SAL_GRADE B ON A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL;

--오라클 전용 구문
SELECT
    EMP_NAME,
    SALARY,
    A.SAL_LEVEL A_SQL_LEVEL,
    B.SAL_LEVEL B_SQL_LEVEL
FROM EMPLOYEE A , SAL_GRADE B
WHERE A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL;

--SELF JOIN : 같은 테이블을 조인하는 경우 자기 자신과 조인을 맺는 것
--동일한 테이블 내에서 원하는 정보를 한번에 가져올 수 없을 때 사용
SELECT
    A.EMP_ID,
    A.EMP_NAME 사원이름,
    A.DEPT_CODE,
    A.MANAGER_ID,
    B.EMP_NAME 관리자이름
FROM EMPLOYEE A , EMPLOYEE B
WHERE A.MANAGER_ID = B.EMP_ID
ORDER BY 1;

--다중조인 : N개의 테이블을 조회할 때 사용
--ANSI표준
--순서 중요
-- 다중 조인 시 아래 코드처럼 LOCATION과의 조인을 하려면 먼저 DEPARTMENT가 있어야 하기 때문에 주의
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE;

--ORACLE
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A, DEPARTMENT B, LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE;

--직급이 대리이면서 아시아 지역에 근무하는 직원조회
--사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회
--ANSI
SELECT
     A.EMP_NAME 사원명,
    A.EMP_ID 사번,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명,
    A.SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID 
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
WHERE A.JOB_CODE ='J6'
AND D.LOCAL_NAME LIKE 'ASIA%';
--ORACLE
SELECT
     A.EMP_NAME 사원명,
    A.EMP_ID 사번,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명,
    A.SALARY 급여
FROM EMPLOYEE A, JOB B, DEPARTMENT C, LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND A.JOB_CODE ='J6'
AND D.LOCAL_NAME LIKE 'ASIA%';


