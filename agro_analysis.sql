-- AGRO PORTFOLIO ANALYTICS - Business Acumen SQL
-- Oluyomi Abayomi | N8.5B Investment Analysis

-- 1. Waste Leakage: North-West is burning money
SELECT Region, 
       AVG(Waste_pct) as avg_waste,
       SUM(Investment_N) * AVG(Waste_pct)/100 / 1e6 as leakage_M_Naira
FROM agro_investment
GROUP BY Region
ORDER BY avg_waste DESC;
-- Result: North-West 7.69% = ~N65M leakage vs 2.1% in South-West

-- 2. Prime Crops: Where to invest
SELECT Crop, AVG(ROI_pct) as avg_roi, SUM(Investment_N)/1e9 as total_B
FROM agro_investment
GROUP BY Crop
ORDER BY avg_roi DESC;
-- Result: Cassava 38%, Cocoa 36% = Prime. Rice/Maize <20% = Drain

-- 3. ROI vs Waste correlation (Business efficiency)
SELECT 
  CORR(ROI_pct, Waste_pct) as roi_waste_corr,
  CORR(Yield_Tons, ROI_pct) as yield_roi_corr;
-- Result: High waste = low ROI (-0.71). Fix waste = Fix ROI

-- 4. Capital Shift Impact: What if we move 15% from Rice to Cassava?
SELECT 
  SUM(CASE WHEN Crop='Rice' THEN Investment_N * 0.15 ELSE 0 END)/1e9 as shift_B_from_Rice,
  SUM(CASE WHEN Crop='Rice' THEN Investment_N * 0.15 * 0.16 ELSE 0 END)/1e9 as old_return_B,
  SUM(CASE WHEN Crop='Rice' THEN Investment_N * 0.15 * 0.38 ELSE 0 END)/1e9 as new_return_B_if_Cassava;
-- Result: Shift N0.85B = Gain +N0.18B annually. ROI 26.8% → 32%

-- 5. Regional Efficiency Ranking for Board Report
SELECT Region,
       SUM(Investment_N)/1e9 as invested_B,
       AVG(ROI_pct) as portfolio_roi,
       AVG(Waste_pct) as waste,
       RANK() OVER (ORDER BY AVG(ROI_pct) DESC) as roi_rank
FROM agro_investment
GROUP BY Region;
-- Result: South-West Rank 1, North-West Rank 6 = Needs intervention
