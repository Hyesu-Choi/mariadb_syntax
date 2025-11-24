-- read uncommitted: 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습 절차
-- 1) 워크벤츠에서 auto_commit 해제. update실행. commit 하지 않음.(transaction1)

-- 2) 터미널을 열어서 selected했을 때 위 update 변경사항이 읽히는지 확인(transaction2)

-- 결론 : mariaDb는 기본이 repeatable read 이므로 dirty read 발생X.

-- read committed : 커밋한 데이터만 read 가능 -> phantom read 발생(또는 non-repeatable read)
-- 실습 절차
-- 1) 워크벤치에서 아래 코드 실행
start transaction;
select count(*) from author;  --13개
do sleep(15);  -- 15초 쉬는 도중에 재빨리 터미널에서 insert
select count(*) from author;  -- 13개
commit;
-- 2) 터미널을 열어 아래 코드 실행
insert into author(email) values('fgjdhfs@test.com');

-- repeatable read : 읽기의 일관성 보장 -> lost update 문제 발생 -> 배타lock(배타적 작금)으로 해결★
-- lost update 문제 발생하는 상황
DELIMITER //  --프로시저 선언
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2;
    do sleep(15);  -- 터미널 명령어 실행
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ; -- 프로시저 생성

call concurrent_test1();  -- 프로시저 실행
-- 터미널에서는 아래 코드 실행
select post_count from author where id=2;  -- lock을 안걸어서 조회가 되버림.이게 조회가 되버리는게 문제임.

-- 배타락을 통해 lost update 문제를 해결한 상황
-- select for update를 하게 되면 트랙잭션이 실행되는 동안 lock이 걸리고,트랜잭션이 종료된 후에 lock 풀림.
DELIMITER //  --프로시저 선언
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2 for update;
    do sleep(15);  
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ;

call concurrent_test2();  
-- 터미널에서는 아래 코드 실행
select post_count from author where id=2 for update;  -- 바로 조회안됨. 앞의 concurrent_test2 프로시저의 절차가 끝나야 조회가 됨.

-- serializable