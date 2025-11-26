-- 회원 테이블 생성
-- id(pk, auto_increment, bigint), email(unique, not null), name(not null), password(not null)
create table author(id bigint auto_increment primary key, email varchar(255) not null unique, name varchar(255) not null, password varchar(255) not null);  

-- 주소 테이블 생성
-- id, country(notnull), city(notnull), street(notnull), author_id(fk, notnull)
create table address(id bigint auto_increment primary key, country varchar(255) not null, city varchar(255) not null, street varchar(255) not null, author_id bigint not null unique, foreign key(author_id) references author(id));

-- post 테이블
-- id, title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 복합키를 이용한 연결(junction) 테이블 생성
create table author_post_list(author_id bigint not null, post_id bigint not null, primary key(author_id, post_id), foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 회원가입 및 주소생성
insert into author(email, name, password) values('asas@test.com', '홍길동', '1234567');
insert into address(country, city, street, author_id ) values('korea', 'busan', 'jangdong', 4 )

-- 글쓰기
insert into post(title, contents) values("hello1", "hello1 hello1 hello1.....");
insert into post(title, contents) values("hello2", "hello2 hello2 hello2.....");
insert into author_post_list(author_id, post_id) values(1, 1)
insert into author_post_list(author_id, post_id) values(2, 1)

-- 글 전체 목록조회하기 : 제목,내용, 글쓴이이름이 조회가 되도록 select 쿼리(distinct 처리)  글 3개 있음. 
select * from post inner join author_post_list on xx inner join author on xx;

select p.title, p.contents, a.name 
from post p 
inner join author_post_list apl on p.id=apl.post_id
inner join author a on a.id=apl.author_id; 