--VIEW (뷰)
--SELECT 쿼리문을 저장한 객체이다
--실질적인 데이터를 저장하고 있지않음
--테이블을 사용하는 것과 동일하게 사용할수있다.
--매번 자주 사용하는 쿼리문을 정의 해 두고 싶을때 뷰를 생성
--VIEW 를 한번 만들어두고 마치 테이블처럼 사용한다고 생각!
--CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리 

--[OR REPLACE]: 뷰 생성시 기존에 중복된 뷰가 있다면 해당뷰를 변경하고 기존에 중복된 뷰가 없다면 새로 뷰를 생성
GRANT CREATE VIEW TO EMPLOYEE; -- 시스템계정에 가서 권한 부여하기!!

CREATE OR REPLACE VIEW V_EMP
    (사번, 이름, 부서)
    AS
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE;
    
SELECT * FROM V_EMP;
DROP VIEW V_EMP; -- 객체를 삭제 할 때는 DROP을 이용한다

--사번, 이름, 직급명, 부서명, 근무지역을 조회하고
--그 결과를 V_RESULT_EMP라는 뷰를 생성해서 저장하세요.

CREATE OR REPLACE VIEW V_RESULT_EMP
    AS
    SELECT 
        A.EMP_ID, 
        A.EMP_NAME, 
        B.DEPT_TITLE, 
        C.JOB_NAME, 
        D.LOCAL_NAME
    FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A. DEPT_CODE = B.DEPT_ID
    JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
    JOIN LOCATION D ON B.LOCATION_ID = D.LOCAL_CODE;
    
SELECT * FROM V_RESULT_EMP
WHERE EMP_ID ='205';

SELECT *
FROM SYS.USER_VIEWS; --뷰 정보를 확인하는 데이터 딕셔너리

COMMIT;

--베이스 테이블의 정보가 변경이되면 VIEW도 같이 변경
SELECT * 
FROM V_RESULT_EMP
WHERE EMP_ID ='205';

UPDATE EMPLOYEE
SET EMP_NAME='정중앙'
WHERE EMP_ID ='205';

ROLLBACK;

DROP VIEW V_RESULT_EMP;

--뷰 서브쿼리 안에서 연산의 결과도 포함이 가능하다 -별칭을 꼭 부여!
CREATE OR REPLACE VIEW V_EMP_JOB
(사번, 이름, 직급명, 성별, 근무년수)
AS
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME,
    DECODE(SUBSTR(A.EMP_NO,8,1),1,'남','여'),
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM A.HIRE_DATE)
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE; 

SELECT * FROM V_EMP_JOB;

CREATE OR REPLACE VIEW V_JOB
AS
SELECT
    JOB_NAME,
    JOB_CODE
FROM JOB;

SELECT * FROM V_JOB;
--생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE)사용가능
--뷰를 통해서 변경하게 되면 실제 데이터가 담겨있는 베이스 테이블에도 적용이 된다.

--뷰에 INSERT
INSERT INTO V_JOB
VALUES ('인턴','J8');

--뷰에 UPDATE
UPDATE V_JOB
SET JOB_NAME ='알바'
WHERE JOB_CODE='J8';

SELECT * FROM JOB;

--뷰에 DELETE
DELETE FROM V_JOB WHERE JOB_CODE='J8';

-- DML 명령어로 조작이 불가능한 경우
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
-- 2. 뷰에 포함되지 않은 컬럼 중에,
--    베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 3. 산술표현식으로 정의된 경우
-- 4. JOIN을 이용해 여러 테이블을 연결한 경우
-- 5. DISTINCT 포함한 경우
-- 6. 그룹함수나 GROUP BY 절을 포함한 경우


-- 1) 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS
SELECT JOB_CODE FROM JOB;
--뷰에 정의되어 있지 않은 컬럼(JOB_NAME)을 조작
INSERT INTO V_JOB2
(JOB_CODE, JOB_NAME) --ORA-00904: "JOB_NAME": invalid identifier
VALUES
('J8','인턴');

UPDATE V_JOB2
SET JOB_NAME='알바'
WHERE JOB_CODE='J8';

-- 2) 뷰에 포함되지 않은 컬럼 중에,
--    베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
CREATE OR REPLACE VIEW V_JOB3
AS
SELECT JOB_NAME FROM JOB;

INSERT INTO V_JOB3--cannot insert NULL into ("EMPLOYEE"."JOB"."JOB_CODE")
(JOB_NAME)
VALUES
('인턴');--뷰에 없는 컬럼(JOB_CODE)가 NOT NULL 제약조건이 걸려 있어서 에러

UPDATE V_JOB3
SET JOB_NAME='사원'
WHERE JOB_NAME='인턴';

SELECT * FROM V_JOB3;

DELETE FROM V_JOB3 WHERE JOB_NAME ='인턴';
-- 3) 산술표현(연산)식으로 정의된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS
SELECT
    EMP_ID,
    EMP_NAME,
    SALARY,
    (SALARY + (SALARY*NVL(BONUS,0)))*12 연봉
FROM EMPLOYEE;

SELECT * FROM EMP_SAL;
INSERT INTO EMP_SAL
VALUES(800,'정진훈',3000000,40000000);--ORA-01733: virtual column not allowed here
--연봉이 이미 계산이 되서 안됨

UPDATE EMP_SAL
SET 연봉 =80000000
WHERE EMP_ID ='200';--ORA-01733: virtual column not allowed here

--UPDATE (산술연산 컬럼과 무관한 컬럼을 UPDATE 하는 것은 가능)
UPDATE EMP_SAL
SET EMP_NAME = '정중하'
WHERE EMP_ID ='200';

ROLLBACK;

--DELETE 할 때는 사용가능 산술로도 가능
DELETE FROM EMP_SAL WHERE 연봉 =124800000;
ROLLBACK;

-- 4) JOIN을 이용해 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE =DEPT_ID;

SELECT * FROM V_JOINEMP WHERE EMP_ID='219';

INSERT INTO V_JOINEMP
VALUES
(888,'조세오','인사관리부');
--주 베이스 테이블에 같이 추가가 되기때문에 EMPLOYEE쪽에 INSERT불가능
--ORA-01776: cannot modify more than one base table through a join view

UPDATE V_JOINEMP
SET DEPT_TITLE='인사관리부'
WHERE EMP_ID=219;--ORA-01779: cannot modify a column which maps to a non key-preserved table

DELETE FROM V_JOINEMP WHERE EMP_ID=219;
ROLLBACK;

-- 5) DISTINCT 포함한 경우
CREATE OR REPLACE VIEW V_DT_EMP
AS
SELECT
    DISTINCT JOB_CODE FROM EMPLOYEE;
    
SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP
VALUES
    ('J9');-- ORA-01732: data manipulation operation not legal on this view
    
UPDATE V_DT_EMP
SET JOB_CODE = 'J9'
WHERE JOB_CODE='J7';

DELETE FROM V_DT_EMP WHERE JOB_CODE='J7';
-- 6) 그룹함수나 GROUP BY 절을 포함한 경우

CREATE OR REPLACE VIEW V_GROUPDEPT
AS
SELECT
    DEPT_CODE,
    SUM(SALARY) 합계
    , AVG(SALARY) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE;

INSERT INTO V_GROUPDEPT
VALUES
('D0',600000,400000);--ORA-01733: virtual column not allowed here

UPDATE V_GROUPDEPT
SET DEPT_CODE ='D7'
WHERE DEPT_CODE ='D1';-- ORA-01732: data manipulation operation not legal on this view

DELETE FROM V_GROUPDEPT WHERE DEPT_CODE='D1';
--ORA-01732: data manipulation operation not legal on this view

/* VIEW 옵션
    
    [상세 표현식]
    CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰명
    AS SUBQUERY
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE 옵션 : 기존에 동일한 뷰가 있을경우 덮어쓰고, 존재하지 않으면 새로이 생성시켜주는
    2) FORCE/NOFORCE 옵션
       FORCE : 서브쿼리에 기술된 테이블이 존재하지 않는 테이블이여도 뷰가 생성
       NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성 (생략시 기본값)
    3) WITH CHECK OPTION 옵션 : 서브쿼리에 기술된 조건에 부합하지 않은 값으로 수정하는 경우 오류 발생
    4) WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능 (DML 수행 불가)
*/

-- FORCE : 서브쿼리에 기술된 테이블이 존재하지 않는 테이블이여도 뷰가 생성-- 일반적으로 잘사용되지않음
--> 경고: 컴파일오류와 함께 뷰가 생성되었습니다. 

CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT
    TCODE,
    TNAME,
    TCONTENT
FROM TT;

SELECT * FROM V_EMP;

CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(30),
    TCONTENT VARCHAR2(20)
);

DROP TABLE TT;

--NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성 (생략시 기본값)
CREATE OR REPLACE /*FORCE*/ NOFORCE VIEW V_EMP --생성 불가
AS
SELECT
    TCODE,
    TNAME,
    TCONTENT
FROM TT;

--WITH CHECK OPTION 옵션 : 서브쿼리에 기술된 조건에 부합하지 않은 값으로 수정하는 경우 오류 발생
CREATE OR REPLACE VIEW VW_EMP2
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY>=3000000;

SELECT * FROM VW_EMP2;

UPDATE VW_EMP2
SET SALARY=2000000
WHERE EMP_ID =200;

ROLLBACK;

CREATE OR REPLACE VIEW VW_EMP2
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY>=3000000
WITH CHECK OPTION;

UPDATE VW_EMP2
SET SALARY=2000000
WHERE EMP_ID =200;
--ORA-01402: view WITH CHECK OPTION where-clause violation

UPDATE VW_EMP2
SET SALARY=4000000
WHERE EMP_ID =200;
ROLLBACK;

--WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능 (DML 수행 불가)
CREATE OR REPLACE VIEW V_DEPT
AS
SELECT * FROM DEPARTMENT
WITH READ ONLY ;

SELECT * FROM V_DEPT;

DELETE FROM V_DEPT;--ORA-42399: cannot perform a DML operation on a read-only view
