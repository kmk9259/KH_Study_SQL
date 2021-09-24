--1
INSERT INTO TB_CLASS_TYPE
VALUES ('01','전공필수');
INSERT INTO TB_CLASS_TYPE
VALUES ('02','전공선택');
INSERT INTO TB_CLASS_TYPE
VALUES ('03','교양필수');
INSERT INTO TB_CLASS_TYPE
VALUES ('04','교양선택');
INSERT INTO TB_CLASS_TYPE
VALUES ('05','논문지도');

--2
CREATE TABLE TB_학생일반정보
AS
(
    SELECT
        STUDENT_NO 학번,
        STUDENT_NAME 학생이름,
        STUDENT_ADDRESS 주소
    FROM TB_STUDENT
);

--3
CREATE TABLE TB_국어국문학과
AS
(
    SELECT
        A.STUDENT_NO 학번,
        A.STUDENT_NAME 학생이름,
        TO_CHAR(TO_DATE(SUBSTR(A.STUDENT_SSN,1,2),'RR'),'RRRR') 출생년도,
        B.PROFESSOR_NAME 교수이름
    FROM TB_STUDENT A
    JOIN TB_PROFESSOR B ON A.COACH_PROFESSOR_NO = B.PROFESSOR_NO
    WHERE A.DEPARTMENT_NO = (
                            SELECT
                                DEPARTMENT_NO
                            FROM TB_DEPARTMENT
                            WHERE DEPARTMENT_NAME='국어국문학과'
                            )
);

--4
UPDATE TB_DEPARTMENT 
SET CAPACITY = ROUND(CAPACITY*1.1);

--5
UPDATE TB_STUDENT 
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE student_no='A413042';

COMMIT;

--6
ROLLBACK;
UPDATE TB_STUDENT 
SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6);

SELECT
    STUDENT_SSN
FROM TB_STUDENT;

--7
UPDATE TB_GRADE
SET POINT = '3.5'
WHERE (STUDENT_NO) = (SELECT
                            A.STUDENT_NO
                        FROM TB_STUDENT A
                        JOIN TB_DEPARTMENT B ON A.DEPARTMENT_NO = B.DEPARTMENT_NO
                        WHERE A.STUDENT_NAME='김명훈'
                        AND B.DEPARTMENT_NAME LIKE '의학%'
                      )
AND TERM_NO = '200501';

COMMIT;
--08
ROLLBACK;
DELETE FROM TB_GRADE
WHERE STUDENT_NO IN (   
                    SELECT STUDENT_NO
                    FROM TB_STUDENT
                    WHERE ABSENCE_YN = 'Y'
                    );

SELECT
    ABSENCE_YN  
FROM  TB_STUDENT;          
