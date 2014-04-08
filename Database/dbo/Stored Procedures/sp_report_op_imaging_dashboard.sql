CREATE PROCEDURE [dbo].[sp_report_op_imaging_dashboard]
	(
		@coid varchar(5) = null,
		@division_id int = null,
		@reportDateFrom datetime,
		@reportDateTo datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

	if @coid is not null
		begin
			select a.*, 
				f.name as facility, 
				c.name as order_type, 
				c.sort_order as order_type_sort_order,
				d.name as group_name,
				d.division_id
			from op_imaging_dashboard a with (nolock)
				join facility f with (nolock)
					on a.coid = f.coid

				join Division d with (nolock)
					on f.division_id = d.division_id

				join op_order_type c with (nolock)
					on a.op_order_type_id = c.op_order_type_id
			where a.coid = @coid
				and arrival between @reportDateFrom and @reportDateTo
		end;
	else if @division_id is not null
		begin
			if @division_id = 1
				begin
					select a.*, 
						f.name as facility, 
						c.name as order_type, 
						c.sort_order as order_type_sort_order,
						d.name as group_name,
						d.division_id
					from op_imaging_dashboard a with (nolock)
						join facility f with (nolock)
							on a.coid = f.coid

						join Division d with (nolock)
							on f.division_id = d.division_id

						join op_order_type c with (nolock)
							on a.op_order_type_id = c.op_order_type_id
					where arrival between @reportDateFrom and @reportDateTo
				end;
			else
				begin
					select a.*, 
						f.name as facility, 
						c.name as order_type, 
						c.sort_order as order_type_sort_order,
						d.name as group_name,
						d.division_id
					from op_imaging_dashboard a with (nolock)
						join facility f with (nolock)
							on a.coid = f.coid

						join Division d with (nolock)
							on f.division_id = d.division_id

						join op_order_type c with (nolock)
							on a.op_order_type_id = c.op_order_type_id
					where f.division_id = @division_id
						and arrival between @reportDateFrom and @reportDateTo
				end;
		end;
END

