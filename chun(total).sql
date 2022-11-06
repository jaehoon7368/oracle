/*
1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고,
정렬은 이름으로 오름차순 표시하도록 한다.
*/
select
    student_name "학생 이름",
    student_address 주소지
from
    tb_student;
    
--2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
select
    student_name,
    student_ssn
from
    tb_student
where
    absence_yn = 'Y'
order by
    student_ssn desc;
    
/*
3. 주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번,
주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번",
"거주지 주소" 가 출력되도록 핚다.
*/
select
    student_name 학생이름,
    student_no 학번,
    student_address "거주지 주소"
from
    tb_student
where
    (student_address like '%경기_%' or student_address like '%강원_%')
    and substr(student_no,1,1) = '9';
    
/*
4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을
작성하시오. (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아
내도록 하자)
*/
select * from tb_department;
select
    professor_name,
    professor_ssn
from
    tb_professor
where
    department_no = (select department_no from tb_department where department_name = '법학과')
order by
    professor_ssn asc;
    
/*
5. 2004 년 2 학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이
높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을
작성해보시오.
*/
select * from tb_grade;   
select
    student_no,
    point
from
    tb_grade
where
    term_no = '200402' and class_no = 'C3118100'
order by
    point desc;

/*
6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL
문을 작성하시오.
*/
select
    student_no,
    student_name,
    (select department_name from tb_department where department_no = s.department_no)
from
    tb_student s
order by
    student_name;

--7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
select * from tb_class;
select
    c.class_name,
    d.department_name
from
    tb_class c join tb_department d
    on c.department_no = d.department_no;
    
/*
8. 과목별 교수 이름을 찾으려고 핚다. 과목 이름과 교수 이름을 출력하는 SQL 문을
작성하시오.
*/
select * from tb_class_professor;
select
    (select class_name from tb_class where class_no = p.class_no),
    (select professor_name from tb_professor where professor_no = p.professor_no)
from
    tb_class_professor p;
    
/*
9. 8 번의 결과 중 ‘인문사회’ 계열에 속핚 과목의 교수 이름을 찾으려고 핚다. 이에
해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
*/
select
    c.class_name,
    p.professor_name
from
    tb_class_professor cp join tb_class c
    using(class_no)
    join tb_professor p
    using(professor_no)
where
    p.department_no in (select department_no from tb_department where category = '인문사회');

/*
10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름",
"전체 평점"을 출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1 자리까지만
반올림하여 표시한다.)
*/
select
    student_no 학번,
    (select student_name from tb_student where student_no = g.student_no) "학생이름",
    round(avg(g.point),1) 전체평점
from
    tb_grade g join tb_class c
    on g.class_no = c.class_no
where
    c.department_no = (select department_no from tb_department where department_name = '음악학과')
group by
    student_no;
    
/*
11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기
위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을
작성하시오. 단, 출력헤더는 ‚학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로
출력되도록 한다.
*/
select
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    student_name 학생이름,
    (select professor_name from tb_professor where professor_no = s.coach_professor_no) 지도교수이름
from
    tb_student s
where
    student_no = 'A313047';
    
/*
12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기름 표시하는
SQL 문장을 작성하시오.
*/
select
    (select student_name from tb_student where student_no = g.student_no),
    term_no 
from
    tb_grade g
where
    substr(term_no, 1, 4) = '2007'
    and
    class_no = (select class_no from tb_class where class_name = '인간관계론');
    
/*
13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못핚 과목을 찾아 그 과목
이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
*/
select * from tb_class;
select
    c.class_name,
    (select department_name from tb_department where department_no = c.department_no)
from
    tb_class c left join tb_class_professor cp
    on c.class_no = cp.class_no
    left join tb_professor p
    on cp.professor_no = p.professor_no
where
    cp.professor_no is null
    and
    c.department_no in (select department_no from tb_department where category = '예체능');
    
/*
14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과
지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정‛으로
표시하도록 하는 SQL 문을 작성하시오. 단, 출력헤더는 ‚학생이름‛, ‚지도교수‛로
표시하며 고학번 학생이 먼저 표시되도록 한다.
*/
select
    s.student_name 학생이름,
    nvl(p.professor_name,'지도교수 미지정')지도교수
from
    tb_student s left join tb_professor p
    on s.coach_professor_no = p.professor_no
where
    s.department_no = (select department_no from tb_department where department_name = '서반아어학과')
order by
    s.student_no;
    
/*
15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과
이름, 평점을 출력하는 SQL 문을 작성하시오.
*/
with avg_student
as(
    select
        student_no,
        avg(point) avg
    from
        tb_grade
    group by
        student_no
)
select
    s.student_no 학번,
    s.student_name 이름,
    (select department_name from tb_department where department_no = s.department_no) 학과,
    a.avg
from
    tb_student s join avg_student a
    on s.student_no = a.student_no
where
    avg >= 4.0
    and s.absence_yn = 'N';
    
-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
select
    c.class_no,
    c.class_name,
    avg(g.point)
from
    tb_class c join tb_grade g
    on c.class_no = g.class_no
where
    c.department_no = (select department_no from tb_department where department_name = '환경조경학과')
    and
    c.class_type like '%전공__%'
group by
    c.class_no, c.class_name;
    
/*
17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는
SQL 문을 작성하시오.
*/
select
    student_name,
    student_address
from
    tb_student
where
    department_no = (select department_no from tb_student where student_name = '최경희');
    
/*
18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을
작성하시오.
*/
select
    rownum,
    student_name,
    student_no
from(
    select
        s.student_no,
        s.student_name,
        avg(point)
    from
        tb_student s join tb_grade g
        on s.student_no = g.student_no
    where
        s.department_no = (select department_no from tb_department where department_name = '국어국문학과')
    group by
        s.student_no, s.student_name
    order by
        avg(point) desc
    )
where
    rownum = 1;
    
/*
19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을
파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
"전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록
한다.
*/
select
    d.department_name "계열 학과명",
    round(avg(g.point), 1) 전공평점
from
    tb_grade g join tb_class c
    on g.class_no = c.class_no
    join tb_department d
    on c.department_no = d.department_no
where
    d.category = (select category from tb_department where department_name = '환경조경학과')
group by
    d.department_name
order by
    d.department_name;