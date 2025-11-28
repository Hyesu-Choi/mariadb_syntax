-- insert : 테이블에 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values(데이터1, 데이터2, 데이터3);
-- 문자열은 일반적으로 작은따옴표사용
insert into author(id, name, email) values(4, 'lungzzi', 'lz@test.com');

-- update: 테이블에 데이터를 변경 (전체 업데이트 아니고 필요한 것만 변경/ui작업 추천)
update 테이블명 set 컬럼명="바꿀데이터" where 조건; 
update author set name='홍길동', email='ooo@test.com' where id=3;  // id가 3번인 데이터의 이름을 홍길동, 이메일을 ㅇㅇㅇ으로 변경할래.

-- delete : 삭제. 컬럼 한줄 삭제이기 때문에 컬럼명 안넣어도됨.데이터 몇개만 삭제하고 싶으면 update임. 조건 꼭 걸어야함.
delete from 테이블명 where 조건;
delete from author where id=4;

-- select : 조회
select 컬럼1, 컬럼2 from 테이블명;
select name, email from author;
-- *은 모든 컬럼을 의미
select * from author;

-- select 조건절(where) 활용.
select * from author where id=1;
select * from author where name='홍길동';
select * from author where id>2 and name="lung";
select * from author where id in (1,3,5);
-- 이름 홍길동 인 글쓴이가 쓴 글 목록을 조회하시오
select * from post where author_id in(select id from author where name='홍길동');

-- 중복제거해서 조회 : distinct
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순, desc : 내림차순, 안붙이면 오름차순ASC(default). 내림차순 정렬 필요한 경우에만 desc 작성함 asc는 보통 생략함
-- 아무런 정렬조건 없이 조회할 경우에는 pk기준 오름차순
select * from author order by name desc;

-- 멀티컬럼 order by : 여러컬럼으로 정렬시에, 먼저 쓴 컬럼 우선 정렬하고, 중복시 그 다음 컬럼으로 정렬 적용.
select * from author order by name desc, email asc;

-- 결과값 개수 제한
-- 가장 최근에 가입한 회원 1명만 조회
select * from author order by id desc limit 1;

-- 별칭(alias)를 이용한 select
select name as '이름', email as '이메일' from author;
select a.name, a.email from author as a;
select a.name, a.email from author a; // 위에랑 똑같은 문법

-- null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;

-- 프로그래머스 sql 문제풀이
-- 여러 기준으로 정렬하기
SELECT ANIMAL_ID, NAME, DATETIME from ANIMAL_INS ORDER BY NAME ASC, DATETIME DESC;
-- 상위 n개 레코드
SELECT NAME FROM ANIMAL_INS ORDER BY DATETIME ASC LIMIT 1;


