-- 제약조건 : not null, unique(테이블 컬럼 중에 여러개 지정 가능), foreign key, primary key(테이블 컬럼중에에 딱 하나 지정 가능)
-- not null 제약 조건 추가
alter table author modify column name varchar(255) not null;

-- not null 제약 조건 제거
alter table author modify column name varchar(255);

-- not null, unique 동시 추가
alter table author modify column email varchar(255) not null unique;
-- unique 제거 : index에서 제거

-- pk/fk 추가/제거
-- pk 제약조건 삭제
alter table post drop primary key;
-- fk 제약조건 삭제
alter table post drop foreign key fk명; -- fk명 조회 : select * from information_schema.key_column_usage where table_name='post';
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

-- default 옵션
-- 어떤 컬럼이든 dafault 지정이 가능하지만, 일반적으로 enum타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';  -- 이름 입력 안하면 anonymous로 추가한다
-- auto_increment : 숫자값을 입력 안했을때,  마지막에 입력된 가장 큰 값에 +1만큼 자동으로 증가된 숫자값 자동으로 적용(아이디값에 자주 씀)
alter table author modify column id bigint auto_increment;

-- uuid타입
alter table post add column user_id char(36) default (uuid());