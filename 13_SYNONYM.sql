-- 동의어 (SYNONYM)
-- 다른 데이터 베이스가 가진 객체에 대한 별명 혹은 줄임말
-- 여러사용자가 테이블을 공유할경우
-- 다른 사용자가 테이블에 접근할경우 사용자명.테이블명 으로 표현함
-- 동의어를 사용하면 간단하게 접근 가능
-- 삭제 : DROP SYNONYM EMP;
SELECT * FROM USER_SYNONYMS;
SELECT * FROM DBA_SYNONYMS WHERE SYNONYM_NAME = 'EMP';
-- 생성방법
--CREATE SYNONYM 줄임말 FOR 사용자명.객체명;
GRANT CREATE SYNONYM TO EMPLOYEE; --시스템계정에서 권한 주고 오기

CREATE SYNONYM EMP FOR EMPLOYEE;
SELECT * FROM EMP;
-- 동의어의 구분
--1. 비공개 동의어
-- 객체에대한 접근 권한을 부여 받은 사용자가 정의한 동의어
--2. 공개 동의어
-- 모든 권한을 주는 사용자(DBA)가 정의한 동의어
-- 모든 사용자가 사용할수 있음 (PUBLIC)
-- 예) DUAL

--시스템 계정에서 사용하기
SELECT * FROM EMPLOYEE.DEPARTMENT; --계정명.테이블이름
SELECT * FROM DEPARTMENT;            --그냥 테이블이름은 안됨
CREATE PUBLIC SYNONYM DEPT2 FOR EMPLOYEE.DEPARTMENT; --공개 동의어로 설정해서
--직원 계정
SELECT * FROM DEPT2; --직원, 시스템 둘다 조회가능

