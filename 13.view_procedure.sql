-- view: 실제 데이터를 참조만 하는 가상의 테이블, select 만 가능  ... 테이블과 유사한데 조회만 됨.
-- 사용목적 : 1)권한분리 2)복잡한쿼리를 사전생성

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email from post p inner join author a on p.author_id on p.author_id;

-- view 조회(테이블 조회와 동일)
select * from view명;
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view 삭제
drop view author_view;

-- 프로시저 생성
delimiter // 
create procedure hello_procedure()
begin
    select "hello world";
end
// delimiter ;  

-- 프로시저호출 .. ui에 번개표시 클릭
call 프로시저명();
call hello_procedure();  -- 스키마 선택되어있으면
call board.hello_procedure();  -- 스키마 선택 안되있으면

-- 프로시저 삭제
drop procedure 프로시저명();
drop procedure hello_procedure();

-- 회원목록 조회 프로시저생성 -> 한글명 프로시저 가능
delimiter // 
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;  

-- 회원상세조회 -> input(매개변수)값 여러개 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력
delimiter // 
create procedure 회원상세조회(in idInput bigint)  -- 매개변수 여러개 입력받을 수 있음
begin
    select * from author where id=idInput;
end
// delimiter ; 

-- 전체 회원수 조회 -> 변수 사용
delimiter // 
create procedure 전체회원수조회()
begin
    declare authorCount bigint;  -- 변수선언
    select count(*) into authorCount from author;  -- into를 통해 변수에 값 할당
    select authorCount; -- 변수값 사용
end
// delimiter ;

-- 글쓰기
delimiter // 
-- 사용자가 title, contents, 본인의 email 값을 입력
create procedure 글쓰기(in titleInput varchar(255), in contentsInput varchar(3000), in emailInput varchar(255))
begin
    -- begin밑에 declare를 통해 변수 선언
    declare authorId bigint;
    declare postId bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외관련 특수문법 ..프로시저가 실행하는 동안 에러가 발생하면 즉시 중단하고 기존에 했던 작업을 rollback한다
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into authorId from author where email=emailInput;
        insert into post(title, contents) values (titleInput, contentsInput); 
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(authorId, postId);
    commit;
end
// delimiter ;

-- 글삭제 -> if else문
delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

-- 대량글쓰기 -> while문을 통한 반복문
delimiter // 
create procedure 대량글쓰기(in count bigint, in emailInput varchar(255))
begin
    declare authorId bigint;
    declare postId bigint;
    declare countValue bigint default 0;
    while countValue<count do
        select id into authorId from author where email=emailInput;
        insert into post(title) values ('안녕하세요'); 
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(authorId, postId);
        set countValue = countValue+1;
    end while;
end
// delimiter ;

10
abc@naver.com