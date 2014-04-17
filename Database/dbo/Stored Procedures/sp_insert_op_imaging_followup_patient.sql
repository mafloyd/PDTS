CREATE PROCEDURE [dbo].[sp_insert_op_imaging_followup_patient]
	(
		@coid varchar(5),
		@first_name varchar(50),
		@last_name varchar(50),
		@account_number varchar(50),
		@appointment_date datetime,
		@telephone1 varchar(10),
		@telephone2 varchar(10) = null,
		@op_procedure varchar(100),
		@gender char(1),
		@created_by_user_id int = 1685,
		@referring_physician_name varchar(100),
		@referring_physician_phone varchar(10) = null
	)
AS
BEGIN
	SET NOCOUNT ON;

	if not exists
		(
			select 1
			from op_imaging_followup_patient with (nolock)
			where coid = @coid
				and account_number = @account_number
				and appointment_date = @appointment_date
		)
		begin
			insert into op_imaging_followup_patient
				(
					coid,
					first_name,
					last_name,
					account_number,
					appointment_date,
					telephone_1,
					telephone_2,
					op_procedure,
					gender,
					created_by_user_id,
					referring_physician_name,
					referring_physician_phone
				)
			values
				(
					@coid,
					@first_name,
					@last_name,
					@account_number,
					@appointment_date,
					@telephone1,
					@telephone2,
					@op_procedure,
					@gender,
					@created_by_user_id,
					@referring_physician_name,
					@referring_physician_phone
				)
		end;
    
END

