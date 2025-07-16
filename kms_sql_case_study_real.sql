-- KMS_SQL_Insights_Report.sql
-- Author: Business Intelligence Team
-- Project: Kultra Mega Stores Inventory Case Study
-- Description: SQL queries to solve 11 real-world business questions for KMS management (2009–2012)
-- Note: Each query provides actionable business insights for strategic decision-making

-------------------------------------------------------------
-- 1. Which product category had the highest sales?
-------------------------------------------------------------
-- BUSINESS INSIGHT: This analysis reveals our most profitable product lines, helping us understand where 
-- the majority of our revenue comes from. Management can use this data to prioritize inventory investments, 
-- allocate marketing budgets more effectively, and identify which product categories drive the business.
-- High-performing categories should receive increased focus, while underperforming ones may need 
-- strategic review or promotional support.

SELECT product_category,
       ROUND(SUM(sales), 2) AS total_sales
FROM kms_case_study
GROUP BY product_category
ORDER BY total_sales DESC;

-------------------------------------------------------------
-- 2. What are the Top 3 and Bottom 3 regions in terms of sales?
-------------------------------------------------------------
-- BUSINESS INSIGHT: Understanding regional performance helps identify market opportunities and challenges.
-- Top-performing regions may warrant additional investment, expanded inventory, or new store locations.
-- Bottom-performing regions require investigation - are there market saturation issues, competition problems,
-- or operational inefficiencies? This data guides regional strategy, resource allocation, and potential
-- market expansion or consolidation decisions.

-- Top 3 regions in terms of sales?
  SELECT region,
         ROUND(SUM(sales), 2) AS total_sales
  FROM kms_case_study
  GROUP BY region
  ORDER BY total_sales DESC
  LIMIT 3;

--   Bottom 3 regions in terms of sales?
  SELECT region,
         ROUND(SUM(sales), 2) AS total_sales
  FROM kms_case_study
  GROUP BY region
  ORDER BY total_sales
  LIMIT 3;


-------------------------------------------------------------
-- 3. Total sales of appliances in Ontario
-------------------------------------------------------------
-- BUSINESS INSIGHT: Focused regional-category analysis provides granular insights for location-based
-- product strategies. Understanding how specific product categories perform in particular regions helps
-- optimize inventory distribution, tailor marketing campaigns, and identify regional preferences.
-- This data supports decisions about product mix, seasonal stocking, and regional promotional strategies.

SELECT region,
       ROUND(SUM(sales), 2) AS appliance_sales
FROM kms_case_study
WHERE product_sub_category = 'Appliances'
  AND region = 'Ontario'
GROUP BY region;

-------------------------------------------------------------
-- 4. Bottom 10 customers by revenue
-------------------------------------------------------------
-- BUSINESS INSIGHT: Identifying low-revenue customers helps develop targeted retention strategies.
-- These customers may benefit from personalized offers, loyalty programs, or improved service experiences.
-- Understanding their segments and purchasing patterns can reveal opportunities to increase engagement,
-- cross-sell additional products, or improve customer satisfaction to boost their lifetime value.

SELECT customer_name,
       customer_segment,
       region,
       product_category,
       product_sub_category,
       ROUND(SUM(sales), 2) AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM kms_case_study
GROUP BY customer_name, customer_segment, region, product_category, product_sub_category
ORDER BY total_sales ASC
LIMIT 10;

-------------------------------------------------------------
-- 5. Shipping cost by mode — which incurred the most cost?
-------------------------------------------------------------
-- BUSINESS INSIGHT: Shipping cost analysis reveals potential optimization opportunities in logistics operations.
-- High-cost shipping modes may indicate inefficient processes or overuse of premium services.
-- This data helps negotiate better rates with carriers, optimize shipping strategies, and potentially
-- reduce operational costs while maintaining customer satisfaction. It also guides pricing strategies
-- for different shipping options offered to customers.

SELECT ship_mode,
       ROUND(SUM(shipping_cost), 2) AS total_shipping_cost,
       COUNT(*) AS total_shipments
FROM kms_case_study
GROUP BY ship_mode
ORDER BY total_shipping_cost DESC;

-------------------------------------------------------------
-- 6. Top 5 most valuable customers by revenue and profit
-------------------------------------------------------------
-- BUSINESS INSIGHT: These are the customers who drive the most value for the business and deserve
-- VIP treatment. Understanding their characteristics helps create customer success programs, develop
-- retention strategies, and identify patterns that can be replicated to attract similar high-value customers.
-- These customers should receive priority service, exclusive offers, and personalized attention to ensure
-- long-term loyalty and continued growth.

SELECT customer_name,
       ROUND(SUM(sales), 2) AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM kms_case_study
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;

-------------------------------------------------------------
-- 7. Top small business customer by sales
-------------------------------------------------------------
-- BUSINESS INSIGHT: Understanding the top performer in the small business segment reveals successful
-- patterns that can be replicated across the SME customer base. This insight helps develop targeted
-- B2B marketing strategies, create industry-specific solutions, and identify opportunities for business
-- account expansion. The success factors of this customer can inform acquisition strategies for
-- similar small business prospects.

SELECT customer_name,
       ROUND(SUM(sales), 2) AS total_sales
FROM kms_case_study
WHERE customer_segment = 'Small Business'
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 1;

-------------------------------------------------------------
-- 8. Corporate customer with the most orders (2009–2012)
-------------------------------------------------------------
-- BUSINESS INSIGHT: High-frequency corporate customers indicate strong business relationships and
-- potential for supply chain partnerships. These customers demonstrate consistent demand and may be
-- candidates for contract negotiations, bulk pricing agreements, or strategic partnerships.
-- Understanding their ordering patterns helps forecast demand, optimize inventory levels, and
-- develop corporate account management strategies.

SELECT customer_name,
       COUNT(DISTINCT order_id) AS order_count
FROM kms_case_study
WHERE customer_segment = 'Corporate'
GROUP BY customer_name
ORDER BY order_count DESC
LIMIT 1;

-------------------------------------------------------------
-- 9. Most profitable consumer customer
-------------------------------------------------------------
-- BUSINESS INSIGHT: This customer represents the ideal consumer profile, generating the highest margins
-- rather than just volume. Understanding their purchasing behavior, preferences, and characteristics
-- helps develop targeted marketing strategies for similar consumers. This insight guides customer
-- acquisition efforts, promotional strategies, and product recommendations to maximize profitability
-- from individual consumers.

SELECT customer_name,
       ROUND(SUM(profit), 2) AS total_profit
FROM kms_case_study
WHERE customer_segment = 'Consumer'
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 1;

-------------------------------------------------------------
-- 10. Customers who returned items + their segment
-------------------------------------------------------------
-- BUSINESS INSIGHT: Return analysis identifies potential quality issues, customer dissatisfaction,
-- or product-market mismatch. Understanding which customer segments are returning items helps
-- address systemic problems, improve product quality, or adjust marketing messages. This data
-- guides customer service improvements, product development decisions, and may indicate opportunities
-- for better customer education or expectation management.

SELECT DISTINCT k.customer_name,
       k.customer_segment
FROM kms_case_study k
JOIN order_status o 
  ON k.`order_id` = o.`Order ID`
WHERE o.`Status` = 'Returned';



select *
From kms_sql_case_study2;




-------------------------------------------------------------
-- 11. Was shipping cost aligned with order priority?
-------------------------------------------------------------
-- BUSINESS INSIGHT: This analysis validates whether premium shipping options are being used appropriately
-- based on order urgency. Misalignment between order priority and shipping costs may indicate
-- operational inefficiencies or customer service issues. Proper alignment ensures cost-effective
-- logistics while meeting customer expectations. This data helps optimize shipping policies,
-- pricing strategies, and operational procedures.

SELECT order_priority,
       ship_mode,
       ROUND(SUM(shipping_cost), 2) AS total_shipping_cost
FROM kms_case_study
GROUP BY order_priority, ship_mode
ORDER BY order_priority, total_shipping_cost DESC;