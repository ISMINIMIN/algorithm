WITH DATE_DIFF AS (
    SELECT CAR_TYPE, DAILY_FEE, HISTORY_ID, DATEDIFF(END_DATE, START_DATE) + 1 AS PERIOD,
           CASE
                WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 90 THEN '90일 이상'
                WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 30 THEN '30일 이상'
                WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 7 THEN '7일 이상'
                ELSE 'NONE'
           END AS DURATION_TYPE
    FROM CAR_RENTAL_COMPANY_CAR CRC
    JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY CRH
    ON CRC.CAR_ID = CRH.CAR_ID
    WHERE CRC.CAR_TYPE = '트럭'
)

SELECT HISTORY_ID, ROUND(DAILY_FEE * PERIOD * (100 - IFNULL(DISCOUNT_RATE, 0)) / 100) AS FEE
FROM DATE_DIFF DD
LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN CDP
ON DD.DURATION_TYPE = CDP.DURATION_TYPE AND DD.CAR_TYPE = CDP.CAR_TYPE
ORDER BY FEE DESC, HISTORY_ID DESC;