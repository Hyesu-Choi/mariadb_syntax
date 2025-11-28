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
insert into address(country, city, street, author_id ) values('korea', 'busan', 'jangdong', (select id from author order by id desc limit 1))  -- 방금 insert한거 최근 1개 id넣음..
insert into address(country, city, street, author_id ) values('korea', 'busan', 'jangdong', 4)  -- 귀찮으니까 이렇게 해도됨

-- 글쓰기
-- 최초 생성자
insert into post(title, contents) values("hello1", "hello1 hello1 hello1.....");
insert into author_post_list(author_id, post_id) values(1, (select id from post from post order by desc limit 1)); 
--추후참여자
-- update ...
insert into post(title, contents) values("hello2", "hello2 hello2 hello2.....");

insert into author_post_list(author_id, post_id) values(2, 1);

-- 글 전체 목록조회하기 : 제목,내용, 글쓴이이름이 조회가 되도록 select 쿼리(distinct 처리)  글 3개 있음. 
select p.title, p.contents, a.name 
from post p 
inner join author_post_list apl on p.id=apl.post_id  --참여자의 아이디 얻기
inner join author a on a.id=apl.author_id; -- 참여자의 이름 얻기


---- 실습 --------
-- - (실습)주문(order) ERD 설계 및 DB 구축
--     - 서비스 요구사항
--         - 회원가입
--             - 판매자, 일반사용자 구분 필요
--         - 상품 등록
--             - 재고 컬럼은 필수, 판매자가 누군지 기록 필요
--         - 주문하기
--             - 한번에 여러상품을 여러개 주문할수 있는 일반적인 주문서비스
--             - 한 주문을 조회했을때 어떤 상품들을 주문했는지 조회 가능해야함
--         - 그외
--             - 상품정보 조회, 주문상세조회 등
--     - 주의사항
--         - user테이블(사용자), order테이블(주문), product테이블(상품) 등 컬럼, 테이블 설계 추가 자유
--         - 실제 웹서비스를 제공한다 가정하고 추가(insert), 조회(select) 값에 적절한 테스트 필요
--         - 각 서비스 단계별로 테스트 쿼리 생성 필요
-- DDL
show databases;
create database orders;
use orders;
create table user(id bigint auto_increment not null primary key, name varchar(255) not null, role enum('buyer', 'seller') not null default 'buyer', email varchar(255) not null, address varchar(255) not null, password varchar(255));  
create table product(id bigint auto_increment not null primary key, seller_id bigint not null, product_name varchar(255) not null, stock int not null, price int not null, foreign key(seller_id) references user(id));
create table orders(id bigint auto_increment not null primary key, buyer_id bigint not null, order_date datetime not null default current_timestamp(), total_price int not null, foreign key(buyer_id) references user(id));
create table orders_detail(id bigint auto_increment not null primary key, order_id bigint not null, product_id bigint not null, order_quantity int not null, price int not null, foreign key(order_id) references orders(id), foreign key(product_id) references product(id));

-- DML
-- 회원가입
insert into user(name, role, email, address, password) values('홍길동', 'seller', 'test1@test.com', '서울시 관악구', '123123');
insert into user(name, role, email, address, password) values('최혜수', 'seller', 'test2@test.com', '서울시 동작구', '12341234');
insert into user(name, role, email, address, password) values('최룽지', 'buyer', 'test3@test.com', '서울시 성북구', 'qwe123');
insert into user(name, email, address, password) values('김마루', 'test4@test.com', '서울시 구로구', 'asdfqwr');

-- 상품 등록
insert into product(seller_id, product_name, stock, price) values(2, '사과', 100, 200);
insert into product(seller_id, product_name, stock, price) values(2, '딸기', 50, 500);

-- 주문하기 트랜잭션
start transaction;
insert into orders(buyer_id, total_price) values(3, 0);  -- 주문생성
insert into orders_detail(order_id, product_id, order_quantity, price) values(  -- 주문상세추가
(select id from orders order by id desc limit 1), 1, 2, (select price from product where id=1));  
update product set stock=(select stock from product where id=1) - 2 where id=1;  -- 재고 업데이트
insert into orders_detail(order_id, product_id, order_quantity, price) values(
(select id from orders order by id desc limit 1), 2, 5, (select price from product where id=2));  -- 주문상세추가
update product set stock=(select stock from product where id=2) - 5 where id=2; -- 재고 업데이트
UPDATE orders  -- 주문 총상품금액 업데이트
SET total_price = (SELECT SUM(order_quantity * price) FROM orders_detail WHERE order_id = (SELECT id FROM orders ORDER BY id DESC LIMIT 1))
WHERE id = (SELECT id FROM orders ORDER BY id DESC LIMIT 1);
commit;  -- 주문추가 트랜잭션 끝

-- 주문 정보 조회(상품명, 상품 가격, 주문수량, 총주문금액, 주문일시, 판매자이름)
select o.id, p.product_name, p.stock, od.price, od.order_quantity, o.total_price, o.order_date, (select name from user where id=p.seller_id) as 판매자이름
from orders o inner join orders_detail od on o.id=od.order_id  
inner join product p on od.product_id=p.id
where o.id=1;

-- 상품 정보조회
select * from product;