/*
1. EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가 
TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.
*/
-- TBL_EMP_JOIN 테이블 생성 : QUIT_DATE, QUIT_YN 제외

    CREATE TABLE TBL_EMP_JOIN
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'N';

    SELECT * FROM TBL_EMP_JOIN;
    
--TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사

    CREATE TABLE TBL_EMP_QUIT
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'Y';

    SELECT * FROM TBL_EMP_QUIT; 
    
create or replace trigger trig_tbl_emp_quit
    before
    delete on TBL_EMP_JOIN
    for each row
begin
    if deleting then
        insert into
            TBL_EMP_QUIT(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE)
        values(
             :old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code, :old.sal_level, :old.salary, :old.bonus,
            :old.manager_id, :old.hire_date, sysdate
        );
    end if;
end;
/

delete from tbl_emp_join where emp_id = '200';

/*
2. 사원변경내역을 기록하는 emp_log테이블을 생성하고, ex_employee 사원테이블의 insert, update가 있을 때마다 신규데이터를 기록하는 트리거를 생성하라.
* 로그테이블명 emp_log : 컬럼 log_no(시퀀스객체로부터 채번함. pk), log_date(기본값 sysdate, not null), ex_employee테이블의 모든 컬럼
* 트리거명 trg_emp_log
*/
create table emp_log
as
select * from ex_employee where 1=2;

alter table emp_log
add(
    log_no number,
    log_date date default sysdate not null,
    constraint pk_emp_log_no primary key(log_no)
);



create sequence seq_emp_log;

create or replace trigger trg_emp_log
    before
    insert or update on ex_employee
    for each row
begin
    if inserting then
        insert into
            emp_log
        values(
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log.nextval, sysdate
        );
                
    elsif updating then
        insert into
            emp_log
        values(
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log.nextval, sysdate
        );
    end if;
end;
/

select * from emp_log;
select * from ex_employee;

update ex_employee set dept_code = 'D7' where emp_id = '202';