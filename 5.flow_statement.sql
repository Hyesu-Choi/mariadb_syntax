-- 흐름제어 : if, ifnull, case when
-- if(a,b,c) : a조건이 참이면 b반환, 그렇지 않으면 c반환
select id, if(name is null, '익명사용자', name) as name from author;

-- ifnull(a,b) : a가 null 이면 b를 반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자') as name from author;

-- case when end
select id,
case 
    when name is null then '익명사용자'
    when name='hong1' then '홍길동1'
    when name='hong2' then '홍길동2'
    else name(생략가능)
end as name
from author;

-- 경기도에 위치한 식품창고목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS,if(FREEZER_YN is null, 'N', FREEZER_YN) as FREEZER_YN FROM FOOD_WAREHOUSE where ADDRESS like '경기도%' ORDER BY WAREHOUSE_ID ASC; 
-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
CASE 
    WHEN STATUS='SALE' THEN '판매중'
    WHEN STATUS='RESERVED' THEN '예약중'
    WHEN STATUS='DONE' THEN '거래완료'
END AS STATUS
from USED_GOODS_BOARD
WHERE CREATED_DATE LIKE '2022-10-05'
ORDER BY BOARD_ID DESC;
-- 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IF(TLNO is null, 'NONE', TLNO) AS TLNO
FROM PATIENT
WHERE AGE <= 12 and GEND_CD='W'
ORDER BY AGE DESC, PT_NAME ASC; 