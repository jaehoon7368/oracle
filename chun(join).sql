/*
--1. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
*/
select * from tb_student;
select * from tb_professor;
select
    s.student_no 학번,
    s.student_name 학생명,
    nvl(p.professor_name,'없음') 담당교수
    
from
    tb_student s left join tb_professor p
    on s.coach_professor_no = p.professor_no;
    
--2. 학과별 교수명과 인원수를 모두 표시하세요.
select * from tb_department; 
select * from tb_professor;    
select
    d.department_name 학과,
    p.professor_name 교수명,
    count(*) 인원수
from
    tb_department d join tb_professor p
    on d.department_no = p.department_no
group by
    d.department_name,
    p.professor_name;
    
/*
-- 3. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
*/
select * from tb_student;
select * from tb_grade;
select
     s.student_name 학생명,
     s.student_no 학번,
     round(avg(point)*100)/100 평균학점
from
    tb_student s join tb_grade g
    on s.student_no = g.student_no
group by
    s.student_name,
    s.student_no
having
    s.student_name like '%람%';
   
--4. 학생별 다음정보를 구하라.
-- (group by 없는 단순 조회)
/*
--------------------------------------------
학생명  학기     과목명    학점
-------------------------------------------
감현제    200702    치과분자약리학    4.5
감현제    200701    구강회복학    4
            .
            .
--------------------------------------------
*/
select * from tb_student;
select * from tb_class; 
select * from tb_grade;
select
    s.student_name 학생명,
    g.term_no 학기,
    c.class_name 과목명,
    g.point 학점
from
    tb_student s join tb_grade g
    on s.student_no = g.student_no
    join tb_class c
    on g.class_no = c.class_no
order by
    1,2;