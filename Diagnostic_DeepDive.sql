-- 1. Tìm nguyên nhân: Có phải do Agency ép giá cao gây Churn?
WITH AgencyAnalysis AS (
    SELECT 
        agency,
        AVG(price/distance) as price_per_km, -- Tính Unit Price
        COUNT(travelCode) as total_trips
    FROM flights
    GROUP BY agency
)
SELECT * FROM AgencyAnalysis ORDER BY price_per_km DESC;

-- 2. Chẩn đoán rủi rỏ theo Công ty (ERP Perspective)
-- Kiểm tra xem công ty nào đang "rò rỉ" doanh thu khách sạn nhiều nhất
SELECT 
    u.company,
    AVG(m.has_hotel) * 100 as hotel_adoption_rate,
    AVG(CAST(m.is_churned AS FLOAT)) * 100 as churn_rate
FROM df_master m
JOIN users u ON m.userCode = u.code
GROUP BY u.company
HAVING hotel_adoption_rate < 50; -- Lọc ra các công ty có lỗ hổng lớn