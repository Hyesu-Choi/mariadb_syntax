-- case1 : author inner join post
-- 글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;  -- 테이블명 alias 로 선언한 경우 
select a.*, p.* from author a inner join post p on a.id=p.author_id; 

-- cass2 : post inner join author
-- 글쓴이가 있는 글과 해당 글의 글쓴이는 조회
select * from post p inner join author a on p.author_id=a.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출럭
select p.*, a.email from post p inner join author a on p.author_id=a.id;

-- case3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴 글이 있다면 글도 함께 조회하겠다
select * from author a left join post p on a.id=post.author_id; 

-- case4 : post left join author
-- 글을 모두 조회하되, 글쓴이가 있다면 글쓴이도 함께 조회
select * from post p left join author a on a.id=post.author_id; 

-- select from join on where 조건 group by having order by 셀프조인왜글해요

-- 실습)글쓴이가 있는 글 중에서 글의 제목,저자의 email, 저자의 나이을 출력하되, 저자의 나이가 30세 이상인 글만 출력
select p.title, a.email, a.age from post p inner join author a on p.author_id=a.id where a.age>=30; 

-- 실습)글의 저자의 이름이 빈값(null)이 아닌 글목록만을 출력.
select p.* from post p inner join author a on p.author_id=a.id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
SELECT b.BOOK_ID, a.AUTHOR_NAME, DATE_FORMAT(b.PUBLISHED_DATE, "%Y-%m-%d") as PUBLISHED_DATE 
from BOOK b inner join AUTHOR a on b.author_id=a.author_id 
where b.CATEGORY="경제" 
ORDER BY b.PUBLISHED_DATE ASC; 

-- 없어진 기록 찾기
SELECT ao.ANIMAL_ID, ao.NAME
FROM ANIMAL_OUTS ao left join ANIMAL_INS ai on ao.ANIMAL_ID=ai.ANIMAL_ID
WHERE ai.ANIMAL_ID is null
ORDER BY ao.ANIMAL_ID ASC;

-- union : 두 테이블의 select결과를 횡으로 결합
-- union시킬 때 컬럼의 개수와 컬럼의 타입이 같아야함(타입의 길이는 상관없음 타입만 같으면 됨)
select name, email from author union select title, contents from post;
-- union은 기본적으로 distinct 적용. 중복허용하려면 union all 사용.
select name, email from author union all select title, contents from post;

-- 서브쿼리 : select문 안에 또다른 select문을 서브쿼리함. join대체 가능
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록조회(중복제거)
select distinct a.* from author a inner join post p  on a.id=p.author_id;
-- null값은 in조건절에서 자동으로 제외
select * from author where id in(select author_id from post);

-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_count
select email, (select count(*) from post p where p.author_id=a.id ) as post_count from author a;

-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;  -- select * from author; 이거와 같은 쿼리

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
select author_id,count(*) from post group by author_id;  -- 글 쓴 사람만 카운팅. null은 null끼리 그룹핑됨
-- 회원별로 본인의 쓴 글의 개수를 출력.  ex)email, post_count (left join으로 풀이).. 이거 다시보기
select a.email, count(p.id) as post_count from author a left join post p on a.id=p.author_id group by a.email;  -- 회원테이블 기준으로 봤을때 본인이 쓴 글을 출력해야하니까 회원테이블 기준으로 조인을 해야함. 이메일을 출력해야하니까 이메일을 그룹핑함. 이메일은 중복 불가능임. 그래서 이메일로 그룹핑 해도 됨. 그러고 게시글에서 본인이 쓴 글의 개수를 카운트 해야하니까 p.id를 기준으로 카운트함.

-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
select min(age) from author;
select max(age) from author;
select round(avg(age), 3) from author;  -- 소수점 3번째 자리에서 반올림

-- group by와 집계함수
-- 회원의 이름별 회원숫자를 출력하고, 이름별 나이의 평균값을 출력하라
select name, count(*) as count, avg(age) as age from author group by name;

-- where와 group by
-- 날짜값이 null은 데이터는 제외하고, 날짜별 post 글의 개수 출력.
select date_format(created_time, '%Y-%m-%d') as date, count(*) from post where created_time is not null group by date_format(created_time, '%Y-%m-%d');

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기 
SELECT CAR_TYPE, count(CAR_ID) as CARS  
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS Like '%통풍시트%' or OPTIONS Like '%열선시트%' or OPTIONS Like '%가죽시트%'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE ASC;

-- 입양 시각 구하기(1)
SELECT hour(DATETIME) as HOUR, count(*) as COUNT  
FROM ANIMAL_OUTS
WHERE hour(DATETIME) between 9 and 19
GROUP BY HOUR
ORDER BY HOUR;

-- group by와 having : 둘은 항상 같이 다님. 그룹화해서 나온 데이터에 대해 집계값 구함.
-- having은 group by 를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상 쓴 사람 author_id 찾기
select author_id from post group by author_id having count(*) >=2; 

-- 동명 동물 수 찾기 -> having
SELECT NAME, count(*) as COUNT
FROM ANIMAL_INS 
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING count(*) >= 2
ORDER BY NAME ASC;

-- 카테고리 별 도서 판매량 집계하기 -> join까지
SELECT b.CATEGORY, SUM(bs.SALES) as TOTAL_SALES
FROM BOOK b LEFT JOIN BOOK_SALES bs ON b.BOOK_ID=bs.BOOK_ID
WHERE bs.SALES_DATE Like '2022-01%'
GROUP BY b.CATEGORY
ORDER BY b.CATEGORY ASC;

-- 조건에 맞는 사용자와 총 거래금액 조회하기 -> join까지
SELECT user.USER_ID, user.NICKNAME, sum(board.PRICE) as TOTAL_SALES
FROM USED_GOODS_USER user LEFT JOIN USED_GOODS_BOARD board on user.USER_ID=board.WRITER_ID
WHERE board.STATUS="DONE"
GROUP BY user.USER_ID 
HAVING TOTAL_SALES >=700000
ORDER BY TOTAL_SALES ASC;