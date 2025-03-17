SELECT
a.usage_date,
a.usage_start_time,
a.workspace_id,
a.sku_name,
b.usage_metadata.job_id,
b.usage_metadata.job_name,
sum(a.usage_quantity) as `Usage`
FROM
  system.billing.usage a INNER JOIN 
  (select * from system.billing.usage where date(usage_start_time)>='2024-12-01' and sku_name LIKE ('%ENTERPRISE_JOBS_SERVERLESS%') and usage_metadata.job_id IS NOT NULL) b
ON a.usage_start_time=b.usage_start_time and b.usage_end_time=a.usage_end_time
WHERE
  a.workspace_id=b.workspace_id
  AND a.sku_name LIKE ('%PUBLIC_CONNECTIVITY%')
  AND date(a.usage_start_time)>='2024-12-01'
GROUP BY a.usage_date, a.usage_start_time, a.workspace_id, a.sku_name, b.usage_metadata.job_id, b.usage_metadata.job_name
ORDER by usage_start_time ASC
