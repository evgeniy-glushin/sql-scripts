select top 250
	substring(qt.text, (qs.statement_start_offset / 2) + 1,
		((
			case qs.statement_end_offset
				when -1 then datalength(qt.text)
				else qs.statement_end_offset
			end - qs.statement_start_offset) / 2) + 1) as sql,
	qs.execution_count as [exec count],
	(qs.total_logical_reads + qs.total_logical_writes) / qs.execution_count as [avg io],
	qp.query_plan,
	qs.total_logical_reads,
	qs.total_logical_writes,
	qs.total_worker_time,
	qs.total_rows,
	qs.last_rows,
	qs.min_rows,
	qs.max_rows,
	qs.last_worker_time,
	qs.last_logical_reads,
	qs.last_logical_writes,
	qs.total_elapsed_time / 1000 as total_elapsed_time_in_ms,
	qs.last_elapsed_time / 1000 as last_elapsed_time_in_ms,
	qs.last_execution_time
from sys.dm_exec_query_stats qs 
		cross apply sys.dm_exec_sql_text(qs.sql_handle) qt
		outer apply sys.dm_exec_query_plan(qs.plan_handle) qp
order by [avg io] desc
option (recompile)

--------------

select *
from sys.dm_db_index_operational_stats(db_id(),  object_id(N'[dbo].[cache_CompanyProductLoc]'), null, null)

--------------


select *
from sys.dm_db_index_physical_stats(db_id(),  object_id(N'[dbo].[cache_CompanyProductLoc]'), null, null, 'DETAILED')

--set statistics io on
select *
from [dbo].[cache_CompanyProductLoc]
where companyId = 2   --reads 5519


-------------

select *
from sys.dm_db_index_usage_stats us
where us.database_id = db_id() and
	  us.object_id = object_id(N'dbo.OrderDetails')
order by
	  us.index_id

------------------------

DBCC FREEPROCCACHE

------------------------

dbcc show_statistics('dbo.Product', 'IX_FamilyId')
with histogram

------------------------


EXEC sp_updatestats