set serveroutput on; --출력 활성화
/*
--1. EX_EMPLOYEE테이블에서 사번 마지막번호를 구한뒤, +1한 사번에 사용자로 부터 입력받은 이름, 주민번호, 전화번호, 직급코드(J5), 급여등급(S5)를
    등록하는 PL/SQL을 작성하세요.
*/
select * from ex_employee;
    
declare
    ex_emp_id ex_employee.emp_id%type;
    ex_emp_name ex_employee.emp_name%type := '&이름';
    ex_emp_no ex_employee.emp_no%type := '&주민번호';
    ex_phone ex_employee.phone%type := '&전화번호';
    ex_job_code ex_employee.job_code%type := 'J5';
    ex_sal_level ex_employee.sal_level%type := 'S5';
begin
    select
        max(emp_id) +1
    into
        ex_emp_id
    from
        ex_employee;
        
    insert into
        ex_employee(emp_id,emp_name,emp_no,phone,job_code,sal_level)
    values
        (ex_emp_id,ex_emp_name,ex_emp_no,ex_phone,ex_job_code,ex_sal_level);
    
    commit;
    
    dbms_output.put_line('사번 : ' || ex_emp_id);
    dbms_output.put_line('이름 : ' || ex_emp_name);
    dbms_output.put_line('주민번호 : ' || ex_emp_no);
    dbms_output.put_line('전화번호 : ' || ex_phone);
    dbms_output.put_line('직급코드 : ' || ex_job_code);
    dbms_output.put_line('급여등급 : ' || ex_sal_level);
    
end;
/


/*
-- 2. 동전 앞뒤맞추기 게임 익명블럭을 작성하세요.
    -- dbms_random.value api 참고해 난수 생성할 것.
*/

declare
    user number := &1_앞_0_뒤;
    com number;
begin
    select
        floor(dbms_random.value(0,2)) --0,1
    into
        com
    from
        dual;
        
    if com = 1 then
        dbms_output.put_line('컴퓨터가 앞을 선택했습니다.');
    elsif com = 0 then
        dbms_output.put_line('컴퓨터가 뒤를 선택했습니다.');
    end if;
    
    if user = 1 then
        dbms_output.put_line('유저가 앞을 선택했습니다.');
    elsif user = 0 then
        dbms_output.put_line('유저가 뒤를 선택했습니다.');
    else
        dbms_output.put_line('앞(1),뒤(0)만 선택 가능합니다.');
    end if;
    
    if user = com then
        dbms_output.put_line('성공!');
    else
        dbms_output.put_line('실패!');
    end if;
end;
/