/*
1. 사번을 입력받고, 관리자에 대한 성과급을 지급하려하는 익명블럭 작성
    - 관리하는 사원이 5명이상은 급여의 15% 지급 : '성과급은 ??원입니다.'
    - 관리하는 사원이 5명미만은 급여의 10% 지급 : ' 성과급은 ??원입니다.'
    - 관리하는 사원이 없는 경우는 '대상자가 아닙니다.'
*/
select * from employee;
select manager_id,count(*) from employee group by manager_id;

declare
    e_emp_id employee.emp_id%type := '&사번';
    cnt_emp_id number;
    e_manager_sal employee.salary%type;
    e_manager_total_sal employee.salary%type;
begin
    select
        manager_id,
        count(*)
    into
        e_emp_id,
        cnt_emp_id
    from
        employee
    where
        manager_id = e_emp_id
    group by
        manager_id;
        
    select
        salary
    into
        e_manager_sal
    from
        employee
    where
        emp_id = e_emp_id;
        
    case
        when cnt_emp_id >= 5 then 
            e_manager_total_sal := e_manager_sal * 1.15;
            dbms_output.put_line('성과급은 ' || e_manager_total_sal || '원입니다.');
       when cnt_emp_id < 5 then 
            e_manager_total_sal := e_manager_sal * 1.1;
            dbms_output.put_line('성과급은 ' || e_manager_total_sal || '원입니다.');
    end case;

exception
    when no_data_found then dbms_output.put_line('대상자가 아닙니다.');
    
end;
/
set serveroutput on; -- 출력 활성화

/*
2. TBL_NUMBER 테이블에 0~99사이의 난수를 100개 저장하고, 입력된 난수의 합계를 출력하는 익명블럭을 작성하세요.

TBL_NUMBER테이블(sh 계정)을 먼저 생성후 작업하세요.
- id number pk : sequence객체 생성후 채번할것.
- num number : 난수
- reg_date date : 기본값 현재시각
*/
create table tbl_number(
    id number,
    num number,
    reg_date date default sysdate,
    constraint pk_tbl_number_id primary key (id)
);

create sequence seq_tbl_number_id
start with 1
increment by 1;

declare
    ran number;
    sum_no number := 0;
begin
    for i in 1..100 loop
            ran := trunc(dbms_random.value(0, 100));
            
            insert into tbl_number values(seq_tbl_number_id.nextval, ran, default);
            
            sum_no := sum_no + ran;

        end loop;
    commit;
    dbms_output.put_line('합계 : '|| sum_no);
    
end;
/
select * from tbl_number;

/*
3.주민번호를 입력받아 나이를 리턴하는 저장함수 fn_age를 사용해서 사번, 이름, 성별, 연봉, 나이를 조회
*/
create or replace function fn_age(
    emp_no employee.emp_no%type
)
return number
is
    age number;
    emp_year number;
begin
    case substr(emp_no,8,1)
        when '1' then emp_year := 1900;
        when '2' then emp_year := 1900;
        else emp_year := 2000;
    end case;
    age := extract(year from sysdate) - emp_year - substr(emp_no,1,2) +1;
    return age;
end;
/

select
    emp_id 사번,
   emp_name 이름,
    fn_gender(emp_no) 성별,
    fn_calc_annual_pay(salary,nvl(bonus,0)) 연봉,
    fn_age(emp_no) 나이
from
    employee;
    
/*
4. 특별상여금을 계산하는 함수 fn_calc_incentive(salary, hire_date)를 생성하고, 사번, 사원명, 입사일, 근무개월수(n년 m월), 특별상여금 조회
* 입사일 기준 10년이상이면, 급여 150%
* 입사일 기준 10년 미만 3년이상이면, 급여 125%
* 입사일 기준 3년미만, 급여 50%
*/
select months_between(sysdate,hire_date) /12 from employee;
create or replace function fn_calc_incentive(
    salary employee.salary%type,
    hire_date employee.hire_date%type
)
return number
is
    fn_year number;
    fn_incentive number;
begin
    fn_year := months_between(sysdate,hire_date) /12;
    
    if fn_year < 3 then fn_incentive := salary *0.5;
    elsif fn_year < 10 then fn_incentive := salary * 1.25;
    elsif fn_year >= 10 then fn_incentive := salary * 1.5;
    end if;
    return fn_incentive;
end;
/

select
    emp_id 사번,
    emp_name 사원명,
    hire_date 입사일,
    trunc(months_between(sysdate,hire_date) /12) || '년' || trunc(mod(months_between(sysdate,hire_date) /12,1) *12) || '월' 근무개월,
    fn_calc_incentive(salary, hire_date) 특별상여금
from
    employee;