-- mariadb 서버에 접속(db gui툴로 접속시에는 커넥션 객체 생성하여 연결)
mariadb -u root -p  -- 엔터 후 비밀번호 별도 입력

-- 스키마(database) 생성
create database board;

-- 스키마 삭제
drop database board;

-- 스키마 목록 조회
show databases;

-- 스키마 선택
use 스키마명;

-- 문자 인코딩 세팅 조회(외울필요없음)
show variables like 'character_set_server';

-- 문자 인코딩 변경
alter database board default character set = utf8mb4;

-- 테이블 목록 조회(테이블 목록 조회하려면 스키마 선택하고 조회해야함)
show tables;

-- SQL문은 대문자가 관례이고, 시스템에서 대소문자를 구분하지는 않음. 
-- 테이블명/컬럼명 등은 소문자가 관례이고, 대소문자가 차이가 있으니 꼭 소문자로 만들어야함.
-- 테이블 생성(DDL)
-- create table 테이블명(컬럼명 자료형(자료크기) (키), ...)
CREATE TABLE author(id int primary key, name varchar(255), email varchar(255), password varchar(255)); 
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255)); 

-- 테이블 컬럼정보 조회
describe 테이블명;
describe author;

-- 테이블 데이터 전체조회
select * from 테이블명;
select * from author;

-- 테이블 생성 명령문 조회(안중요)
show create table author;

-- posts테이블 신규 생성(id, title, contents, author_id)
create table posts(id int, title varchar(255), contents varchar(255), author_id int, primary key(id), foreign key(author_id) references author(id));


-- 테이블의 참조 제약 조건 조회:describe 테이블로는 관계형을 정확히 할 수 없어서 이런식으로 조회함
select * from information_schema.key_column_usage where table_name='posts';

-- 테이블 index 조회 : 위에껄로 조회하는게 제일 정확하고 간접적으로 확인하고 싶으면 이 명령어
show index from 테이블명;
show index from posts;

-- alter : 테이블의 구조를 변경
-- 테이블의 이름 변경
alter table 기존테이블명 rename 신규테이블명;
alter table posts rename post;

-- 테이블의 컬럼 추가
alter table 테이블명 add column 추가컬럼명 타입 [추가조건]
alter table post add column age int;


-- 테이블의 컬럼 삭제
alter table 테이블명 drop column 삭제할컬럼명;
alter table post drop column age;

-- 테이블의 컬럼명 변경
alter table 테이블명 change column 변경할컬럼명 변경컬럼명 변경컬럼타입 [추가조건];
alter table post change column contents content varchar(255);

-- 테이블 컬럼의 타입과 제약조건 변경
alter table 테이블명 modify column 컬럼명 타입;
alter table post modify column content varchar(3000);
alter table author modify column email varchar(255) not null unique;

-- 실습1. author테이블에 address 추가(varchar 255). name은 not null 로 변경.
alter table author add column address varchar(255);
alter table author modify column name varchar(255) not null;

-- 실습2. post테이블에 title을 not null로 변경. content는 contents로 이름 변경.
alter table post modify column title varchar(255) not null;
alter table post change column content contents varchar(3000);

-- 테이블 삭제
drop table 테이블명;
drop table abc;

-- 일련의 쿼리를 실행시킬때 특정 쿼리에서 에러가 나지않도록 if exists를 많이 사용
drop table if exists abc;