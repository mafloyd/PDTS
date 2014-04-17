CREATE PROCEDURE [dbo].[sp_insert_op_imaging_dashboard]
	(
		@coid varchar(5),
		@pat_num varchar(50),
		@order_description varchar(100),
		@arrival datetime = null,
		@registration_start datetime = null,
		@registration_end datetime = null,
		@exam_start datetime = null,
		@exam_end datetime = null,
		@prelim_report datetime = null,
		@final_report datetime = null
	)
AS
BEGIN
	SET NOCOUNT ON;

	declare @op_order_type_id int;
	declare @import int

	select @op_order_type_id = op_order_type_id,
		@import = import
	from op_imaging_dashboard_order_type_crosswalk 
	where source_type = @order_description;

	if not exists
		(
			select 1
			from op_imaging_dashboard
			where coid = @coid
				and pat_num = @pat_num
				and op_order_type_id = @op_order_type_id
				and arrival = @arrival
		)
		begin
			insert into op_imaging_dashboard
				(
					coid,
					pat_num,
					op_order_type_id,
					order_description,
					arrival,
					registration_start,
					registration_end,
					exam_start,
					exam_end,
					prelim_report,
					final_report,
					included
				)
			values 
				(
					@coid,
					@pat_num,
					@op_order_type_id,
					@order_description,
					@arrival,
					@registration_start,
					@registration_end,
					@exam_start,
					@exam_end,
					@prelim_report,
					@final_report,
					isnull(@import, 0)
				);
		end;
END

