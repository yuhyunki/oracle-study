-- �Լ� ���� ����
--1. ������� �ֹι�ȣ�� ��ȸ��
--  ��, �ֹι�ȣ 9��° �ڸ����� �������� '*'���ڷ� ä��
--  �� : ȫ�浿 771120-1******
SELECT
       EMP_NAME ������
     , RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') �ֹι�ȣ
  FROM EMPLOYEE;

--2. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT
       EMP_NAME ������
     , JOB_CODE �����ڵ�
     , TO_CHAR(((SALARY + SALARY * NVL(BONUS, 0)) * 12), 'L999,999,999') "����(��)"
  FROM EMPLOYEE;

--3. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������ 
--	��� ����� �μ��ڵ� �Ի��� ��ȸ
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , HIRE_DATE
     , EXTRACT(YEAR FROM HIRE_DATE)
  FROM EMPLOYEE
 WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5')
   AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

--4. ������, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
--  ��, �ָ��� ������
SELECT
       EMP_NAME
     , HIRE_DATE
     , LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "�Ի��� ���� �ٹ��ϼ�"
  FROM EMPLOYEE;

--5. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--  ��, ��������� �ֹι�ȣ���� �����ؼ�, 
--     ������ ������ �����Ϸ� ��µǰ� ��.
--  ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
SELECT
       EMP_NAME
     , DEPT_CODE
     , TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'), 'RR"��" MM"��" DD"��"') �������
     , FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD')) / 365) ����
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 3, 2) < 13
   AND SUBSTR(EMP_NO, 5, 2) < 32;

--6. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
--  �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�.
--  => to_char, decode, COUNT ���
--
--	-------------------------------------------------------------
--	��ü������   2001��   2002��   2003��   2004��
--	-------------------------------------------------------------
SELECT
       COUNT(*) ��ü������
     , COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE), 1, 2), '01', 1)) "2001��"
     , COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE), 1, 2), '02', 1)) "2002��"
     , COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE), 1, 2), '03', 1)) "2003��"
     , COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE), 1, 2), '04', 1)) "2004��"
  FROM EMPLOYEE;

--7.  �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ��
--  => case ���
--	�μ��ڵ� ���� �������� ������.
SELECT
       EMP_NAME
     , CASE
         WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
         WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
         WHEN DEPT_CODE = 'D9' THEN '������'
       END AS "�μ�"
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
    OR DEPT_CODE = 'D6'
    OR DEPT_CODE = 'D9'
 ORDER BY DEPT_CODE;


-- JOIN ��������

-- 1. 2020�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT
       TO_CHAR(TO_DATE('20201225', 'RRRRMMDD'), 'DAY') "2020�� 12�� 25����"
  FROM DUAL;

-- 2. �ֹι�ȣ�� 70��� ���̸鼭 ������ �����̰�, 
--    ���� ������ �������� �����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_NAME
     , E.EMP_NO
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J USING(JOB_CODE)
 WHERE TO_NUMBER(SUBSTR(EMP_NO, 1, 2)) BETWEEN 70 AND 80
   AND SUBSTR(EMP_NO, 8, 1) = '2'
   AND SUBSTR(EMP_NAME, 1, 1) = '��';

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , E.EMP_NO
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND TO_NUMBER(SUBSTR(EMP_NO, 1, 2)) BETWEEN 70 AND 80
   AND SUBSTR(EMP_NO, 8, 1) = '2'
   AND SUBSTR(EMP_NAME, 1, 1) = '��';

-- 3. ���� ���̰� ���� ������ ���, �����, 
--    ����, �μ���, ���޸��� ��ȸ�Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , 2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2)) "����"
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J USING(JOB_CODE)
 WHERE (2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2))) = (SELECT MIN(2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2)))
                                                          FROM EMPLOYEE E);
              
-- ORACLE ����
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , 2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2)) "����"
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND (2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2))) = (SELECT MIN(2023 - CONCAT('19', SUBSTR(E.EMP_NO, 1, 2)))
                                                          FROM EMPLOYEE E);

-- 4. �̸��� '��'�ڰ� ���� ��������
-- ���, �����, �μ����� ��ȸ�Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 WHERE E.EMP_NAME LIKE '%��%';

-- ����Ŭ ����
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
  FROM EMPLOYEE E
     , DEPARTMENT D
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.EMP_NAME LIKE '%��%';

-- 5. �ؿܿ������� �ٹ��ϴ� �����, 
--    ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
-- ANSIǥ��
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
  FROM EMPLOYEE E
  JOIN JOB J USING(JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 WHERE D.DEPT_ID BETWEEN 'D5' AND 'D7';

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.DEPT_ID BETWEEN 'D5' AND 'D7';

-- 6. ���ʽ�����Ʈ�� �޴� �������� �����, 
--    ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSIǥ��
SELECT
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.BONUS IS NOT NULL;

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.BONUS IS NOT NULL;

-- 7. �μ��ڵ尡 D2�� �������� �����, 
--    ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
  JOIN JOB J USING(JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.DEPT_CODE = 'D2';

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
     , LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = 'D2';

-- 8. ���� �޿� ����� �ּұ޿�(MIN_SAL)�� �ʰ��Ͽ� �޿��� �޴� ��������
--    �����, ���޸�, �޿�, ���ʽ����� ������ ��ȸ�Ͻÿ�.
--    ������ ���ʽ�����Ʈ�� �����Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , ((E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12) ����
  FROM EMPLOYEE E
  JOIN JOB J USING(JOB_CODE)
  JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL)
 WHERE E.SALARY > S.MIN_SAL;

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , ((E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12) ����
  FROM EMPLOYEE E
     , JOB J
     , SAL_GRADE S
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL
   AND E.SALARY > S.MIN_SAL;

-- 9. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� 
--    �����, �μ���, ������, �������� ��ȸ�Ͻÿ�.
-- ANSI ǥ��
SELECT
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  JOIN NATIONAL N USING(NATIONAL_CODE)
 WHERE NATIONAL_CODE = 'KO'
    OR NATIONAL_CODE = 'JP';

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     , NATIONAL N
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND (N.NATIONAL_CODE = 'KO' 
    OR N.NATIONAL_CODE = 'JP');

-- 10. ���� �μ��� �ٹ��ϴ� �������� �����, �μ��ڵ�, 
--     �����̸��� ��ȸ�Ͻÿ�.self join ���
-- ANSI ǥ��
SELECT
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME
  FROM EMPLOYEE E1
  JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
 WHERE E1.EMP_NAME != E2.EMP_NAME;

-- ����Ŭ ����
SELECT
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME
  FROM EMPLOYEE E1
     , EMPLOYEE E2
 WHERE E1.DEPT_CODE = E2.DEPT_CODE
   AND E1.EMP_NAME != E2.EMP_NAME;

-- 11. ���ʽ�����Ʈ�� ���� ������ �߿��� �����ڵ尡 
--     J4�� J7�� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�.
--     ��, join�� IN ����� ��
-- ANSI ǥ��
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J USING(JOB_CODE)
 WHERE JOB_CODE IN ('J4', 'J7')
   AND E.BONUS IS NULL;

-- ����Ŭ ����
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.JOB_CODE IN ('J4', 'J7')
   AND E.BONUS IS NULL;

--12. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
SELECT
       COUNT(CASE WHEN ENT_YN = 'N' THEN 1 END) ������
     , COUNT(CASE WHEN ENT_YN = 'Y' THEN 1 END) �����
  FROM EMPLOYEE;