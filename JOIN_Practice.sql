-- 1. 직급이 대리이면서 ASIA지역에 근무하는 직원들의
--    사번, 사원명, 직급명, 부서명, 근무지역명, 급여를 조회하시오
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

-- 2. 70년대생이면서 여자이고, 성이 전씨인 직원들의
--    사원명, 주민번호, 부서명, 직급명을 조회하시오
SELECT
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON C.JOB_CODE = A.JOB_CODE
WHERE SUBSTR(A.EMP_NO, 1,2) LIKE '7%'
AND A.EMP_NAME LIKE '전%';

-- 3. 이름에 '형'자가 들어있는 직원들의
--    사번, 사원명, 직급명을 조회하시오
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE A.EMP_NAME LIKE '%형%';

-- 4. 해외영업팀에 근무하는 직원들의
--    사원명, 직급명, 부서코드, 부서명을 조회하시오
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    B.DEPT_ID 부서코드,
    C.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON C.JOB_CODE = A.JOB_CODE
WHERE B.DEPT_TITLE LIKE '해외영업%';

-- 5. 보너스를 받는 직원들의
--    사원명, 보너스, 연봉, 부서명, 근무지역명을 조회하시오
SELECT
    A.EMP_NAME 사원명,
    NVL(A.BONUS,0) 보너스,
    (A.SALARY+(A.SALARY*NVL(A.BONUS,0)))*12 연봉,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON  B.LOCATION_ID = C.LOCAL_CODE
WHERE A.BONUS IS NOT NULL AND BONUS !=0;

-- 6. 부서가 있는 직원들의
--    사원명, 직급명, 부서명, 근무지역명을 조회하시오
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON  A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE;

-- 7. '한국'과 '일본'에 근무하는 직원들의 
--    사원명, 부서명, 근무지역명, 근무국가명을 조회하시오
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명,
    C.NATIONAL_CODE 근무국가명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID=C.LOCAL_CODE
WHERE C.NATIONAL_CODE IN ('KO','JP');

-- 8. 보너스를 받지 않는 직원들 중 직급코드가 J4 또는 J7인 직원들의
--    사원명, 직급명, 급여를 조회하시오
SELECT
    A.EMP_NAME 사원명,
    A.SALARY 급여,
    B.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE (BONUS IS NULL OR BONUS=0)
AND B.JOB_CODE IN ('J4','J7');
    

-- 9. 사번, 사원명, 직급명, 급여등급, 구분을 조회하는데
--    이때 구분에 해당하는 값은
--    급여등급이 S1, S2인 경우 '고급'
--    급여등급이 S3, S4인 경우 '중급'
--    급여등급이 S5, S6인 경우 '초급' 으로 조회되게 하시오.
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.SAL_LEVEL 급여등급,
    CASE
        WHEN (C.SAL_LEVEL IN ('S1','S2')) THEN '고급'
        WHEN (C.SAL_LEVEL IN ('S3','S4')) THEN '중급'
        ELSE '초급'
    END 구분
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN SAL_GRADE C ON A.SALARY BETWEEN C.MIN_SAL AND C.MAX_SAL
ORDER BY C.SAL_LEVEL;

-- 10. 각 부서별 총 급여합을 조회하되
--     이때, 총 급여합이 1000만원 이상인 부서명, 급여합을 조회하시오
SELECT
    A.DEPT_TITLE 부서명,
    SUM(B.SALARY) 급여합
FROM DEPARTMENT A
JOIN EMPLOYEE B ON B.DEPT_CODE = A.DEPT_ID
GROUP BY ROLLUP(DEPT_TITLE)
HAVING SUM(B.SALARY)>=10000000 AND A.DEPT_TITLE IS NOT NULL;

-- 11. 각 부서별 평균급여를 조회하여 부서명, 평균급여 (정수처리)로 조회하시오.
--      단, 부서배치가 안된 사원들의 평균도 같이 나오게끔 하시오.
SELECT
    A.DEPT_TITLE 부서명,
    FLOOR(AVG(B.SALARY)) 평균급여
FROM DEPARTMENT A
JOIN EMPLOYEE B ON B.DEPT_CODE = A.DEPT_ID
GROUP BY ROLLUP (DEPT_TITLE);
