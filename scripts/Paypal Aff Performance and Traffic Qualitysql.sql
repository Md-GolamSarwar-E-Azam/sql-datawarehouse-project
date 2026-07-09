SELECT
	idw.it_date,
	fuvev.department ,
	cve.partner_display_name,
	idw.campaign_id,
	idw.campaign_display_name,
	idw.source,
	idw.sub_source,
	cve.country AS geo,
	idw.offer_display_name,
	SUM(idw.full_calculated_spend) AS full_calculated_spend,
	SUM(CASE WHEN idw.yes = 1 THEN 1 ELSE 0 END) AS yes_count,
	COUNT(DISTINCT idw.session_id) AS session_count,
	COUNT(DISTINCT CASE WHEN idw.transaction_id is not null then idw.session_id  END) AS billed_user_count,
	SUM(CASE WHEN idw.pixel_fired = 1 THEN 1 ELSE 0 END) AS pixel_fired_count,
	SUM(idw.yr1_user_value_revenue) AS yr1_user_value_revenue,
	SUM(idw.yr1_user_value_billed_revenue) AS yr1_user_value_billed_revenue,
	SUM(idw.adjusted_yr1_user_value_billed_revenue) AS adjusted_yr1_user_value_billed_revenue,
	SUM(idw.complete_yr1_user_value_billed_revenue) AS complete_yr1_user_value_billed_revenue,
	SUM(idw.unique_visits) AS unique_visits,
	SUM(idw.page_load_unique) AS page_load_unique,
	SUM(idw.msisdn_email_valid) AS msisdn_email_valid,
	SUM(idw.step_1_success) AS step_1_success,
	SUM(idw.pin_valid) AS pin_valid,
	SUM(idw.utc_id_user) AS utc_id_user,
	SUM(idw.`lead`) AS lead_count,
	SUM(idw.cva_cpc) AS cva_cpc,
	SUM(idw.utc_dts_start) AS utc_dts_start,
	SUM(idw.conversion_rate) AS conversion_rate,
	SUM(idw.cva_cpa) AS cva_cpa,
	SUM(idw.cva_spend_on) AS cva_spend_on,
	SUM(idw.billed_message_count) AS billed_message_count,
	SUM(IF(idw.billed_message_count > 0, 1, 0)) AS billed_flag,--
	SUM(IF(idw.yr1_user_value_billed_revenue > 0, 1, 0)) AS billed_wk1_flag,--
	SUM(idw.bt_adjustment_billed) AS bt_adjustment_billed,
	SUM(idw.yr1_bt_value) AS yr1_bt_value,
	SUM(idw.overheads_deduction_pc) AS overheads_deduction_pc,
	SUM(idw.dispute_opened_count) AS dispute_opened_count,
	SUM(idw.dispute_won_count) AS dispute_won_count,
	SUM(idw.dispute_lost_count) AS dispute_lost_count,
	SUM(idw.refund_count) AS refund_count,
	SUM(idw.chargeback_count) AS chargeback_count,
	SUM(idw.alert_count) AS alert_count,
	SUM(idw.internal_dispute_count) AS internal_dispute_count,
	SUM(idw.external_dispute_count) AS external_dispute_count,
	SUM(idw.internal_dispute_wk1_count) AS internal_dispute_wk1_count,
	SUM(idw.external_dispute_wk3_count) AS external_dispute_wk3_count,
	SUM(idw.spend_per_day) AS spend_per_day,
	SUM(idw.sessions_in_group) AS sessions_in_group,
	SUM(idw.cache_stats_spend) AS cache_stats_spend,
	SUM(idw.google_spend_allocated) AS google_spend_allocated,
	SUM(idw.google_clicks_allocated) AS google_clicks_allocated,
	SUM(idw.google_impressions_allocated) AS google_impressions_allocated,
	SUM(idw.google_conversions_allocated) AS google_conversions_allocated,
	SUM(idw.spend_by_session) AS spend_by_session,
	SUM(idw.exit_traffic_revenue) AS exit_traffic_revenue,
	SUM(idw.exit_traffic_revenue_allocated) AS exit_traffic_revenue_allocated,
	SUM(CASE WHEN idw.b_wk1 = 1 THEN 1 ELSE 0 END) b_wk1
FROM
	data_playground.icat_data_warehouse idw USE INDEX (idx_it_date)
LEFT JOIN config.config_v2_expanded cve USING(synd_id)
LEFT JOIN juicy_logger_v2.forecasted_user_value_extended_v2 fuvev  
ON fuvev.partner_display_name = cve.partner_display_name 
AND fuvev.country = cve.country 
AND fuvev.billing_partner = cve.billing_partner 
WHERE
-- 	idw.it_date >= CURDATE()-INTERVAL 11 MONTH
idw.it_date >= CURDATE()-INTERVAL 11 MONTH and cve.billing_partner = 'PayPal'
GROUP BY
	idw.it_date,
	fuvev.department ,
	cve.partner_display_name,
	idw.campaign_id,
	idw.campaign_display_name,
	idw.source,
	idw.sub_source,
	cve.country,
	idw.offer_display_name
	
	
SHOW FULL PROCESSLIST;
	
KILL 464144;



SELECT date_day,SUM(cap) cap 
FROM data_playground.caps_per_day_report
WHERE traffic_buyer = 'Affiliates' and service = 'PayPal'
AND date_day >= CURDATE()-INTERVAL 11 MONTH
GROUP BY date_day


SELECT cpdr.*, ss.service_display_name as service_name
FROM data_playground.caps_per_day_report cpdr
LEFT JOIN config.smart_services ss ON ss.id_smart_service = cpdr.id_smart_service
WHERE TRUE



