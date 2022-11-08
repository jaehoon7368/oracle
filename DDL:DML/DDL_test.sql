-- DDL
-- 1. 계열 정보를 저장핛 카테고리 테이블을 맊들려고 핚다. 다음과 같은 테이블을
-- 작성하시오.
create table tb_category(
    name varchar2(10),
    use_yn char(1) default 'Y'
);

/*
2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
*/
create table tb_class_type(
    no varchar2(5),
    name varchar2(10),
    constraint pk_class_type_name primary key(name)
);

/*
3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
(KEY 이름을 생성하지 않아도 무방함. 맊일 KEY 이를 지정하고자 핚다면 이름은 본인이
알아서 적당핚 이름을 사용핚다.)
*/
alter table tb_category
add constraint pk_category_name primary key(name);

/*
4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
*/
alter table tb_category
modify name not null;

/*
5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
NAME 인 것은 마찪가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
*/
alter table 
    tb_class_type
modify
    (no varchar2(10),name varchar2(20));
    
alter table 
    tb_category
modify
    name varchar2(20);
    
/*
6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에
붙은 형태로 변경한다.
(ex. CATEGORY_NAME)
*/
alter table
    tb_category
rename column use_yn to category_use_yn;

alter table
    tb_category
rename column name to category_name;

alter table
    tb_class_type
rename column no to class_type_no;

alter table
    tb_class_type
rename column name to class_type_name;

/*
7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이
변경하시오.
Primary Key 의 이름은 ‚PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )
*/
alter table
    tb_category
rename constraint pk_category_name to pk_category_name;

alter table
    tb_class_type
rename constraint pk_class_type_name to pk_class_type_name;

/*
8. 다음과 같은 INSERT 문을 수행한다.
*/
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 

/*
9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은
FK_테이블이름_컬럼이름으로 지정핚다. (ex. FK_DEPARTMENT_CATEGORY )
*/
alter table
    tb_department
add constraint fk_department_category foreign key(category) references tb_category(category_name);

/*
10. 춘 기술대학교 학생들의 정보맊이 포함되어 있는 학생일반정보 VIEW 를 맊들고자 핚다.
아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오
*/
grant create view to chun;
create or replace view vw_학생일반정보
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student;
    
/*
11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행핚다.
이를 위해 사용핛 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 맊드시오.
이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
*/
select * from tb_department;
create or replace view vw_지도면담
as
select
    student_name 학생이름,
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    nvl((select nvl(professor_name,'지도교수없음') from tb_professor where professor_no =s.coach_professor_no),'지도교수없음') 지도교수이름
from
    tb_student s
order by
    학과이름;
    
/*
12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자.
*/
create or replace view vw_학과별학생수
as
select
    (select department_name from tb_department where department_no = s.department_no) DEPARTMENT_NAME,
    count(*) STUDENT_COUNT
from
    tb_student s
group by
    department_no
order by
    department_name;
    
/*
13. 위에서 생성핚 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인
이름으로 변경하는 SQL 문을 작성하시오.
*/
select * from vw_학생일반정보;

update
    vw_학생일반정보
set
    학생이름 = '유재훈'
where
    학번 = 'A213046';
    
/*
14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
어떻게 생성해야 하는지 작성하시오.
*/
create or replace view vw_학생일반정보
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student
with read only;

-- 15.최근 5년은 특정년도를 기술하지 않고, 년도값 추출후 rownum을 이용해 선택함.
--데이터상 최근 5년 2009, 2008, 2007, 2006, 2005
SELECT 년도
FROM (
    SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
    FROM TB_GRADE
    ORDER BY 1 DESC
    )
WHERE ROWNUM <= 3;

--과목번호, 과목이름 -> tb_class
--수강생수 -> tb_grade

SELECT 
    *
FROM (
        SELECT 
            CLASS_NO 과목번호, 
            CLASS_NAME 과목이름, 
            COUNT(STUDENT_NO) "수강생수(명)"
        FROM TB_CLASS 
            LEFT JOIN TB_GRADE  
                USING (CLASS_NO)
        WHERE 
            SUBSTR(TERM_NO, 1, 4) IN ( 
                                        SELECT 년도
                                        FROM (
                                                SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
                                                FROM TB_GRADE
                                                ORDER BY 1 DESC
                                            )
                                        WHERE ROWNUM <= 3
                                    )
        GROUP BY CLASS_NO, CLASS_NAME
        ORDER BY 3 DESC, 1)
WHERE ROWNUM <= 3;
