/*@ DQL(Data Query Language)
데이터를 검색 추출하기 위해 사용하는 언어 
DQL은 DML에 속한언어이기도 하다. 
데이터조회한 결과를 Result set(행들의 집합)이라고 한다.
->0개이상의 행이 포함될수 있고 , 특정기준에 의해 정렬될수 있다. 
*/
/*
@SELECT 기본 작성법
1. SELECT 컬럼명 FROM 테이블명;
2. SELECT 컬럼명 FROM 테이블명 WHERE 조건;

SELECT : 조회하고자하는 컬럼명을 기술, 여러개로 기술하고하하면, (쉼표)로 구분, 
        모든컬럼조회시 * 를 사용
FROM : 조회 대상 컬럼이 포함된 테이블 명을 기술 
WHERE: 행을 선택하는 조건을 기술 
       여러개의 제한조건을 포함할수있고 각 제한조건은 논리연산자로 연결, 제한조건에 만족하는 행들만 
       RESULT SET 에 포함됨
*/
--SELECT 기본문법연산자
--EMPLOYEE테이블에서 모든행 모든 컬럼 조회

SELECT * FROM EMPLOYEE;

--리터럴 : 임의로 지정한 문자열을 SELECT절에 사용하면 테이블에 존하는 데이터 처럼 사용할 수 있다.
--모든 행에 반복 표시된다.

SELECT
    EMP_ID
    , EMP_NAME
    , SALARY
    ,'원' 단위  --리터럴사용
FROM EMPLOYEE;

/*@ 비교 연산자
-> 표현식 사이의 관계를 비교하기 위해 사용하고, 비교 결과는 논리 결과중에 하나
(TRUE/FALSE/NULL)가 됨
-> 단, 비교하는 두 컬럼 값/표현식은 서로 동일한 데이터 타입이어야 함

	연산자			설명
	=			같다
	>,<			크다/작다
	>=,=<			크거나 같다/작거나 같다
	<>,!=,^=		같지 않다
	BETWEEN AND		특정 범위에 포함되는지 비교
	LIKE / NOT LIKE		문자 패턴 비교
	IS NULL / IS NOT NULL	NULL 여부 비교
	IN / NOT IN		비교 값 목록에 포함/미포함 되는지 여부 비교
	
	* <> 작거나 크다 즉, 같지 않다!*/

SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE,
    '재직중' 근무여부
FROM EMPLOYEE
WHERE 1=1
AND ENT_YN ='N';


--실습문제 
--1. JOB테이블에서 JOB_NAME의 정보만 출력되도록 하시오
SELECT JOB_NAME FROM JOB;
--2. DEPARTMENT테이블의 내용 전체를 출력하는 SELECT문을 작성하시오
SELECT * FROM DEPARTMENT;
--3. EMPLOYEE 테이블에서 이름(EMP_NAME),이메일(EMAIL),전화번호(PHONE),고용일(HIRE_DATE)
		만 출력하시오
SELECT 
    EMP_NAME,
    EMAIL,
    PHONE,
    HIRE_DATE
FROM EMPLOYEE;
    
--4. EMPLOYEE 테이블에서 고용일(HIRE_DATE) 이름(EMP_NAME),월급(EMP_NAME)를 출력하시오
SELECT
    HIRE_DATE,
    EMP_NAME,
    SALARY
FROM EMPLOYEE;
--5. EMPLOYEE 테이블에서 월급(SALARY)이 2,500,000원이상인 사람의
-- 	EMP_NAME 과 SAL_LEVEL을 출력하시오 (힌트 : >(크다) , <(작다) 를 이용)
SELECT
    EMP_NAME,
    SAL_LEVEL
FROM EMPLOYEE
WHERE SALARY >=2500000;
--6. EMPLOYEE 테이블에서 월급(SALARY)이 350만원 이상이면서 
--	JOB_CODE가 'J3' 인 사람의 이름(EMP_NAME)과 전화번호(PHONE)를 출력하시오
--	(힌트 : AND(그리고) , OR (또는))  
SELECT 
    EMP_NAME,
    PHONE
FROM EMPLOYEE
WHERE SALARY>=3500000 AND JOB_CODE ='J3';
--7. EMPLOYEE 테이블에서 이름,연봉, 총수령액(보너스포함), 실수령액(총 수령액-(월급*세금 3%))
--가 출력되도록 하시오
SELECT 
    EMP_NAME,
    SALARY * 12 AS 연봉,
    (SALARY + (SALARY* NVL(BONUS,0)))*12 총수령액,
    ((SALARY + (SALARY* NVL(BONUS,0)))*12) - (SALARY * 0.03*12) 실수령액
FROM EMPLOYEE;
--8. EMPLOYEE 테이블에서 이름, 근무 일수(반올림-ROUND)를 출력해보시오 (SYSDATE를 사용하면 현재 시간 출력)
SELECT
    EMP_NAME,
    ROUND(SYSDATE -HIRE_DATE),
    '일' 단위
FROM EMPLOYEE;
--9. EMPLOYEE 테이블에서 20년 이상 근속자의 이름,월급,보너스를 출력하시오
SELECT 
    EMP_NAME,
    SALARY,
    NVL(BONUS,0) BONUS
FROM EMPLOYEE
WHERE ROUND(SYSDATE -HIRE_DATE)>= 365*20;
--10.EMPLOYEE 테이블에서 고용일이 90/01/01 ~ 01/01/01 인 사원의
--전체 내용을 출력하시오
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';