ALTER TABLE services_data
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id) REFERENCES branch_data(Branch_ID);

SELECT b.Region, s.service_date AS ServiceDate, SUM(s.total_revenue) AS TotalRevenue
FROM services_data s
JOIN branch_data b ON s.branch_id = b.Branch_ID
GROUP BY b.Region, s.service_date
ORDER BY TotalRevenue DESC;

SELECT department, service_date AS ServiceDate, SUM(total_revenue) AS TotalRevenue
FROM services_data
GROUP BY department, service_date
ORDER BY TotalRevenue DESC;

SELECT client_name, service_date AS ServiceDate, SUM(total_revenue) AS TotalRevenue
FROM services_data
GROUP BY client_name, service_date
ORDER BY TotalRevenue DESC

SELECT SUM(total_revenue) AS TotalRevenue
FROM services_data

SELECT SUM(hours) AS TotalHours
FROM services_data

SELECT department, SUM(total_revenue) AS DepartmentRevenue, (SUM(total_revenue)/(SELECT SUM(total_revenue) FROM services_data))*100 AS RevenuePercentage
FROM services_data
GROUP BY department;

WITH MonthlyRevenue AS (
    SELECT 
        FORMAT(service_date, 'yyyy-MM') AS Month, 
        SUM(total_revenue) AS Revenue
    FROM services_data
    GROUP BY FORMAT(service_date, 'yyyy-MM')
),
RevenueComparison AS (
    SELECT 
        Month, 
        Revenue, 
        LAG(Revenue) OVER (ORDER BY CAST(Month + '-01' AS DATE)) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT 
    Month, 
    Revenue, 
    PreviousMonthRevenue, 
    ((Revenue - PreviousMonthRevenue) / PreviousMonthRevenue) * 100 AS RevenuePercentageIncrease
FROM RevenueComparison
WHERE PreviousMonthRevenue IS NOT NULL;
