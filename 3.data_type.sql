-- tinyint : 1바이트 사용. -128~ 127까지의 정수 표현 가능.(unsigned시에 0~255 : 무조건 양의 정수만 씀)
-- author테이블에 age 컬럼 추가
alter table author add column age tinyint unsigned;
insert into author (id, name, email, age) values(6, '룽지', 'sdkdj@test.com', 300); // 300은 tinyint 범위 넘어가서 에러남

-- int : 4바이트 사용. 대략 40억 정수숫자범위 표현 가능.

-- bigint : 8바이트 사용. 
-- author, post테이블의 id값을 bigint로 변경
alter table post modify column author_id bigint;
alter table author modify column id bigint;
alter table post modify column id bigint;

-- decimal(총자리수, 소수부자리수)
alter table author add column height decimal(4,1);
-- 정상적으로 insert
insert into author(id, name, email, height) values(7, '룽지2', 'lz2@test.com', 179.3);
-- 데이터가 잘리도록 insert
insert into author(id, name, email, height) values(8, '룽지3', 'lz3@test.com', 179.3456);

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column id_number char(16);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지 경로를 varchar로 저장.
alter table author add column profile_image longblob;
insert into author(id, name, email, profile_image) values (9, "ass", "skfhj@naver.com", LOAD_FILE('C:\\hamster.jpg'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user';
-- enum에서 지정된 role을 insert
insert into author(id, name, email, role) values (10, '최룽지', 'asgssg@naver.com', 'admin');
-- enum에서 지정되지 않은 값을 insert
insert into author(id, name, email, role) values (11, '최룽지2', 'asgssg2@naver.com', 'super-admin');
-- role을 지정하지 않고 insert
insert into author(id, name, email) values (12, '최룽지3', 'asgssg3@naver.com');

-- date(연월일) datetime(연월일시분초)
-- 날짜타입의 입력, 수정, 조회시에는 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, contents, author_id, created_time) values(4, 'hello', 'sgsefsefsef', 1, "2019-1-1 14:00:04");
-- datetime과 default 현재시간 입력은 많이 사용되는 패턴
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, contents, author_id) values(5, 'hello', '룽지룽지', 1);

-- 비교연산자(3개 예제 다 똑같은 결과 반환함)
select * from author where id>=2 and id<=4;
select * from author where id in(2,3,4);
select * from author where id between 2 and 4;  -- 2,3,4

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드(중요 like %)
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp : 정규표현식을 활용한 조회
selecet * from author where name regexp '[a-z]';  -- 이름에 소문자 알파벳이 포함된 경우
selecet * from author where name regexp '[가-힣]';  -- 이름에 한글이 포함된 경우

-- cast : 타입변환 (잘 안씀)
-- 문자 -> 숫자
selecet cast('12' as unsigned);  -- 12 // int대신 unsigned 적음
-- 숫자 -> 날짜
select cast(20251121 as date); -- 2025-11-21
-- 문자 -> 날짜
select cast('20251121' as date); -- 2025-11-21

-- data_format : 날짜타입변환(Y, m, d, H, i, s)
select date_format(created_time, '%Y-%m-%d') from post;  -- 2025-11-12 00:00:00 -> 2025-11-12
select date_format(created_time, '%H-%i-%s') from post;  -- 2025-11-12 00:00:00 -> 2025-11-12
select * from post where date_format(created_time, '%Y')='2025';  -- 2025년에 등록된 게시글 조회
select * from post where date_format(created_time, '%m')='11';  -- 11월에 등록된 게시글 조회
select * from post where date_format(created_time, '%m')='01';  -- 1월 등록된 게시글 조회. 실무에서는 이런식으로 안하고 밑에처럼 함
select * from post where cast(date_format(created_time, '%m') as unsigned)=1;   -- 1월 등록된 게시글 조회

-- 실습 : 2025년 11월에 등록된 게시글 조회
select * from post where date_format(created_time, '%Y-%m')='2025-11';
select * from post where created_time like '2025-11%';  -- 이게 제일 편할듯 

-- 실습 : 2025년 11월 1일부터 11월 19일까지의 데이터 조회(날짜범위조회할때는 이 쿼리가 제일 편한함)
select * from post where created_time >= '2025-11-01' and created_time < '2025-11-20';  -- 2025-11-01에 사실은 00:00:00이 생략되어있는거

