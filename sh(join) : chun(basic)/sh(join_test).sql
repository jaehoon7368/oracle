-- sh계정
-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select
    to_char(to_date('2020/12/25','yyyy/mm/dd'),'day') 요일
from
    dual;
    
/*
2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
사원명, 주민번호, 부서명, 직급명을 조회하시오.
*/
select
    emp_name 사원명,
    emp_no 주민번호,
    dept_code 부서명,
    job_code 직급명
from
    employee
where
    substr(emp_no,1,1) = '7'
    and substr(emp_no,8,1) in ('2','4')
    and substr(emp_name,1,1) = '전';
    
-- 3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
select * from employee;
select
    e.emp_id "사번",
    e.emp_name "사원명",
    v.no_min 나이,
    e.dept_code 부서명,
    e.job_code 직급명
    
from
    employee e cross join 
    (select min(extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2))) no_min from employee) v
where
    substr(e.emp_no,1,2) = '07';
 
-- 4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select * from employee;
select
    emp_id 사번,
    emp_name 사원명,
    dept_code 부서명
from
    employee
where
    emp_name like '%형%';
    
-- 5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select * from department;
select
    e.emp_name 사원명,
    j.job_name  직급명,
    e.dept_code 부서코드,
    d.dept_title  부서명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join job j
    on e.job_code = j.job_code
where
    d.location_id in ('L2','L3','L4');

-- 6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select * from location;
select * from department;
select
    e.emp_name 사원명,
    e.bonus 보너스포인트,
    d.dept_title 부서명,
    l.local_name 근무지역명
from
   employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
where
    e.bonus is not null;
    
-- 7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    d.dept_title 부서명,
    l.local_name 근무지역명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
    join job j
    on e.job_code = j.job_code
where
    e.dept_code = 'D2';
    
/*
8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
*/
select * from sal_grade;
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary 급여,
    e.salary * 12 연봉
from
    employee e join sal_grade s
    on e.sal_level = s.sal_level
    join job j
    on e.job_code = j.job_code
where
    e.salary > s.max_sal;
    
/*
9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
사원명, 부서명, 지역명, 국가명을 조회하시오.
*/
select * from job;
select
    e.emp_name 사원명,
    d.dept_title 부서명,
    l.local_name 지역명,
    l.national_code 국가명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
where
    l.national_code in ('KO','JP');
    
/*
10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
self join 사용
*/
select dept_code from employee;

select
    e.emp_name 사원명,
    e.dept_code 부서코드,
    v.emp_name 동료이름
from
    employee e cross join (select emp_name,dept_code from employee) v
where
    e.dept_code = v.dept_code
    and e.emp_name != v.emp_name;
    
-- 11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary 급여
from
    employee e join job j
    on e.job_code = j.job_code
where
    j.job_name in ('차장', '사원')
    and
    e.bonus is null;
    
-- 12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select * from employee;
select
    sum(decode(quit_yn,'N',1)) 재직중,
    sum(decode(quit_yn,'Y',1)) 퇴사
from
    employee;


    

   