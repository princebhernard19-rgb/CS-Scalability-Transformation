/* PROJECT: Tier Zero - Efficiency Audit
GOAL: Identify ticket categories with high volume but low complexity 
to justify AI Chatbot implementation.
*/

WITH TicketMetrics AS (
    SELECT 
        ticket_category,
        COUNT(ticket_id) AS volume,
        AVG(minutes_to_resolve) AS avg_handle_time,
        SUM(case when csat_score >= 4 then 1 else 0 end) * 100.0 / COUNT(ticket_id) AS csat_percent
    FROM 
        cloudscale_support.tickets
    WHERE 
        created_at >= '2024-04-01' -- Analyzing Q2 data
        AND is_enterprise = FALSE   -- Focus on high-volume/scale segment
    GROUP BY 
        1
)

SELECT 
    ticket_category,
    volume,
    ROUND(avg_handle_time, 1) AS avg_min,
    ROUND(csat_percent, 1) AS csat_rating,
    -- The "Automation Priority Score"
    -- Logic: High volume + Low Handle Time = Highest ROI for AI
    ROUND((volume / avg_handle_time), 2) AS automation_priority_index
FROM 
    TicketMetrics
WHERE 
    volume > 100 
    AND avg_handle_time < 12 -- Targeting "quick-fix" Tier 1 noise
ORDER BY 
    automation_priority_index DESC;
