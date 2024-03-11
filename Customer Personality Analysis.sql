/*결측치 처리
UPDATE customer
SET Income = (
    SELECT AVG(Income)
    FROM customer
    WHERE education = customer.education
)
WHERE Income =0;
*/

/* 데이터 확인
SELECT * 
FROM customer
LIMIT 100
*/

/*학력 수준에 따른 가구소득
SELECT education, round(AVG(income)) avg_income
FROM customer
GROUP BY education
ORDER BY avg_income
*/

/*최근 2년간 품목별 지출액
SELECT AVG(mntwines) avg_wines, AVG(mntfruits) avg_fruits, AVG(mntmeatproducts) avg_meat, 
AVG(mntfishproducts) avg_fish, AVG(mntsweetproducts) avg_sweet, AVG(mntgoldprods) avg_gold
FROM customer 
*/

/* 고객 연령 이상치 파악
SELECT year_birth
FROM customer
ORDER BY year_birth
LIMIT 10 
*/

/*고객 연령대 파악
WITH age AS (
select 2021 - year_birth age
FROM customer
)
SELECT 
      CASE WHEN age < 30 THEN '20대'
		     WHEN age BETWEEN 30 AND 39 THEN '30대'
           WHEN age BETWEEN 40 AND 49 THEN '40대'
           WHEN age BETWEEN 50 AND 59 THEN '50대'
           WHEN age BETWEEN 60 AND 69 THEN '60대'
           WHEN age BETWEEN 70 AND 81 THEN '70대 이상'
           when age > 81 then '이상치'
      END AS age_group
      ,COUNT(*) cnt
FROM age
GROUP BY age_group
*/

/*캠패인 별 할인금액으로 구매한 횟수
SELECT AcceptedCmp1, AVG(numdealspurchases) avg_pur
FROM customer
GROUP BY AcceptedCmp1 
*/

/*구매 경로 분석
SELECT avg(NumWebPurchases) avg_web, avg(NumCatalogPurchases) avg_catalog, 
avg(NumStorePurchases) avg_store
FROM customer
*/

/*
SELECT YEAR, MONTH, DAY, recency
FROM customer
LIMIT 100
*/

/* 마지막 구매 후 경과 일 수와 불만 간의 관계
SELECT complain, AVG(recency) avg_recency, COUNT(*) cnt
FROM customer
GROUP BY complain
*/

/* recency 최대,최소,평균
SELECT MAX(recency) max_recency, MIN(recency) min_recency, AVG(recency) avg_recency
FROM customer
*/

/*마지막 구매 후 경과 일 수 분포
SELECT CASE WHEN recency < 10 THEN '10일 미만'
		      WHEN recency BETWEEN 10 AND 19 THEN '10일 이상 20일 미만'
            WHEN recency BETWEEN 20 AND 29 THEN '20일 이상 30일 미만'
            WHEN recency BETWEEN 30 AND 39 THEN '30일 이상 40일 미만'
            WHEN recency BETWEEN 40 AND 49 THEN '40일 이상 50일 미만'
            WHEN recency BETWEEN 50 AND 59 THEN '50일 이상 60일 미만'
            WHEN recency BETWEEN 60 AND 69 THEN '60일 이상 70일 미만'
            WHEN recency BETWEEN 70 AND 79 THEN '70일 이상 80일 미만'
            WHEN recency BETWEEN 80 AND 89 THEN '80일 이상 90일 미만'
            WHEN recency BETWEEN 90 AND 99 THEN '90일 이상 100일 미만'
      END AS recency_group
   ,COUNT(*) cnt
FROM customer
GROUP BY recency_group
*/

/* 임의  일자 기준으로 마지막 구매 일자 계산
SELECT recency, 
DATE_ADD(DATE('2021-12-12'), INTERVAL recency DAY) AS last_purchase_date
FROM customer
WHERE recency IS NOT null
*/

/* 마지막 구매 일자 연도와 월별로 그룹화
SELECT DATE_FORMAT(DATE_SUB(DATE('2021-12-12'), 
INTERVAL recency DAY), '%Y-%m') AS last_purchase, COUNT(*) cnt
FROM customer
WHERE recency IS NOT NULL
GROUP BY last_purchase
*/

/*할인 구매 횟수와 재방문 간 관계
SELECT numdealspurchases, AVG(recency) avg_recency, COUNT(*) cnt
FROM customer
GROUP BY numdealspurchases
*/

/*홈페이지 방문 횟수와 재방문 간 관계
SELECT numwebvisitsmonth, AVG(recency) avg_recency, COUNT(*) cnt
FROM customer
GROUP BY numwebvisitsmonth
*/

/*홈페이지 구매 횟수와 재방문 간 관계
SELECT numwebpurchases, AVG(recency) avg_recency
FROM customer
GROUP BY numwebpurchases
*/

/*카탈로그 구매 횟수와 재방문 간 관계
SELECT numcatalogpurchases, AVG(recency) avg_recency
FROM customer
GROUP BY numcatalogpurchases
*/

/*매장 구매 횟수와 재방문 간 관계
SELECT numstorepurchases, AVG(recency) avg_recency, COUNT(*) cnt
FROM customer
GROUP BY numstorepurchases
*/

/*캠패인 별 수락 수
SELECT SUM(AcceptedCmp1) sum_cmp1, SUM(AcceptedCmp2) sum_cmp2, SUM(AcceptedCmp3) sum_cmp3,
SUM(AcceptedCmp4) sum_cmp4, SUM(AcceptedCmp5) sum_cmp5, SUM(response) sum_response
FROM customer
*/

/*캠패인 별 수락 시 재방문
SELECT AVG(case when AcceptedCmp1 = 1 then recency ELSE NULL END) as cmp1_recency,
AVG(case when AcceptedCmp2 = 1 then recency ELSE NULL END) as cmp2_recency,
AVG(case when AcceptedCmp3 = 1 then recency ELSE NULL END) as cmp3_recency,
AVG(case when AcceptedCmp4 = 1 then recency ELSE NULL END) as cmp4_recency,
AVG(case when AcceptedCmp5 = 1 then recency ELSE NULL END) as cmp5_recency,
AVG(case when response = 1 then recency ELSE NULL END) as response
FROM customer
*/

/*캠패인 수락 횟수 별 재방문
SELECT cmp_num, AVG(recency) as avg_recency, COUNT(*) cnt
FROM (
SELECT AcceptedCmp1+AcceptedCmp2+AcceptedCmp3+
AcceptedCmp4+AcceptedCmp5+response AS cmp_num, recency
FROM customer
) AS cmp

GROUP BY cmp_num
*/



/*churn 열 추가*/
/*ALTER TABLE customer ADD COLUMN churn INT*/
/*UPDATE customer SET churn 
= (case when recency > 90 then 1 ELSE 0 END)*/

/* recency 90일 이상 기준 이탈자 고객 수와 비율
SELECT
	churn,
	COUNT(*) AS cnt,
	COUNT(*) / (SELECT COUNT(*) FROM customer) AS ratio
FROM customer
GROUP BY churn
*/

/* 연령대별 이탈자 수와 비율
WITH agedata AS (
	SELECT 
      CASE WHEN age < 30 THEN '20대'
		     WHEN age BETWEEN 30 AND 39 THEN '30대'
           WHEN age BETWEEN 40 AND 49 THEN '40대'
           WHEN age BETWEEN 50 AND 59 THEN '50대'
           WHEN age BETWEEN 60 AND 69 THEN '60대'
           WHEN age >= 70  THEN '70대 이상'
      END AS age_group
      ,churn
	FROM (
		select
			2021 - year_birth AS age,
			churn
		from
			customer
	) AS subquery
)
SELECT 	
	age_group,
	COUNT(*) AS cnt, 
	COUNT(*) / (SELECT COUNT(*) FROM agedata WHERE churn = 1) AS ratio 
FROM agedata
WHERE churn = 1
GROUP BY age_group 
*/

/* 연령대 내 이탈자 비율
SELECT 
	1/28 '20대 이탈자 비율',
	34/318 '30대 이탈자 비율',
	63/654 '40대 이탈자 비율',
	60/585 '50대 이탈자 비율',
	50/473 '60대 이탈자 비율',
	10/181 '70대 이상 이탈자 비율'
*/	

/*결혼 여부별 이탈자 비율
with churndata AS (
	SELECT marital_status, COUNT(*) churn_cnt
	FROM customer
	where churn = 1
	GROUP BY marital_status
),
totaldata AS (
	SELECT marital_status, COUNT(*) total_cnt
	FROM customer
	GROUP BY marital_status
)
SELECT
	churndata.marital_status,
	churndata.churn_cnt,
	totaldata.total_cnt, 
	COALESCE(churndata.churn_cnt, 0) / totaldata.total_cnt AS ratio
FROM totaldata inner JOIN churndata 
ON totaldata.marital_status = churndata.marital_status
*/

/* 이탈자와 비이탈자의 소득 차이
SELECT churn, round(AVG(income),2) avg_income
FROM customer
GROUP BY churn
*/

/* 이탈자는 불만이 많은가
SELECT 
	churn, 
	complain, 
	COUNT(*) cnt
FROM customer
GROUP BY churn,complain
*/	


/* 할인 구매와 이탈자
SELECT churn, AVG(numdealspurchases) avg_deal
FROM customer
GROUP BY churn
*/

/*이탈자의 평균 지출액
WITH mnt AS (
	SELECT 
   	MntWines + MntFruits + MntMeatProducts 
		+ MntFishProducts + MntSweetProducts 
		+ MntGoldProds AS mnt,
		churn
	FROM customer
)
SELECT churn, AVG(mnt) avg_mnt
FROM mnt		
GROUP BY churn
*/


/*이탈자의 품목별 지출액
SELECT 
	churn,  
	AVG(mntwines) avg_wines, 
	AVG(mntfruits) avg_fruits, 
	AVG(mntmeatproducts) avg_meat, 
	AVG(mntfishproducts) avg_fish, 
	AVG(mntsweetproducts) avg_sweet, 
	AVG(mntgoldprods) avg_gold
FROM customer
GROUP BY churn 
*/

/*이탈자와 구매경로
SELECT 
	churn,
	avg(NumWebPurchases) avg_web, 
	avg(NumCatalogPurchases) avg_catalog, 
	avg(NumStorePurchases) avg_store
FROM customer
GROUP BY churn
*/

/*이탈자의 홈페이지 방문횟수
SELECT 
	churn,
	avg(numwebvisitsmonth) avg_webvisit 
FROM customer
GROUP BY churn
*/

/*이탈자의 자녀수
SELECT 
	churn,
	avg(kidhome) avg_kid,
	AVG(teenhome) avg_teen 
FROM customer
GROUP BY churn
*/


/* 이탈자의 캠페인 수락 수
SELECT 
	churn, AVG(cmp_num) avg_cmp
FROM (
	SELECT 
	AcceptedCmp1+AcceptedCmp2+AcceptedCmp3+
	AcceptedCmp4+AcceptedCmp5+response AS cmp_num, 
	churn
FROM customer
) AS cmp
GROUP BY churn
*/

/*캠페인 별 이탈자수
SELECT 
	churn,
	avg(AcceptedCmp1) avg_cmp1,
	avg(AcceptedCmp2) avg_cmp2,
	avg(AcceptedCmp3) avg_cmp3,
	avg(AcceptedCmp4) avg_cmp4,
	avg(AcceptedCmp5) avg_cmp5,
	avg(response) avg_response
FROM customer
GROUP BY churn
*/

/* 캠페인 별 수락 수
SELECT 
	sum(AcceptedCmp1) sum_cmp1,
	sum(AcceptedCmp2) sum_cmp2,
	sum(AcceptedCmp3) sum_cmp3,
	sum(AcceptedCmp4) sum_cmp4,
	sum(AcceptedCmp5) sum_cmp5,
	sum(response) sum_response
FROM customer
*/

/* 어느 캠페인도 수락하지 않은 고객수
SELECT COUNT(*) cnt
FROM customer
WHERE AcceptedCmp1 = 0 
AND AcceptedCmp2 = 0 
AND AcceptedCmp3 = 0 
AND AcceptedCmp4 = 0 
AND AcceptedCmp5 = 0 
AND response = 0 
*/