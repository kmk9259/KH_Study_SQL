-- 실습문제 --
-- 도서관리 프로그램을 만들기 위한 테이블들 만들기 --
-- 이때, 제약조건에 이름을 부여할 것 
--      각 컬럼에 주석달기

-- 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER) 
-- 컬럼 : PUB_NO(출판사번호) -- 기본키(PUBLISHER_PK)
--        PUB_NAME(출판사명) -- NOT NULL(PUBLISHER_NN)
--        PHONE(출판사전화번호) -- 제약조건 없음

-- 3개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(20) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(30)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명 ';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';

INSERT INTO TB_PUBLISHER
VALUES (1,'A출판사','02-1234-5678');
INSERT INTO TB_PUBLISHER
VALUES (2,'B출판사','02-9874-6542');
INSERT INTO TB_PUBLISHER
VALUES (3,'C출판사','02-1234-5679');

SELECT * FROM TB_PUBLISHER;

CREATE TABLE TB_BOOK(
    BK_NO  NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(20) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(30) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER,
    CONSTRAINT BOOK_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER(PUB_NO) ON DELETE CASCADE
);
COMMENT ON COLUMN TB_BOOK.BK_NO  IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE  IS '도서명 ';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE  IS '가격 ';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

INSERT INTO TB_BOOK
VALUES (1,'AA','가가가',10000,1);
INSERT INTO TB_BOOK
VALUES (2,'BB','나나나',20000,2);
INSERT INTO TB_BOOK
VALUES (3,'CC','다다다',30000,3);
INSERT INTO TB_BOOK
VALUES (4,'DD','라라라',40000,3);
INSERT INTO TB_BOOK
VALUES (5,'EE','마마마',50000,3);
SELECT * FROM TB_BOOK;

DROP TABLE TB_MEMBER;
CREATE TABLE TB_MEMBER(
    MEMBER_NO  NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER VARCHAR2(10) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN ('M','F')),
    ADDRESS VARCHAR2(30)  ,
    PHONE VARCHAR2(30),
    STATUS VARCHAR2(10) DEFAULT 'N' CONSTRAINT MEMBER_CK_STA CHECK(STATUS IN ('N','Y')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);
COMMENT ON COLUMN TB_MEMBER.MEMBER_NO  IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID  IS '아이디 ';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME  IS '회원명 ';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS  IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE  IS '연락처 ';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE  IS '가입일 ';

INSERT INTO TB_MEMBER
VALUES (1,'user01','u1','김김김','M','서울시','010-123-456','Y','16/09/01');
INSERT INTO TB_MEMBER
VALUES (2,'user02','u2','이이이','F','서울시','010-123-456','N','16/09/02');
INSERT INTO TB_MEMBER
VALUES (3,'user03','u3','박박박','F','서울시','010-123-456','N','16/09/03');
INSERT INTO TB_MEMBER
VALUES (4,'user04','u4','최최최','M','서울시','010-123-456','Y','16/09/04');
INSERT INTO TB_MEMBER
VALUES (5,'user05','u5','유유유','M','서울시','010-123-456','N','16/09/05');

SELECT * FROM TB_MEMBER;
UPDATE TB_MEMBER SET STATUS='Y';
CREATE TABLE TB_RENT(
    RENT_NO  NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER,
    CONSTRAINT RENT_FK_MEM FOREIGN KEY(RENT_MEM_NO) REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE CASCADE,
    RENT_BOOK_NO NUMBER,
    CONSTRAINT RENT_FK_BOOK FOREIGN KEY(RENT_BOOK_NO) REFERENCES TB_BOOK(BK_NO) ON DELETE CASCADE,
    RENT_DATE DATE DEFAULT SYSDATE
);
COMMENT ON COLUMN TB_RENT.RENT_NO  IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO  IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE  IS '대여일';


INSERT INTO TB_RENT
VALUES (1,1,1,'16/09/01');

INSERT INTO TB_RENT
VALUES (2,2,2,'16/09/02');

INSERT INTO TB_RENT
VALUES (3,3,3,'16/09/03');

SELECT * FROM TB_RENT;